        <div class="ui left vertical menu sidebar">
{if $login->isLogged()}
            <div class="item">
                <a class="button" title="{_T string="View your member card"}" href="{if $login->isSuperAdmin()}{path_for name="slash"}{else}{path_for name="me"}{/if}">{$login->loggedInAs(true)}</a>
                <a class="button" href="{if $login->isImpersonated()}{path_for name="unimpersonate"}{else}{path_for name="logout"}{/if}">
                    <i class="icon {if $login->isImpersonated()}user secret{else}sign out alt{/if}"></i>
                    <span class="sr-only">{_T string="Log off"}</span>
                </a>
            </div>
            <div class="item" title="{_T string="Navigation"}">
                <div class="image header title">
                    <i class="icon compass outline" aria-hidden="true"></i>
                    {_T string="Navigation"}
                </div>
                <div class="menu">
                    <a href="{path_for name="dashboard"}" title="{_T string="Go to Galette's dashboard"}" class="{if $cur_route eq "dashboard"}active {/if}item">{_T string="Dashboard"}</a>
    {if $login->isAdmin() or $login->isStaff()}
                    <a href="{path_for name="members"}" title="{_T string="View, search into and filter member's list"}" class="{if $cur_route eq "members"}active {/if}item">{_T string="List of members"}</a>
                    <a href="{path_for name="advanced-search"}" title="{_T string="Perform advanced search into members list"}" class="{if $cur_route eq "advanced-search"}active {/if}item">{_T string="Advanced search"}</a>
                    <a href="{path_for name="searches"}" title="{_T string="Saved searches"}" class="{if $cur_route eq "searches"}active {/if}item">{_T string="Saved searches"}</a>
                    <a href="{path_for name="groups"}" title="{_T string="View and manage groups"}" class="{if $cur_route eq "groups"}active {/if}item">{_T string="Manage groups"}</a>
        {if $login->isAdmin() or $login->isStaff() or $login->isGroupManager()}
                    <a href="{path_for name="contributions" data=["type" => "contributions"]}" title="{_T string="View and filter contributions"}" class="{if $cur_route eq "contributions" and $cur_subroute eq "contributions"}active {/if}item">{_T string="List of contributions"}</a>
                    <a href="{path_for name="contributions" data=["type" => "transactions"]}" title="{_T string="View and filter transactions"}" class="{if $cur_route eq "contributions" and $cur_subroute eq "transactions"}active {/if}item">{_T string="List of transactions"}</a>
                    <a href="{path_for name="editmember" data=["action" => "add"]}" title="{_T string="Add new member in database"}" class="{if $cur_route eq "editmember"}active {/if}item">{_T string="Add a member"}</a>
                    <a href="{path_for name="contribution" data=["type" => "fee", "action" => "add"]}" title="{_T string="Add new membership fee in database"}" class="{if $cur_route eq "contribution" and $cur_subroute eq "fee"}active {/if}item">{_T string="Add a membership fee"}</a>
                    <a href="{path_for name="contribution" data=["type" => "donation", "action" => "add"]}" title="{_T string="Add new donation in database"}" class="{if $cur_route eq "contribution" and $cur_subroute eq "donation"}active {/if}item">{_T string="Add a donation"}</a>
                    <a href="{path_for name="transaction" data=["action" => "add"]}" title="{_T string="Add new transaction in database"}" class="{if $cur_route eq "transaction"}active {/if}item">{_T string="Add a transaction"}</a>
                    <a href="{path_for name="reminders"}" title="{_T string="Send reminders to late members"}" class="{if $cur_route eq "reminders"}active {/if}item">{_T string="Reminders"}</a>
                    <a href="{path_for name="history"}" title="{_T string="View application's logs"}" class="{if $cur_route eq "history"}active {/if}item">{_T string="Logs"}</a>
                    <a href="{path_for name="mailings"}" title="{_T string="Manage mailings that has been sent"}" class="{if $cur_route eq "mailings"}active {/if}item">{_T string="Manage mailings"}</a>
                    <a href="{path_for name="export"}" title="{_T string="Export some data in various formats"}" class="{if $cur_route eq "export"}active {/if}item">{_T string="Exports"}</a>
                    <a href="{path_for name="import"}" title="{_T string="Import members from CSV files"}" class="{if $cur_route eq "import" or $cur_route eq "importModel"}active {/if}item">{_T string="Imports"}</a>
                    <a href="{path_for name="charts"}" title="{_T string="Various charts"}" class="{if $cur_route eq "charts"} active{/if}item">{_T string="Charts"}</a>
        {else}
                    <a href="{path_for name="contributions" data=["type" => "contributions"]}" title="{_T string="View and filter all my contributions"}" class="{if $cur_route eq "contributions" and $cur_subroute eq "contributions"}active {/if}item">{_T string="My contributions"}</a>
                    <a href="{path_for name="contributions" data=["type" => "transactions"]}" title="{_T string="View and filter all my transactions"}" class="{if $cur_route eq "contributions" and $cur_subroute eq "transactions"}active {/if}item">{_T string="My transactions"}</a>
        {/if}
    {/if}
    {if not $login->isSuperAdmin()}
                    <a href="{path_for name="me"}" title="{_T string="View my member card"}" class="{if $cur_route eq "me" or $cur_route eq "member"}active {/if}item">{_T string="My information"}</a>
    {/if}
                </div>
            </div>
    {if $preferences->showPublicPages($login) eq true}
            <div class="item" title="{_T string="Public pages"}">
                <div class="image header title">
                    <i class="icon eye outline" aria-hidden="true"></i>
                    {_T string="Public pages"}
                </div>
                <div class="menu">
                    <a href="{path_for name="publicList" data=["type" => "list"]}" title="{_T string="Members list"}" class="{if $cur_route eq "publicList" and $cur_subroute eq "list"}active {/if}item">{_T string="Members list"}</a>
                    <a href="{path_for name="publicList" data=["type" => "trombi"]}" title="{_T string="Trombinoscope"}" class="{if $cur_route eq "publicList" and $cur_subroute eq "trombi"}active {/if}item">{_T string="Trombinoscope"}</a>
                    {* Include plugins menu entries *}
                    {$plugins->getPublicMenus($tpl, true)}
                </div>
            </div>
    {/if}
    {if $login->isAdmin()}
            <div class="item" title="{_T string="Configuration"}">
                <div class="image header title">
                    <i class="icon tools" aria-hidden="true"></i>
                    {_T string="Configuration"}
                </div>
                <div class="menu">
                        <a href="{path_for name="preferences"}" title="{_T string="Set applications preferences (address, website, member's cards configuration, ...)"}" class="{if $cur_route eq "preferences"}active {/if}item">{_T string="Settings"}</a>
                        <a href="{path_for name="plugins"}" title="{_T string="Informations about available plugins"}" class="{if $cur_route eq "plugins"}active {/if}item">{_T string="Plugins"}</a>
                        <a href="{path_for name="configureCoreFields"}" title="{_T string="Customize fields order, set which are required, and for who they're visibles"}" class="{if $cur_route eq "configureCoreFields"}active {/if}item">{_T string="Core fields"}</a>
                        <a href="{path_for name="configureDynamicFields"}" title="{_T string="Manage additional fields for various forms"}" class="{if $cur_route eq "configureDynamicFields" or $cur_route eq 'editDynamicField'}active {/if}item">{_T string="Dynamic fields"}</a>
                        <a href="{path_for name="dynamicTranslations"}" title="{_T string="Translate additionnals fields labels"}" class="{if $cur_route eq "dynamicTranslations"}active {/if}item">{_T string="Translate labels"}</a>
                        <a href="{path_for name="entitleds" data=["class" => "status"]}" title="{_T string="Manage statuses"}" class="{if $cur_route eq "entitleds" and $cur_subroute eq "status"}active {/if}item">{_T string="Manage statuses"}</a>
                        <a href="{path_for name="entitleds" data=["class" => "contributions-types"]}" title="{_T string="Manage contributions types"}" class="{if $cur_route eq "entitleds" and $cur_subroute eq "contributions-types"}active {/if}item">{_T string="Contributions types"}</a>
                        <a href="{path_for name="texts"}" title="{_T string="Manage emails texts and subjects"}" class="{if $cur_route eq "texts"}active {/if}item">{_T string="Emails content"}</a>
                        <a href="{path_for name="titles"}" title="{_T string="Manage titles"}" class="{if $cur_route eq "titles"}active {/if}item">{_T string="Titles"}</a>
                        <a href="{path_for name="pdfModels"}" title="{_T string="Manage PDF models"}" class="{if $cur_route eq "pdfModels"}active {/if}item">{_T string="PDF models"}</a>
                        <a href="{path_for name="paymentTypes"}" title="{_T string="Manage payment types"}" class="{if $cur_route eq "paymentTypes"}active {/if}item">{_T string="Payment types"}</a>
                        <a href="{path_for name="emptyAdhesionForm"}" title="{_T string="Download empty adhesion form"}" class="item">{_T string="Empty adhesion form"}</a>
        {if $login->isSuperAdmin()}
                        <a href="{path_for name="fakeData"}" title="{_T string="Generate fake data"}" class="{if $cur_route eq "fakeData"}active {/if}item">{_T string="Generate fake data"}</a>
                        <a href="{path_for name="adminTools"}" title="{_T string="Various administrative tools"}" class="{if $cur_route eq "adminTools"}active {/if}item">{_T string="Admin tools"}</a>
        {/if}
                </div>
                {* Include plugins menu entries *}
                {$plugins->getMenus($tpl)}
            </div>
    {/if}
{else}
    {if $cur_route neq "login"}
            <a href="{path_for name="slash"}"
               title="{if $login->isLogged()}{_T string="Dashboard"}{else}{_T string="Go back to Galette homepage"}{/if}"
               class="{if $cur_route eq "dashboard" or $cur_route eq "login"}active {/if}item"
            >
                <i class="icon {if $login->islogged()}compass{else}home{/if}" aria-hidden="true"></i>
                {if $login->isLogged()}{_T string="Dashboard"}{else}{_T string="Home"}{/if}
            </a>
    {/if}
    {if $preferences->showPublicPages($login) eq true}
            <a href="{path_for name="publicList" data=["type" => "list"]}" class="{if $cur_route eq "publicList" and $cur_subroute eq "list"}active {/if}item">
                <i class="icon address book" aria-hidden="true"></i>
                {_T string="Members list"}
            </a>
            <a href="{path_for name="publicList" data=["type" => "trombi"]}" class="{if $cur_route eq "publicList" and $cur_subroute eq "trombi"}active {/if}item">
                <i class="icon user friends" aria-hidden="true"></i>
                {_T string="Trombinoscope"}
            </a>
    {/if}

            {* Include plugins menu entries *}
            {$plugins->getPublicMenus($tpl, true)}

            <div class="item">
    {if $preferences->pref_bool_selfsubscribe eq true and $cur_route neq "subscribe"}
                <a href="{path_for name="subscribe"}" class="button" title="{_T string="Subscribe"}">
                    <i class="icon add user" aria-hidden="true"></i>
                    {_T string="Subscribe"}
                </a>
    {/if}
    {if $cur_route neq "login"}
                <a href="{path_for name="slash"}" class="button" title="{_T string="Login"}">
                    <i class="icon sign in alt" aria-hidden="true"></i>
                    {_T string="Login"}
                </a>
    {/if}
            </div>
{/if}
            <div class="language item" title="{_T string="Choose your language"}">
                <i class="icon language" aria-hidden="true"></i>
                <span>{$galette_lang}</span>
                <div class="menu">
    {foreach item=langue from=$languages}
        {if $langue->getAbbrev() neq $galette_lang}
                    <a href="?pref_lang={$langue->getID()}" class="item">
                        {$langue->getName()} <span>({$langue->getAbbrev()})<span>
                    </a>
        {/if}
    {/foreach}
                </div>
            </div>
        </div>
