-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local zones = {}

RegisterNetEvent('wasabi_adminmenu:createZone', function(zone)
    if not AdminPerms(source) then return end
    zones[#zones + 1] = zone
    TriggerClientEvent('wasabi_adminmenu:refreshZones', -1, zones)
end)

lib.callback.register('wasabi_adminmenu:deleteZone', function(source, zone)
    if not AdminPerms(source) then return end
    local success
    for k,v in pairs(zones) do
        if (v.name == zone.name and v.coords == zone.coords) then zones[k] = nil success = true break end
    end
    if not success then return success end
    local oldZones = zones
    zones = {}
    for k,v in pairs(oldZones) do
        if v and v?.name then zones[#zones + 1] = v end
    end
    TriggerClientEvent('wasabi_adminmenu:refreshZones', -1, zones)
    return success
end)

lib.callback.register('wasabi_adminmenu:editZone', function(source, oldData, newData)
    if not AdminPerms(source) then return end
    local success
    for k,v in pairs(zones) do
        if (v.name == oldData.name) and (v.coords == oldData.coords) then zones[k] = newData success = true break end
    end
    if not success then return success end
    TriggerClientEvent('wasabi_adminmenu:refreshZones', -1, zones)
    return success
end)

lib.callback.register('wasabi_adminmenu:refreshZones', function(source)
    return zones
end)