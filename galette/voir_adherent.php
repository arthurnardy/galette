<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Show a member, and possibility to:
 * - change its values
 * - show its contributions
 * - add a new contribution
 * - generate PDF memger card
 *
 * PHP version 5
 *
 * Copyright © 2003-2012 The Galette Team
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
 * @category  Main
 * @package   Galette
 *
 * @author    Frédéric Jacquot <unknown@unknwown.com>
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2003-2012 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   SVN: $Id$
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.60
 */

/** @ignore */
require_once 'includes/galette.inc.php';

if ( !$login->isLogged() ) {
    header('location: index.php');
    die();
}

$id_adh = get_numeric_form_value('id_adh', '');

if ( !$login->isSuperAdmin() ) {
    if ( !$login->isAdmin() && !$login->isStaff() && !$login->isGroupManager()
        || $login->isAdmin() && $id_adh == ''
        || $login->isStaff() && $id_adh == ''
        || $login->isGroupManager() && $id_adh == ''
    ) {
        $id_adh = $login->id;
    }
}
if ( $id_adh == '' ) {
    header('location: index.php');
    die();
}
if ( isset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['pdf_error'])
    && $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['pdf_error']
) {
    $error_detected[] = $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['pdf_error_msg'];
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['pdf_error_msg']);
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['pdf_error']);
}

if ( isset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_errors']) ) {
    $error_detected = unserialize(
        $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_errors']
    );
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_errors']);
}

if ( isset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_success']) ) {
    $success_detected = unserialize(
        $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_success']
    );
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['lostpasswd_success']);
}

require_once WEB_ROOT . 'includes/dynamic_fields.inc.php';

$member = new Galette\Entity\Adherent();
$member->load($id_adh);

if ( $login->id != $id_adh && !$login->isAdmin() && !$login->isStaff() ) {
    //check if requested member is part of managed groups
    $groups = $member->groups;
    $is_managed = false;
    foreach ( $groups as $g ) {
        if ( $login->isGroupManager($g->getId()) ) {
            $is_managed = true;
            break;
        }
    }
    if ( $is_managed !== true ) {
        //requested member is not part of managed groups, fall back to logged
        //in member
        $member->load($login->id);
    }
}

$navigate = array();

$session = $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB];
if ( isset($session['filters']['members']) ) {
    $filters =  unserialize($session['filters']['members']);
} else {
    $filters = new MembersList();
}

if ( count($filters) > 0 ) {
    $m = new Galette\Repository\Members();
    $ids = $m->getList(false, array(Galette\Entity\Adherent::PK));
    //print_r($ids);
    foreach ( $ids as $k=>$m ) {
        if ( $m->id_adh == $member->id ) {
            $navigate = array(
                'cur'  => $m->id_adh,
                'count' => count($ids),
                'pos' => $k+1
            );
            if ( $k > 0 ) {
                $navigate['prev'] = $ids[$k-1]->id_adh;
            }
            if ( $k < count($ids)-1 ) {
                $navigate['next'] = $ids[$k+1]->id_adh;
            }
            break;
        }
    }
}

// Set caller page ref for cards error reporting
$_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['caller']='voir_adherent.php?id_adh='.$id_adh;

// declare dynamic field values
$adherent['dyn'] = get_dynamic_fields('adh', $id_adh, true);

// - declare dynamic fields for display
$disabled['dyn'] = array();
$dynamic_fields = prepare_dynamic_fields_for_display(
    'adh',
    $adherent['dyn'],
    $disabled['dyn'],
    0
);

if ( isset($error_detected) ) {
    $tpl->assign('error_detected', $error_detected);
}
$tpl->assign('page_title', _T("Member Profile"));
$tpl->assign('require_dialog', true);
$tpl->assign('member', $member);
$tpl->assign('navigate', $navigate);
$tpl->assign('pref_lang_img', $i18n->getFlagFromId($member->language));
$tpl->assign('pref_lang', ucfirst($i18n->getNameFromId($member->language)));
$tpl->assign('pref_card_self', $preferences->pref_card_self);
$tpl->assign('dynamic_fields', $dynamic_fields);
$tpl->assign('groups', Galette\Repository\Groups::getSimpleList());
$tpl->assign('time', time());
//if we got a mail warning when adding/editing a member,
//we show it and delete it from session
if ( isset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['mail_warning']) ) {
    $warning_detected[] = $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['mail_warning'];
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['mail_warning']);
}
$tpl->assign('warning_detected', $warning_detected);
if ( isset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['account_success']) ) {
    $success_detected = unserialize(
        $_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['account_success']
    );
    unset($_SESSION['galette'][PREFIX_DB . '_' . NAME_DB]['account_success']);
}
$tpl->assign('success_detected', $success_detected);
$content = $tpl->fetch('voir_adherent.tpl');
$tpl->assign('content', $content);
$tpl->display('page.tpl');
?>
