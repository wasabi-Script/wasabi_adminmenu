-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------



----- Thread to get the server slots, grabs it from the cfg convar
local ServerSlots = 48
local Freezed, Noclip

CreateThread(function()
    local slotCount = lib.callback.await('wasabi_adminmenu:slotCount', 100)
    if slotCount then
        ServerSlots = slotCount
    end
end)

local givePlayerMoney = function(target, name)
    local dialogOptions = {
        { value = 'money', label = Strings.givemoney_select_option1 },
        { value = 'bank', label = Strings.givemoney_select_option2 }
    }
    if Framework == 'esx' then
        dialogOptions[#dialogOptions + 1] = {
            value = 'black_money', label = Strings.givemoney_select_option3
        }
    end
    local Dialog = lib.inputDialog(Strings.dialog_givemoney, {
        { type = 'input', label = Strings.givemoney_input_label, placeholder = Strings.givemoney_input_placeholder },
        { type = 'select', label = Strings.givemoney_select, options = dialogOptions }
    })
    if not Dialog then return end
    local success = lib.callback.await('wasabi_adminmenu:giveMoney', 100, target, Dialog[2], tonumber(Dialog[1]))
    if success then
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_givemoney_success,(Strings.notify_givemoney_success_desc:format(name, Dialog[1], Dialog[2])), 'success', 'fa-check')
    else
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_giveitem_fail, (Strings.notify_giveitem_fail_desc:format(name)), 'error', 'fa-xmark')
    end
end

local givePlayerItem = function(target, name)
    local Dialog = lib.inputDialog(Strings.dialog_giveitem, {
        { type = 'input', label = Strings.giveitem_input_label, placeholder = Strings.giveitem_input_placeholder },
        { type = 'input', label = Strings.giveitem_amount_input_label, placeholder = Strings.giveitem_amount_input_placeholder }})
    if not Dialog then return end
    local success = lib.callback.await('wasabi_adminmenu:giveitem', 100, target, Dialog[1], tonumber(Dialog[2]))
    if success then
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_giveitem_success, (Strings.notify_giveitem_success_desc:format(name, Dialog[1], Dialog[2])), 'success', 'fa-check')
    else
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_giveitem_fail, (Strings.notify_giveitem_fail_desc:format(name)), 'error', 'fa-xmark')
    end
end

local kickPlayer = function(target, name)
    local Reason = lib.inputDialog(Strings.dialog_kick:format(name), {
        { type = 'input', label = Strings.dialog_kick_reason, placeholder = Strings.dialog_kick_placeholder },
    })
    if not Reason then return end
    local dropPlayer = lib.callback.await('wasabi_adminmenu:dropPlayer', 100, target, Reason[1] or Strings.kicked_reason_replace)
    if dropPlayer then
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_kicked_success, (Strings.notify_kicked_success_desc:format(name)), 'success', 'fa-check')
    end
end

local banPlayer = function(target, time, name)
    local Reason = lib.inputDialog(Strings.dialog_ban:format(name), {
        { type = 'input', label = Strings.dialog_ban_reason, placeholder = Strings.dialog_ban_placeholder },
    })
    if not Reason then return end
    local banPlayer = lib.callback.await('wasabi_adminmenu:banPlayer', 100, target, time, Reason[1] or Strings.ban_reason_replace)
    if banPlayer then
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_banned_success, (Strings.notify_banned_success_desc:format(name)), 'success', 'fa-check')
    end
end

local openPlayerData = function(target)
    local targetData = lib.callback.await('wasabi_adminmenu:playerdata', 100, target)
    local Options = {}
    if Framework == 'esx' then
        Options[#Options + 1] = {
            icon = 'fa-solid fa-id-card',
            label = Strings.playerdata_license_esx:format(string.sub(targetData.identifier, 0, -20)),
            description = Strings.playerdata_license_desc
        }
    elseif Framework == 'qb' then
        Options[#Options + 1] = {
            icon = 'fa-solid fa-id-card',
            label = Strings.playerdata_license_qbcore:format(targetData.identifier),
            description = Strings.playerdata_license_desc
        }
    end
    Options[#Options + 1] = {
        icon = 'fa-solid fa-signature',
        label = Strings.playerdata_igname:format(targetData.igname),
        description = Strings.playerdata_igname_desc,
        close = false,
    }
    Options[#Options + 1] = {
        icon = 'fa-brands fa-steam',
        label = Strings.playerdata_steam:format(targetData.steamname),
        description = Strings.playerdata_steam_desc,
        close = false,
    }
--    Options[#Options + 1] = { -- Coming Soon
--        icon = 'fa-solid fa-users',
--        label = Strings.playerdata_gender:format(targetData.sex),
--        description = Strings.playerdata_gender_desc,
--        close = false,
--    }
    Options[#Options + 1] = {
        icon = 'fa-solid fa-money-bill',
        label = Strings.playerdata_cash:format(targetData.cash),
        description = Strings.playerdata_cash_desc,
        close = false,
    }
    Options[#Options + 1] = {
        icon = 'fa-solid fa-credit-card',
        label = Strings.playerdata_bank:format(targetData.bank),
        description = Strings.playerdata_bank_desc,
        close = false,
    }
    if Framework == 'esx' then
        Options[#Options + 1] = {
            icon = 'fa-solid fa-money-bill',
            label = Strings.playerdata_blackmoney:format(targetData.black_money),
            description = Strings.playerdata_blackmoney_desc,
            close = false,
        }
    end
    lib.registerMenu({
        id = 'admin_menu_playerdata',
        title = Strings.playerdata_menu,
        position = Config.MenuPosition,
        onClose = function()
            PlayerOptions()
        end,
        options = Options
    }, function(selected)
        if selected == 1 then
            lib.setClipboard(targetData.identifier)
        end
    end)
    lib.showMenu('admin_menu_playerdata')
