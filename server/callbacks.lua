local ServerSlots = GetConvarInt('sv_maxclients', 48)



lib.callback.register('wasabi_adminmenu:slotCount', function(source)
    return ServerSlots
end)


lib.callback.register('wasabi_adminmenu:checkPerms', function(source)
    if not GetPlayer(source) then return false end
    if AdminPerms(source) then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_adminmenu:players', function(source)
    local players = GetPlayers()
    local SentPlayers = {}
    for i=1, #players do
        local player = players[i]
        local src
        if Framework == 'esx' then src = player.source else src = player end
        SentPlayers[#SentPlayers + 1] = {
            Name = GetPlayerName(src),
            identifier = GetIdentifier(src),
            Id = src
        }
    end
    local data = { SentPlayers = SentPlayers, PlayerCount = #players }
    return data
end)

lib.callback.register('wasabi_adminmenu:giveMoney', function(source, target, account, amount)
    if not AdminPerms(source) or not GetPlayer(target) then return false end
    AddMoney(target, account, amount)
    return true
end)

lib.callback.register('wasabi_adminmenu:dropPlayer', function(source, target, reason)
    if not AdminPerms(source) then return false end
    DropPlayer(target, reason)
    return true
end)

lib.callback.register('wasabi_adminmenu:banPlayer', function(source, target, time, reason)
    if not AdminPerms(source) or not GetPlayer(target) then return false end
    return BanPlayer(target, time, reason, source)
end)

lib.callback.register('wasabi_adminmenu:clearinv', function(source, target)
    if not AdminPerms(source) then return false end
    if Framework == 'esx' then
        local xTarget = ESX.GetPlayerFromId(target)
        if not xTarget then return false end
        xPlayer.setAccountMoney('money', 0)
        xPlayer.setAccountMoney('black_money', 0)
        if Config.Inventory == 'mf' then
            exports['mf-inventory']:clearInventory(xTarget.identifier)
            exports['mf-inventory']:clearLoadout(xTarget.identifier)
        elseif Config.Inventory == 'esx' or Config.Inventory == 'cheeza' then
            for i = 1, #xTarget.inventory, 1 do
                if xTarget.inventory[i].count > 0 then
                    xTarget.removeInventoryItem(xTarget.inventory[i].name, xTarget.inventory[i].count)
                end
            end
        end
    elseif Framework == 'qb' then
        local player = GetPlayer(target)
        if not player then return false end
        player.Functions.ClearInventory()
        MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), player.PlayerData.citizenid })
    end
    if Config.Inventory == 'qs' then
        exports['qs-inventory']:ClearInventory(target, {})
    elseif Config.Inventory == 'ox' then
        exports.ox_inventory:ClearInventory(source)
    end
    return true
end)

lib.callback.register('wasabi_adminmenu:freeze', function(source, target, toggle)
    if not AdminPerms(source) then return false end
    FreezeEntityPosition(target, toggle)
end)

lib.callback.register('wasabi_adminmenu:noclip', function(source, target, toggle)
    if not AdminPerms(source) then return false end
    TriggerClientEvent('wasabi_adminmenu:noclip', target, toggle)
end)

lib.callback.register('wasabi_adminmenu:giveitem', function(source, target, item, amount)
    if not AdminPerms(source) then return false end
    if GetPlayer(target) then
        AddItem(target, item, amount)
        return 'success'
    else
        return 'error'
    end
end)

lib.callback.register('wasabi_adminmenu:playerdata', function(source, target)
    if not AdminPerms(source) then return false end
    local data = {
        identifier = GetIdentifier(target),
        igname = GetName(target),
        steamname = GetPlayerName(target),
        cash = GetPlayerAccountFunds(target, 'cash'),
        bank = GetPlayerAccountFunds(target, 'bank')
    }
    if Framework == 'esx' then data.black_money = GetPlayerAccountFunds(target, 'black_money') end
    return data
end)