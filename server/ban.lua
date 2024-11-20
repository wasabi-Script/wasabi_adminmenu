-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local function extractIdentifiers(src)
    local identifiers = { ip = '', discord = '', license = '' }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, 'ip') then
            identifiers.ip = id
        elseif string.find(id, 'discord') then
            identifiers.discord = id
        elseif string.find(id, 'license') then
            identifiers.license = id
        end
    end
    return identifiers
end

local function getBanExpire(currentTime, hours)
    local hour = 3600
    local time = hour * hours
    return currentTime + time
end

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

BanPlayer = function(target, time, reason, source)
    local identifiers = extractIdentifiers(target)
    local author = GetPlayerName(source)
    local player = GetPlayerName(target)
    local license = identifiers.license
    local ip = identifiers.ip
    local discord = identifiers.discord
    local reason = reason or ''
    local currentTime = os.time()
    local banExp = getBanExpire(currentTime, time)
    MySQL.insert(
        'INSERT INTO wasabi_bans (author, player, license, ip, discord, reason, ban_time, exp_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        {author, player, license, ip, discord, reason, currentTime, banExp}, function(id)
        end)
    DropPlayer(target, reason)
end

DisableConnect = function(name, setKickReason, deferrals)
    local player = source
    deferrals.defer()
    Wait(0)
    deferrals.update((Strings.deferral_welcome):format(GetCurrentResourceName(), name))
    local info = extractIdentifiers(player)
    local playerIdentifier = info.license
    MySQL.query('SELECT * FROM wasabi_bans WHERE license = ?', {playerIdentifier}, function(result)
        if result[1] then
            local time = result[1].ban_time
            local expTime = result[1].exp_time
            if expTime == 'perm' then
                deferrals.done((Strings.deferral_banned_perm):format(result[1].reason))
            end
            local timeLeft = math.floor(expTime - os.time())
            if timeLeft < 1 then
                MySQL.query('DELETE FROM wasabi_bans WHERE license = ?', { playerIdentifier })
                deferrals.done()
            elseif timeLeft > 1 or timeLeft == 1 then
                local hours, minutes = splitTime(timeLeft)
                deferrals.done((Strings.deferral_banned):format(result[1].reason, hours, minutes))
            end
        else
            deferrals.done()
        end
    end)
end

lib.callback.register('wasabi_adminmenu:getBanList', function(source)
    if not AdminPerms(source) then return false end
    local data
    MySQL.query('SELECT * FROM wasabi_bans', function(result)
        if result[1] then
            for i=1, #result do
                local timeLeft
                if result[i].exp_time == 'perm' then
                    timeLeft = 'perm'
                else
                    timeLeft = result[i].exp_time - os.time()
                end
                if timeLeft == 'perm' or timeLeft > 0 then
                    if not data then data = {} end
                    data[#data +1] = {
                        name = result[i].player,
                        license = result[i].license,
                        author = result[i].author,
                        reason = result[i].reason,
                        exp_time = result[i].exp_time,
                        time_left = timeLeft
                    }
                end
            end
        else
            data = {}
        end
    end)
    while not data do Wait() end
    return data
end)

lib.callback.register('wasabi_adminmenu:unban', function(source, targetlicense)
    if not AdminPerms(source) then return false end
    MySQL.query('DELETE FROM wasabi_bans WHERE license = ?', { targetlicense })
    return true
end)


AddEventHandler('playerConnecting', DisableConnect)
