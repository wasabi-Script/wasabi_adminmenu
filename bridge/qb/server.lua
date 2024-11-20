-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Framework = 'qb'

GetPlayer = function(source)
    return QBCore.Functions.GetPlayer(source)
end

GetPlayerFromIdentifier = function(identifier)
    local player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    if not player then return false end
    return player
end

GetPlayers = function()
    return QBCore.Functions.GetPlayers()
end

RegisterCallback = function(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

KickPlayer = function(source, reason)
    QBCore.Functions.Kick(source, reason, true, true)
end

HasPermission = function(source, group)
    local player = GetPlayer(source)
    if QBCore.Functions.HasPermission(source, group) then
        return true
    else
        return false
    end
end

HasGroup = function(source, filter)
    local groups = { 'job', 'gang' }
    local player = GetPlayer(source)
    local type = type(filter)

    if type == 'string' then
        for i = 1, #groups do
            local data = player.PlayerData[groups[i]]

            if data.name == filter then
                return data.name, data.grade.level
            end
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for i = 1, #groups do
                local data = player.PlayerData[groups[i]]
                local grade = filter[data.name]

                if grade and grade <= data.grade.level then
                    return data.name, data.grade.level
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                for j = 1, #groups do
                    local data = player.PlayerData[groups[j]]

                    if data.name == group then
                        return data.name, data.grade.level
                    end
                end
            end
        end
    end
end

SetJob = function(source, job, grade)
    local player = GetPlayer(source)
    player.Functions.SetJob(job, grade)
end

GetIdentifier = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player.PlayerData.citizenid
end

GetName = function(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
end

HasItem = function(source, item)
    local player = GetPlayer(source)
    local item = player.Functions.GetItemByName(item)
    if GetResourceState('ox_inventory') == 'started' then
        return item?.count or 0
    else
        return item?.amount or 0
    end
end

AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    TriggerClientEvent('inventory:client:ItemBox', source,  item, 'add')
    return player.Functions.AddItem(item, count, slot, metadata)
end

AddWeapon = function(source, weapon, ammo)
    local player = GetPlayer(source)
    return player.Functions.AddItem(weapon, 1, nil, nil)
end

RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.Functions.RemoveItem(item, count, slot, metadata)
end

AddMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.AddMoney(type, amount)
end

RemoveMoney = function(source, type, amount)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    player.Functions.RemoveMoney(type, amount)
end

GetPlayerAccountFunds = function(source, type)
    if type == 'money' then type = 'cash' end
    local player = GetPlayer(source)
    return player.PlayerData.money[type]
end
