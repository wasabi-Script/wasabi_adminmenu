if GetResourceState('qb-core') ~= 'started' then return end
QBCore = exports['qb-core']:GetCoreObject()
Framework, PlayerLoaded, PlayerData = 'qb', nil, {}

AddStateBagChangeHandler('isLoggedIn', '', function(_bagName, _key, value, _reserved, _replicated)
    if value then
        PlayerData = QBCore.Functions.GetPlayerData()
    else
        table.wipe(PlayerData)
    end
    PlayerLoaded = value
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not LocalPlayer.state.isLoggedIn then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    TriggerEvent('wasabi_adminmenu:setJob', job.name)
    PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end
    local playerPed = cache.ped
	local victim, victimDied = data[1], data[4]
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
	if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim))  then
        local deathCause = GetPedCauseOfDeath(playerPed)
        local data = {
            deathCause = deathCause,
            victimCoords = GetEntityCoords(victim)
        }
        TriggerEvent('wasabi_adminmenu:onPlayerDeath', data)
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('wasabi_adminmenu:playerLoaded')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(newPlayerData)
    if source ~= '' and GetInvokingResource() ~= 'qb-core' then return end
    PlayerData = newPlayerData
end)

ShowNotification = function(msg, type)
    QBCore.Functions.Notify(msg, type)
end

ServerCallback = function(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

HasGroup = function(filter)
    local groups = { 'job', 'gang' }
    local type = type(filter)

    if type == 'string' then
        for i = 1, #groups do
            local data = PlayerData[groups[i]]

            if data.name == filter then
                return data.name, data.grade.level
            end
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for i = 1, #groups do
                local data = PlayerData[groups[i]]
                local grade = filter[data.name]

                if grade and grade <= data.grade.level then
                    return data.name, data.grade.level
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                for j = 1, #groups do
                    local data = PlayerData[groups[j]]

                    if data.name == group then
                        return data.name, data.grade.level
                    end
                end
            end
        end
    end
end

GetGroup = function()
    local data = PlayerData['job']
    return data.name, data.grade.level
end

GetGender = function()
    return (PlayerData.charinfo.gender or 0)
end

IsPlayerDead = function()
    PlayerData = QBCore.Functions.GetPlayerData()
    return PlayerData.metadata.isdead
end
