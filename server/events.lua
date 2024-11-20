-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
Weather = 'EXTRASUNNY'

RegisterNetEvent('wasabi_adminmenu:skinmenu', function(target)
    if not AdminPerms(source) then return end
    TriggerClientEvent('wasabi_adminmenu:skinmenu', target)
end)

RegisterNetEvent('wasabi_adminmenu:revive', function(target)
    if not AdminPerms(source) then return end
    TriggerClientEvent('wasabi_adminmenu:revive', target)
end)

RegisterNetEvent('wasabi_adminmenu:heal', function(target)
    if not AdminPerms(source) then return end
    TriggerClientEvent('wasabi_adminmenu:heal', target)
end)

RegisterNetEvent('wasabi_adminmenu:playerteleport', function(target, action)
    if not AdminPerms(source) then return end
    if action == 'tpto' then
        SetEntityCoords(source, GetEntityCoords(GetPlayerPed(target)))
    elseif action == 'bring' then
        SetEntityCoords(target, GetEntityCoords(GetPlayerPed(source)))
    end
end)

RegisterNetEvent('wasabi_adminmenu:announcement', function(message, job)
    if job then
        local allPlayers = GetPlayers()
        local players = {}
        for i=1, #allPlayers do
            local src = allPlayers[i]?.source or allPlayers[i]?.PlayerData?.source
            if HasGroup(src, job) then
                players[#players + 1] = src
            end
        end
        if #players > 0 then
            for i=1, #players do
                TriggerClientEvent('chat:addMessage', players[i], {
                    color = { 255, 0, 0 },
                    args = { 'Admin Announcement', message }
                })
            end
        end
    else
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0 },
            args = { 'Admin Announcement', message }
        })
    end
end)

RegisterNetEvent('wasabi_adminmenu:setFuel', function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    Entity(vehicle).state.fuel = 100
end)

RegisterNetEvent('wasabi_adminmenu:deleteEntity', function(netId)
    if not AdminPerms(source) then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)

RegisterNetEvent('wasabi_adminmenu:weathersync', function(type)
    if not AdminPerms(source) then return false end
    Weather = type
    TriggerClientEvent('wasabi_adminmenu:weathersync', -1, type)
    TriggerEvent('wasabi_adminmenu:reqsync')
    TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_weather, (Strings.notify_weather_desc:format(string.lower(type))), 'success','fa-check')
end)

RegisterNetEvent('wasabi_adminmenu:reqsync', function()
    TriggerClientEvent('wasabi_adminmenu:weathersync', -1, Weather)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if GetResourceState('vSync') == 'started' then
        print('^1[Warning] You have vSync started.. this breaks our weather function^0')
    elseif GetResourceState('cd_easytime') == 'started' then
        print('^1[Warning] You have cd_easytime started.. this breaks our weather function^0')
    end
end)