end

local plyOptionsMenu = function(Target, Name)
    local BanConfig = {}
    local GetPlayerServerId = GetPlayerFromServerId(Target)
    local GetPlayerPed = GetPlayerPed(GetPlayerServerId)
    local health = GetEntityHealth((GetPlayerPed)) / 2
    for i=1, #Config.Ban do
       BanConfig[#BanConfig+1] = Config.Ban[i]
    end
    lib.registerMenu({
        id = 'admin_menu_playeroptions_handle',
        title = Strings.player_options:format(Name),
        position = Config.MenuPosition,
        onClose = function()
            PlayerOptions()
        end,
        onCheck = function(selected, checked)
            if selected == 2 then
                Freezed = checked
                lib.callback.await('wasabi_adminmenu:freeze', 100, Target, checked)
             elseif selected == 3 then
                Noclip = checked
                lib.callback.await('wasabi_adminmenu:noclip', 100, Target, checked)
            end
        end,
        options = {
            {
                icon = 'fa-heart-pulse',
                label = Strings.player_health:format(math.floor(health)),
                close = false,
                progress = health
            },
            {
                icon = 'fa-solid fa-street-view',
                label = Strings.player_freeze,
                description = Strings.player_freeze_desc,
                checked = Freezed or false
            },
            {
                icon = 'fa-person-walking-dashed-line-arrow-right',
                label = Strings.player_noclip,
                description = Strings.player_noclip_desc,
                checked = Noclip or false
            },
            {
                icon = 'fa-solid fa-database',
                label = Strings.player_playerdata,
                description = Strings.player_playerdata_desc
            },
            {
                icon = 'fa-solid fa-bed-pulse',
                close = false,
                label = Strings.player_revive,
                description = Strings.player_revive_desc
            },
            {
                icon = 'fa-solid fa-bandage',
                close = false,
                label = Strings.player_heal,
                description = Strings.player_heal_desc
            },
            {
                icon = 'fa-solid fa-shirt',
                label = Strings.player_skinmenu,
                description = Strings.player_skinmenu_desc
            },
            {
                icon = 'fa-solid fa-money-bill',
                label = Strings.player_money,
                description = Strings.player_money_desc
            },
            {
                icon = 'fa-solid fa-hand-holding-medical',
                label = Strings.player_item,
                description = Strings.player_item_desc
            },
            {
                icon = 'fa-solid fa-box-open',
                label = Strings.player_openinv,
                description = Strings.player_openinv_desc
            }, 
            {
                icon = 'fa-solid fa-boxes-packing',
                close = false,
                label = Strings.player_clearinv,
                description = Strings.player_clearinv_desc
            },
            {
                icon = 'fa-solid fa-person-arrow-up-from-line',
                close = false,
                label = Strings.player_teleport_to,
                description = Strings.player_teleport_to_desc,
            },
            {
                icon = 'fa-solid fa-person-arrow-down-to-line',
                close = false,
                label = Strings.player_bring,
                description = Strings.player_bringDesc,
            },
            {
                icon = 'fa-solid fa-arrow-right-from-bracket',
                label = Strings.player_kick,
                description = Strings.player_kick_desc
            },
            {
                icon = 'fa-solid fa-trash',
                label = Strings.player_ban,
                values = BanConfig,
                defaultIndex = 1,
            }
        }
    }, function(selected, scrollIndex)
        if selected == 4 then
            openPlayerData(Target)
        elseif selected == 5 then
            TriggerServerEvent('wasabi_adminmenu:revive', Target)
        elseif selected == 6 then
            TriggerServerEvent('wasabi_adminmenu:heal', Target)
        elseif selected == 7 then
            TriggerServerEvent('wasabi_adminmenu:skinmenu', Target)
        elseif selected == 8 then
            givePlayerMoney(Target, Name)
        elseif selected == 9 then
            givePlayerItem(Target, Name)
        elseif selected == 10 then
            OpenPlyInv(Target)
        elseif selected == 11 then
            local Clear = lib.callback.await('wasabi_adminmenu:clearinv', 100, Target)
            if Clear then
                TriggerEvent('wasabi_adminmenu:notify', Strings.notify_clearedinv,
                    (Strings.notify_clearedinv_desc:format(Name)), 'success', 'fa-check')
            end
        elseif selected == 12 then
        TriggerServerEvent('wasabi_adminmenu:playerteleport', Target, 'tpto')
        elseif selected == 13 then
        TriggerServerEvent('wasabi_adminmenu:playerteleport', Target, 'bring')
        elseif selected == 14 then
            kickPlayer(Target, Name)
        elseif selected == 15 then
            banPlayer(Target, BanConfig[scrollIndex].value, Name)
        end

    end)
    lib.showMenu('admin_menu_playeroptions_handle')
end

PlayerOptions = function()
    local Players = {}
    local data = lib.callback.await('wasabi_adminmenu:players', 250)
    local SentPlayers, PlayerCount = data.SentPlayers, data.PlayerCount
    for i = 1, #SentPlayers do
        Players[#Players + 1] = {
            label = '['..SentPlayers[i].Id..']' .. ' ' .. SentPlayers[i].Name,
            value = SentPlayers[i].Id
        }
    end
    lib.registerMenu({
        id = 'admin_menu_playeroptions',
        title = Strings.player_options_menu:format(PlayerCount, ServerSlots),
        position = Config.MenuPosition,
        onClose = function()
            AdminMenu()
        end,
        options = Players
    }, function(selected, scrollIndex, args)
        if selected then
            plyOptionsMenu(Players[selected].value, Players[selected].label)
        end

    end)
    lib.showMenu('admin_menu_playeroptions')
end
