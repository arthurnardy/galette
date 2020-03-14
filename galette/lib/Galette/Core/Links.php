<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Temporay links for galette, to send direct links to invoices, recipts,
 * and member cards directly by email
 *
 * PHP version 5
 *
 * Copyright © 2020 The Galette Team
 *
 * This file is part of Galette (http://galette.tuxfamily.org).
 *
 * Galette is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Galette is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Galette. If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  Core
 * @package   Galette
 *
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2020 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.9.4 - 2020-03-11
 */

namespace Galette\Core;

use Analog\Analog;
use Galette\Entity\Adherent;

/**
 * Temporary password managment
 *
 * @category  Core
 * @name      Links
 * @package   Galette
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2020 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.9.4 - 2020-03-11
 */

class Links
{
    const TABLE = 'tmplinks';
    const PK = 'hash';

    const TARGET_MEMBERCARD = 1;
    const TARGET_INVOICE    = 2;
    const TARGET_RECEIPT    = 3;

    private $zdb;

    /**
     * Default constructor
     *
     * @param Db      $zdb   Database instance:
     * @param boolean $clean Whether we should clean expired links in database
     */
    public function __construct(Db $zdb, $clean = true)
    {
        $this->zdb = $zdb;
        if ($clean === true) {
            $this->cleanExpired();
        }
    }

    /**
     * Remove all old entry
     *
     * @param int $target Target (one of self::TARGET_* constants)
     * @param int $id     Target identifier
     *
     * @return boolean
     */
    private function removeOldEntry($target, $id)
    {
        try {
            $delete = $this->zdb->delete(self::TABLE);
            $delete->where([
                'target'    => $target,
                'id'        => $id
            ]);

            $del = $this->zdb->execute($delete);
            if ($del) {
                Analog::log(
                    'Temporary link for `' . $target .'-' . $id  . '` has been removed.',
                    Analog::DEBUG
                );
            }
        } catch (\Exception $e) {
            Analog::log(
                'An error has occurred removing old temporary link ' .
                $e->getMessage(),
                Analog::ERROR
            );
            return false;
        }
    }

    /**
     * Generates a new link for specified target
     *
     * @param int $target Target (one of self::TARGET_* constants)
     * @param int $id     Target identifier
     *
     * @return false|[code, hash]
     */
    public function generateNewLink($target, $id)
    {
        //first of all, we'll remove all existant entries for specified id
        $this->removeOldEntry($target, $id);

        //second, generate a new hash and store it in the database
        //hash is a password for generated code that is sent only in the email.
        $code = mt_rand(100000, 999999);
        $hash = password_hash($code, PASSWORD_BCRYPT);

        try {
            $values = array(
                'target'        => $target,
                'id'            => $id,
                'creation_date' => date('Y-m-d H:i:s'),
                'hash'          => $hash
            );

            $insert = $this->zdb->insert(self::TABLE);
            $insert->values($values);

            $add = $this->zdb->execute($insert);
            if ($add) {
                Analog::log(
                    'New temporary link set for `' . $target . '-' . $id . '`.',
                    Analog::DEBUG
                );
                return [$code, base64_encode($hash)];
            }
            return false;
        } catch (\Exception $e) {
            Analog::log(
                "An error occurred trying to add temporary link entry. " .
                $e->getMessage(),
                Analog::ERROR
            );
            return false;
        }
    }

    /**
     * Remove expired links queries (older than 1 week)
     *
     * @return boolean
     */
    protected function cleanExpired()
    {
        $date = new \DateTime();
        $date->sub(new \DateInterval('PT1W'));

        try {
            $delete = $this->zdb->delete(self::TABLE);
            $delete->where->lessThan(
                'creation_date',
                $date->format('Y-m-d H:i:s')
            );
            $del = $this->zdb->execute($delete);
            if ($del) {
                Analog::log(
                    'Expired temporary links has been deleted.',
                    Analog::DEBUG
                );
            }
        } catch (\Exception $e) {
            Analog::log(
                'An error occurred deleting expired temporary links. ' .
                $e->getMessage(),
                Analog::WARNING
            );
            return false;
        }
    }

    /**
     * Check if requested hash is valid
     *
     * @param string $hash the hash, base64 encoded
     * @param string $code Code sent to validate link
     *
     * @return false if hash is not valid, ?? otherwise
     */
    public function isHashValid($hash, $code)
    {
        try {
            $hash = base64_decode($hash);
            $select = $this->zdb->select(self::TABLE);
            $select->columns(
                array(self::PK)
            )->where(array('hash' => $hash));

            $results = $this->zdb->execute($select);

            if ($results->count() > 0) {
                $result = $results->current();
                if (password_verify($code, $result->hash)) {
                    return [$result->target, $result->id];
                }
            }
            return false;
        } catch (\Exception $e) {
            Analog::log(
                'An error occurred getting requested hash. ' . $e->getMessage(),
                Analog::WARNING
            );
            return false;
        }
    }

    /**
     * Remove a hash that has been used (ie. once password has been updated)
     *
     * @param string $hash hash
     *
     * @return boolean
     */
    public function removeHash($hash)
    {
        try {
            $delete = $this->zdb->delete(self::TABLE);
            $delete->where(
                array('hash' => $hash)
            );

            $del = $this->zdb->execute($delete);
            if ($del) {
                Analog::log(
                    'Hash has been successfully removed',
                    Analog::DEBUG
                );
                return true;
            }
        } catch (\Exception $e) {
            Analog::log(
                'An error ocured attempting to delete hash' .
                $e->getMessage(),
                Analog::WARNING
            );
            return false;
        }
    }
}
