AdminPerms = function(source)
    local authorized
    if Config.AdminPerms.UserGroups.enabled then
        for i=1, #Config.AdminPerms.UserGroups.Groups do
            if HasPermission(source, Config.AdminPerms.UserGroups.Groups[i]) then
                authorized = true
                break
            end
        end
    end
    if Config.AdminPerms.AcePerms.enabled then
        if IsPlayerAceAllowed(source, Config.AdminPerms.AcePerms.AcePerm) then
            athorized = true
        end
    end
    return authorized
end
