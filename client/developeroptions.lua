-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local debugMode

local rotationToDirection = function(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local rayCastGamePlayCamera = function(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = rotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

local adminDeleteEntity = function(entity)
    if not DoesEntityExist(entity) then return end
    if IsEntityAPed(entity) and IsPedAPlayer(entity) then
        TriggerEvent('wasabi_adminmenu:notify', Strings.cant_delete, Strings.cant_delete_player_desc, 'error')
        return
    end
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local entCheck = NetworkGetEntityFromNetworkId(netId)
    if entCheck == 0 then
        TriggerEvent("wasabi_adminmenu:notify", Strings.cant_delete, Strings.cant_delete_entity_desc, 'error')
        return
    end
    TriggerServerEvent('wasabi_adminmenu:deleteEntity', netId)
end

local roundInt = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local startDebugModeThread = function()
    CreateThread(function()
        local textUI
        local outLined
        while true do
            if debugMode then
                local position = GetEntityCoords(cache.ped)
                local hit, coords, entity = rayCastGamePlayCamera(1000.0)
                if hit then
                    DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
                    DrawMarker(28, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.135, 0.25, 0.25, 255, 0, 0, 50, false, true, 2, true, false, false, false)
                    if entity then
                        if DoesEntityExist(entity) then    
                            local eCoords = GetEntityCoords(entity)
                            if eCoords ~= vector3(0.0,0.0,0.0) then
                                local modelHash = GetEntityModel(entity)
                                local heading = GetEntityHeading(entity)
                                local entOwner = NetworkGetEntityOwner(entity)
                                local playerName = GetPlayerName(entOwner)
                                if not textUI then
                                    if entOwner and playerName then
                                        ShowTextUI((Strings.debug_textui_name):format(modelHash, roundInt(eCoords.x, 2), roundInt(eCoords.y, 2), roundInt(eCoords.z, 2), roundInt(heading, 2),GetPlayerServerId(entOwner), playerName))
                                    else
                                        ShowTextUI((Strings.debug_textui_noname):format(modelHash, roundInt(eCoords.x, 2), roundInt(eCoords.y, 2), roundInt(eCoords.z, 2), roundInt(heading, 2)))
                                    end
                                    textUI = true
                                end
                                if not outLined and not IsEntityAPed(entity) then
                                    outLined = entity
                                    SetEntityDrawOutline(outLined, true)
                                    SetEntityDrawOutlineColor(255, 0, 0, 255)
                                end
                                if IsControlJustReleased(0, 38) then
                                    adminDeleteEntity(entity)
                                    if textUI then
                                        HideTextUI()
                                        textUI = false
                                    end
                                end
                            else
                                if textUI then
                                    textUI = nil
                                    HideTextUI()
                                end
                                if outLined then
                                    SetEntityDrawOutline(outLined, false)
                                    outLined = nil
                                end
                            end
                        else
                            if textUI then
                                HideTextUI()
                                textUI = nil
                            end
                            if outLined then
                                SetEntityDrawOutline(outLined, false)
                                outLined = nil
                            end

                        end
                    end
                else
                    if textUI then
                        HideTextUI()
                        textUI = false
                    end
                    if outLined then
                        SetEntityDrawOutline(outLined, false)
                        outLined = nil
                    end
                end
            else
                if textUI then
                    textUI = false
                    HideTextUI()
                end
                if outLined then
                    SetEntityDrawOutline(outLined, false)
                    outLined = nil
                end
                break
            end
            Wait()
        end
    end)
end

local toggleDebugMode = function(enabled)
    if enabled and debugMode then return end
    debugMode = enabled
    if enabled then
        startDebugModeThread()
    end
end

local copyVec3 = function()
    local coords = GetEntityCoords(cache.ped)
    lib.setClipboard('vector3('..roundInt(coords.x, 2)..', '..roundInt(coords.y, 2)..', '..roundInt(coords.z, 2)..')')
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_vec3, 'success', 'copy')
end

local copyVec4 = function()
    local coords, heading = GetEntityCoords(cache.ped), GetEntityHeading(cache.ped)
    lib.setClipboard('vector4('..roundInt(coords.x, 2)..', '..roundInt(coords.y, 2)..', '..roundInt(coords.z, 2).. ', ' .. roundInt(heading, 2).. ')')
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_vec4, 'success', 'copy')
end

local copyHeading = function()
    local heading = GetEntityHeading(cache.ped)
    lib.setClipboard(roundInt(heading, 2))
    TriggerEvent('wasabi_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_headin, 'success', 'copy')
end

DeveloperOptions = function()
    lib.registerMenu({
        id = 'admin_menu_devoptions',
        title = Strings.developer_options,
        position = Config.MenuPosition,
        onClose = function()
            AdminMenu()
        end,
        onCheck = function(selected, checked)
            if selected == 1 then
                toggleDebugMode(checked)
            end
        end,
        options = {
            {
                icon = 'bug-slash',
                label = Strings.debug_mode,
                description = Strings.debug_mode_desc,
                checked = debugMode or false
            },
            {
                icon = 'copy',
                label = Strings.copy_vec3,
                description = Strings.copy_vec3_desc
            },
            {
                icon = 'copy',
                label = Strings.copy_vec4,
                description = Strings.copy_vec4_desc
            },
            {
                icon = 'copy',
                label = Strings.copy_heading,
                description = Strings.copy_heading_desc
            }
        }
    }, function(selected)
        if selected == 2 then
            copyVec3()
        elseif selected == 3 then
            copyVec4()
        elseif selected == 4 then
            copyHeading()
        end
    end)
    lib.showMenu('admin_menu_devoptions')
end
