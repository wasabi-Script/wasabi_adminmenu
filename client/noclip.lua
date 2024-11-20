local IsNoClipping,PlayerPed,NoClipEntity,Camera,NoClipAlpha,PlayerIsInVehicle    = false, nil, nil, nil, nil, false


local createEffect = function()
    lib.requestNamedPtfxAsset(Config.Noclip.Particle.Fxname, 100)
    local plyCoords = GetEntityCoords(NoClipEntity)

    UseParticleFxAssetNextCall(Config.Noclip.Particle.Fxname) -- Prepare the Particle FX for the next upcomming Particle FX call
    SetParticleFxNonLoopedColour(1.0, 0.0, 0.0) -- Setting the color to Red (R, G, B)
    StartNetworkedParticleFxNonLoopedAtCoord(Config.Noclip.Particle.Effectname, plyCoords, 0.0, 0.0, 0.0, 3.0, false, false, false, false) -- Start the animation itself

    RemoveNamedPtfxAsset(Config.Noclip.Particle.Fxname) -- Clean up
end


local disabledControls = function()
    HudWeaponWheelIgnoreSelection()
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 200, true)
end

local isControlAlwaysPressed = function(inputGroup, control)
    return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
end

local isPedDrivingVehicle = function(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1)
end

local setupCam = function()
    local entityRot = GetEntityRotation(NoClipEntity)
    Camera = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', GetEntityCoords(NoClipEntity), vector3(0.0, 0.0, entityRot.z), 75.0)
    SetCamActive(Camera, true)
    RenderScriptCams(true, true, 1000, false, false)

    if PlayerIsInVehicle == 1 then
        AttachCamToEntity(Camera, NoClipEntity, 0.0, Config.Noclip.FirstPersonWhileNoclip == true and 0.5 or -4.5, Config.Noclip.FirstPersonWhileNoclip == true and 1.0 or 2.0, true)
    else
        AttachCamToEntity(Camera, NoClipEntity, 0.0, Config.Noclip.FirstPersonWhileNoclip == true and 0.0 or -2.0, Config.Noclip.FirstPersonWhileNoclip == true and 1.0 or 0.5, true)
    end

end

local destroyCamera = function()
    SetGameplayCamRelativeHeading(0)
    RenderScriptCams(false, true, 1000, true, true)
    DetachEntity(NoClipEntity, true, true)
    SetCamActive(Camera, false)
    DestroyCam(Camera, true)
end

local getGroundCoords = function(coords)
    local rayCast               = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, -10000.0, 1, 0)
    local _, hit, hitCoords     = GetShapeTestResult(rayCast)
    return (hit == 1 and hitCoords) or coords
end

local checkInputRotation = function()
    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)

    local rotation = GetCamRot(Camera, 2)
    local yValue = rightAxisY * -5
    local newX
    local newZ = rotation.z + (rightAxisX * -10)
    if (rotation.x + yValue > -89.0) and (rotation.x + yValue < 89.0) then
        newX = rotation.x + yValue
    end
    if newX ~= nil and newZ ~= nil then
        SetCamRot(Camera, vector3(newX, rotation.y, newZ), 2)
    end

    SetEntityHeading(NoClipEntity, math.max(0, (rotation.z % 360)))
end

RunNoClipThread = function()
    CreateThread(function()
        while IsNoClipping do
            Wait(0)
            checkInputRotation()
            disabledControls()

            if isControlAlwaysPressed(2, Config.Noclip.Controls.DecreaseSpeed) then
                Config.Noclip.DefaultSpeed = Config.Noclip.DefaultSpeed - 0.5
                if Config.Noclip.DefaultSpeed < 0.5 then
                    Config.Noclip.DefaultSpeed = 0.5
                end
            elseif isControlAlwaysPressed(2, Config.Noclip.Controls.IncreaseSpeed) then
                Config.Noclip.DefaultSpeed = Config.Noclip.DefaultSpeed + 0.5
                if Config.Noclip.DefaultSpeed > Config.Noclip.MaxSpeed then
                    Config.Noclip.DefaultSpeed = Config.Noclip.MaxSpeed
                end
            elseif IsDisabledControlJustReleased(0, 348) then
                Config.Noclip.DefaultSpeed = 1
            end

            local multi = 1.0
            if isControlAlwaysPressed(0, 21) then -- Left Shift
                multi = 2
            elseif isControlAlwaysPressed(0, 19) then -- Left Alt
                multi = 4
            elseif isControlAlwaysPressed(0, 36) then  -- Left Control
                multi = 0.25
            end

            if isControlAlwaysPressed(0, Config.Noclip.Controls.MoveFoward) then
                local pitch = GetCamRot(Camera, 0)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.5*(Config.Noclip.DefaultSpeed * multi), (pitch.x*((Config.Noclip.DefaultSpeed/2) * multi))/89))
                else
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.5*(Config.Noclip.DefaultSpeed * multi), -1*((math.abs(pitch.x)*((Config.Noclip.DefaultSpeed/2) * multi))/89)))
                end
            elseif isControlAlwaysPressed(0, Config.Noclip.Controls.MoveBackward) then
                local pitch = GetCamRot(Camera, 2)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, -0.5*(Config.Noclip.DefaultSpeed * multi), -1*(pitch.x*((Config.Noclip.DefaultSpeed/2) * multi))/89))
                else
                    SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, -0.5*(Config.Noclip.DefaultSpeed * multi), ((math.abs(pitch.x)*((Config.Noclip.DefaultSpeed/2) * multi))/89)))
                end
            end

            if isControlAlwaysPressed(0, Config.Noclip.Controls.MoveLeft) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, -0.5*(Config.Noclip.DefaultSpeed * multi), 0.0, 0.0))
            elseif isControlAlwaysPressed(0, Config.Noclip.Controls.MoveRight) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.5*(Config.Noclip.DefaultSpeed * multi), 0.0, 0.0))
            end

            if isControlAlwaysPressed(0, Config.Noclip.Controls.MoveUp) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.0, 0.5*(Config.Noclip.DefaultSpeed * multi)))
            elseif isControlAlwaysPressed(0, Config.Noclip.Controls.MoveDown) then
                SetEntityCoordsNoOffset(NoClipEntity, GetOffsetFromEntityInWorldCoords(NoClipEntity, 0.0, 0.0, -0.5*(Config.Noclip.DefaultSpeed * multi)))
            end

            local coords = GetEntityCoords(NoClipEntity)

            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            FreezeEntityPosition(NoClipEntity, true)
            SetEntityCollision(NoClipEntity, false, false)
            SetEntityVisible(NoClipEntity, false, false)
            SetEntityInvincible(NoClipEntity, true)
            SetLocalPlayerVisibleLocally(true)
            SetEntityAlpha(NoClipEntity, NoClipAlpha, false)
            if PlayerIsInVehicle == 1 then
                SetEntityAlpha(PlayerPed, NoClipAlpha, false)
            end
            SetEveryoneIgnorePlayer(PlayerPed, true)
            SetPoliceIgnorePlayer(PlayerPed, true)
        end
        StopNoClip()
    end)
