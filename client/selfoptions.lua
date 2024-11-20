-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local Invisible, GodMode, Noclip

local InvisibleMode = function(enabled)
   if enabled and Invisible then return end
    Invisible = enabled
    SetEntityVisible(cache.ped, not enabled)
    if enabled then
        ShowTextUI(Strings.textui_invisible)
    else
        HideTextUI()
    end
end

local GodModeMode = function(enabled)
    if enabled and GodMode then return end
    GodMode = enabled
    SetEntityInvincible(cache.ped, enabled)
    if enabled then
        ShowTextUI(Strings.textui_godmode)
    else
        HideTextUI()
    end
end

local SetPed = function(model)
    if model == 'restore' then
        if Framework == 'esx' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                local isMale = skin.sex == 0
                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end)
        elseif Framework == 'qb' then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        end
    else
        lib.requestModel(model)
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end
end

SelfOptions = function()
    local health = GetEntityHealth(cache.ped) / 2
    local peds = {}
    for i=1, #Peds do
        peds[#peds + 1] = Peds[i]
    end
    lib.registerMenu({
        id = 'admin_menu_selfoptions',
        title = Strings.self_options_menu,
        position = Config.MenuPosition,
        onClose = function()
            AdminMenu()
        end,
        onCheck = function(selected, checked)
            if selected == 2 then
                Noclip = checked
                ToggleNoClip(checked)
            elseif selected == 3 then
                InvisibleMode(checked)
            elseif selected == 4 then
                GodModeMode(checked)
            end
        end,
        options = {
            {
                icon = 'fa-heart-pulse',
                label = (Strings.self_health):format(math.floor(health)),
                close = false,
                progress = health
            },
            {
                icon = 'fa-person-walking-dashed-line-arrow-right',
                label = Strings.self_noclip,
                checked = Noclip or false
            },
            {
                icon = 'fa-eye-slash',
                label = Strings.self_invisible,
                checked = Invisible or false
            },
            {
                icon = 'fa-person-rays',
                label = Strings.self_godmode,
                checked = GodMode or false
            },
            {
                icon = 'fa-bed-pulse',
                close = false,
                label = Strings.self_revive,
                description = Strings.self_revive_desc
            },
            {
                icon = 'fa-bandage',
                close = false,
                label = Strings.self_heal,
                description = Strings.self_heal_desc
            },
            {
                icon = 'fa-shirt',
                label = Strings.self_skinmenu,
                description = Strings.self_skinmenu_desc
            },
            {
                icon = 'fa-people-arrows',
                label = Strings.self_set_ped,
                values = peds,
                defaultIndex = 1,
                close = false
            }
        }
    }, function(selected, scrollIndex)
        if selected == 5 then
            TriggerEvent('wasabi_adminmenu:revive')
        elseif selected == 6 then
            TriggerEvent('wasabi_adminmenu:heal')
        elseif selected == 7 then
            TriggerEvent('wasabi_adminmenu:skinmenu')
        elseif selected == 8 then
            SetPed(DumpTable(peds[scrollIndex].value))
        end
    end)
    lib.showMenu('admin_menu_selfoptions')
end

