-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
CreateThread(function()
    lib.registerMenu({
        id = 'admin_menu_main',
        title = Strings.main_title,
        position = Config.MenuPosition,
        options = {
            {
                icon = 'fa-person',
                label = Strings.self_options,
                description = Strings.self_options_desc
            },
            {
                icon = 'fa-people-arrows',
                label = Strings.player_options_title,
                description = Strings.player_options_desc
            },
            {
                icon = 'fa-car',
                label = Strings.vehicle_options,
                description = Strings.vehicle_options_desc
            },
            {
                icon = 'fa-globe',
                label = Strings.server_options,
                description = Strings.server_options_desc
            },
            {
                icon = 'fa-street-view',
                label = Strings.admin_zone_options,
                description = Strings.admin_zone_options_desc
            },
            {
                icon = 'fa-screwdriver-wrench',
                label = Strings.developer_options,
                description = Strings.developer_options_desc
            },
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            SelfOptions()
        elseif selected == 2 then
            PlayerOptions()
        elseif selected == 3 then
            VehicleOptions()
        elseif selected == 4 then
            ServerOptions()
        elseif selected == 5 then
            AdminZoneMenu()
        elseif selected == 6 then
            DeveloperOptions()
        end
    end)
end)

AdminMenu = function()
    lib.showMenu('admin_menu_main')
end

RegisterNetEvent('wasabi_adminmenu:searchInventory', function(target)
    if GetInvokingResource() ~= GetCurrentResourceName() then return end
    OpenPlyInv(target)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local OpenMenu = lib.getOpenMenu()
    lib.hideMenu(OpenMenu)
end)

AddEventHandler('wasabi_adminmenu:playerLoaded', function()
   TriggerServerEvent('wasabi_adminmenu:reqsync')
end)

RegisterCommand('adminmenu', function()
    local hasPerms = lib.callback.await('wasabi_adminmenu:checkPerms', 100)
    if not hasPerms then return end
    AdminMenu()
end)

TriggerEvent('chat:removeSuggestion', '/adminmenu')
RegisterKeyMapping('adminmenu', Strings.keymapping_desc, 'keyboard', Config.OpenKey)