end

StopNoClip = function()
    FreezeEntityPosition(NoClipEntity, false)
    SetEntityCollision(NoClipEntity, true, true)
    SetEntityVisible(NoClipEntity, true, false)
    SetLocalPlayerVisibleLocally(true)
    ResetEntityAlpha(NoClipEntity)
    ResetEntityAlpha(PlayerPed)
    SetEveryoneIgnorePlayer(PlayerPed, false)
    SetPoliceIgnorePlayer(PlayerPed, false)
    ResetEntityAlpha(NoClipEntity)
    SetPoliceIgnorePlayer(PlayerPed, true)
    createEffect()
    HideTextUI()

    if GetVehiclePedIsIn(PlayerPed, false) ~= 0 then
        while (not IsVehicleOnAllWheels(NoClipEntity)) and not IsNoClipping do
            Wait(0)
        end
        while not IsNoClipping do
            Wait(0)
            if IsVehicleOnAllWheels(NoClipEntity) then
                return SetEntityInvincible(NoClipEntity, false)
            end
        end
    else
        if (IsPedFalling(NoClipEntity) and math.abs(1 - GetEntityHeightAboveGround(NoClipEntity)) > 1.00) then
            while (IsPedStopped(NoClipEntity) or not IsPedFalling(NoClipEntity)) and not IsNoClipping do
                Wait(0)
            end
        end
        while not IsNoClipping do
            Wait(0)
            if (not IsPedFalling(NoClipEntity)) and (not IsPedRagdoll(NoClipEntity)) then
                return SetEntityInvincible(NoClipEntity, false)
            end
        end
    end
end

ToggleNoClip = function(state)
    IsNoClipping = state or not IsNoClipping
    PlayerPed    = cache.ped
    PlayerIsInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    createEffect()
    if PlayerIsInVehicle ~= 0 and isPedDrivingVehicle(PlayerPed, GetVehiclePedIsIn(PlayerPed, false)) then
        NoClipEntity = GetVehiclePedIsIn(PlayerPed, false)
        SetVehicleEngineOn(NoClipEntity, not IsNoClipping, true, IsNoClipping)
        NoClipAlpha = Config.Noclip.FirstPersonWhileNoclip == true and 0 or 51
    else
        NoClipEntity = PlayerPed
        NoClipAlpha = Config.Noclip.FirstPersonWhileNoclip == true and 0 or 51
    end

    if IsNoClipping then
        FreezeEntityPosition(PlayerPed)
        setupCam()
        PlaySoundFromEntity(-1, 'SELECT', PlayerPed, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)
        ShowTextUI(Strings.textui_noclip_activated)

        if not PlayerIsInVehicle then
            ClearPedTasksImmediately(PlayerPed)
            if Config.Noclip.FirstPersonWhileNoclip then
                Wait(1000) -- Wait for the cinematic effect of the camera transitioning into first person
            end
        else
            if Config.Noclip.FirstPersonWhileNoclip then
                Wait(1000) -- Wait for the cinematic effect of the camera transitioning into first person
            end
        end

    else
        local groundCoords      = getGroundCoords(GetEntityCoords(NoClipEntity))
        SetEntityCoords(NoClipEntity, groundCoords.x, groundCoords.y, groundCoords.z)
        Wait(50)
        destroyCamera()
        PlaySoundFromEntity(-1, 'CANCEL', PlayerPed, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)
    end

    SetUserRadioControlEnabled(not IsNoClipping)

    if IsNoClipping then
        RunNoClipThread()
    end
end

RegisterNetEvent('wasabi_adminmenu:noclip',function()
    ToggleNoClip(not IsNoClipping)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        FreezeEntityPosition(NoClipEntity, false)
        FreezeEntityPosition(PlayerPed, false)
        SetEntityCollision(NoClipEntity, true, true)
        SetEntityVisible(NoClipEntity, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(NoClipEntity)
        ResetEntityAlpha(PlayerPed)
        SetEveryoneIgnorePlayer(PlayerPed, false)
        SetPoliceIgnorePlayer(PlayerPed, false)
        ResetEntityAlpha(NoClipEntity)
        SetPoliceIgnorePlayer(PlayerPed, true)
        SetEntityInvincible(NoClipEntity, false)
    end
end)