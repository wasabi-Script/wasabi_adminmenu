-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local function splitTime(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format('%02.f', math.floor(seconds / 3600))
        local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

        return hours, mins
    end
end

local banListHandle = function(name, license, author, reason, length)
    local hours, mins = splitTime(length)
    lib.registerMenu({
        id = 'admin_menu_banlist_handle',
        title = Strings.ban_list_menu,
        position = Config.MenuPosition,
        onClose = function()
            BanList()
        end,
        options = {
            {
                label = Strings.ban_list_name:format(name),
                close = false
            },
            {
                label = Strings.ban_list_license..' '..string.sub(license, 0, -20)..'...',
                close = false
            },
            {
                label = Strings.ban_list_by:format(author),
                close = false
            },
            {
                label = Strings.ban_list_reason:format(reason),
                close = false
            },
            {
                label = Strings.ban_list_length:format(hours, mins)
            },
            {
                label = Strings.ban_list_unban
            }
        }
    }, function(selected)
        if selected == 6 then
            local confirm = lib.alertDialog({
                header = Strings.dialog_unban,
                content = (Strings.dialog_unban_content):format(name),
                centered = true,
                cancel = true
            })
            if confirm == 'confirm' then
                local unban = lib.callback.await('wasabi_adminmenu:unban', 100, license)
                if unban then
                    TriggerEvent('wasabi_adminmenu:notify', Strings.successfully_unbanned, (Strings.successfully_unbanned_desc):format(name), 'success', 'fa-check')
                else
                    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, (Strings.unsuccessful_unban):format(name), 'error', 'fa-xmark')
                end
            end
        end
    end)
    lib.showMenu('admin_menu_banlist_handle')
end

BanList = function()
    local data = lib.callback.await('wasabi_adminmenu:getBanList', 100)
    if not data or #data < 1 then
        TriggerEvent('wasabi_adminmenu:notify', Strings.ban_list_no_data, Strings.ban_list_no_data_desc, 'error')
    else
        local banList = {}
        for i = 1, #data do
            banList[#banList + 1] = {
                label = data[i].name,
                license = data[i].license,
                author = data[i].author,
                reason = data[i].reason,
                time_left = data[i].time_left
            }
        end
        lib.registerMenu({
            id = 'admin_menu_banlist',
            title = Strings.ban_list_menu,
            position = Config.MenuPosition,
            onClose = function()
                ServerOptions()
            end,
            options = banList
        }, function(selected)
            if selected then
                banListHandle(banList[selected].label, banList[selected].license, banList[selected].author, banList[selected].reason, banList[selected].time_left)
            end
        end)
        lib.showMenu('admin_menu_banlist')
    end
end

local delCars = function()
    local vehiclePool = GetGamePool('CVehicle')
    for i = 1, #vehiclePool do
        if GetPedInVehicleSeat(vehiclePool[i], -1) == 0 then
            DeleteEntity(vehiclePool[i])
        end
    end
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_deleted_car, Strings.notify_deleted_car_desc, 'success','fa-check')
end

local delPeds = function()
    local pedsPool = GetGamePool('CPed')
    for i = 1, #pedsPool do
        if DoesEntityExist(pedsPool[i]) then
            DeleteEntity(pedsPool[i])
        end
    end
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_deleted_ped, Strings.notify_deleted_ped_desc, 'success','fa-check')
end

local delObjects = function()
    local objectsPool = GetGamePool('CObject')
    for i=1, #objectsPool do
        if DoesEntityExist(objectsPool[i]) then
            DeleteEntity(objectsPool[i])
        end
    end
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_deleted_objects, Strings.notify_deleted_objects_desc, 'success','fa-check')
end

local entityDelHandler = function()
    local Handler =  lib.inputDialog(Strings.dialog_objects, {
        { type = 'select', label = Strings.objects_list_label, options = {
            { value = 'objects', label = Strings.dialog_clear_objects },
            { value = 'cars', label = Strings.dialog_clear_cars },
            { value = 'peds', label = Strings.dialog_clear_peds},
        }},
    })
    if not Handler then return end
    if Handler[1] == 'objects' then
        delObjects()
    elseif Handler[1] == 'cars' then
        delCars()
    elseif Handler[1] == 'peds' then
        delPeds()
    end
end

local Announcement = function()
    local Jobs = {}
    for i = 1, #Config.Jobs do
        Jobs[#Jobs + 1] = {
            label = Config.Jobs[i].label,
            value = Config.Jobs[i].name
        }
    end
    local message = lib.inputDialog(Strings.dialog_announce, {
        { type = 'input', label = Strings.dialog_announce_label, placeholder = Strings.dialog_announce_placeholder },
        { type = 'select', label = Strings.dialog_announce_select, options = Jobs },
    })
    if not message then return end
    TriggerServerEvent('wasabi_adminmenu:announcement', message[1], message[2])
end

local changeWeather = function(type)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(type)
    SetWeatherTypeNow(type)
    SetWeatherTypeNowPersist(type)
    if type == 'XMAS' then
    SetForceVehicleTrails(true)
    SetForcePedFootstepsTracks(true)
    else
    SetForceVehicleTrails(false)
    SetForcePedFootstepsTracks(false)
    end
end

RegisterNetEvent('wasabi_adminmenu:weathersync', function(type)
    changeWeather(type)
end)

ServerOptions = function()
    local Weathers = {}
    for i=1, #Config.Weathers do
        Weathers[#Weathers+1] = Config.Weathers[i]
    end
    lib.registerMenu({
        id = 'admin_menu_serveroptions',
        title = Strings.server_management,
        position = Config.MenuPosition,
        onClose = function()
            AdminMenu()
        end,
        options = { {
            icon = 'bullhorn',
            label = Strings.server_announcement,
            description = Strings.server_announcement_desc
        }, {
            icon = 'ban',
            label = Strings.ban_list,
            description = Strings.ban_list_desc
        }, {
            icon = 'trash',
            label = Strings.objects_list,
            description = Strings.objects_list_desc
        }, {
            icon = 'cloud',
            label = Strings.weather_menu,
            description = Strings.weather_menu_desc,
            values = Weathers,
            defaultIndex = 1,
            close = false
        }}
    },
    function(selected, scrollIndex)
        if selected == 1 then
            Announcement()
        elseif selected == 2 then
            BanList()
        elseif selected == 3 then
            entityDelHandler()
        elseif selected == 4 then
            TriggerServerEvent('wasabi_adminmenu:weathersync', Weathers[scrollIndex].value)
        end
    end)
    lib.showMenu('admin_menu_serveroptions')
end
