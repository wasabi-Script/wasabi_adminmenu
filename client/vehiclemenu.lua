-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local torqueLoop, breakLoop
local SetTorque = function(value)
    if not IsPedInAnyVehicle(cache.ped, true) then return end
    if torqueLoop then
        breakLoop = true
    end
    CreateThread(function()
        torqueLoop = true
        while true do
            if breakLoop or not IsPedInAnyVehicle(cache.ped, true) or value == 1.0 then
                torqueLoop, breakLoop = nil, nil
                HideTextUI()
                break
            end
            local vehicle = GetVehiclePedIsIn(cache.ped, false)
            SetVehicleEngineTorqueMultiplier(vehicle, value)
            ShowTextUI((Strings.textui_torque):format(value))
            Wait()
        end
    end)
end

local DoorStatus = function(Status)
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    if Status == 2 then
        SetVehicleDoorsLocked(Vehicle, 2)
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_locked_doors, Strings.notify_locked_doors_desc, 'success', 'fa-car')
    elseif Status == 1 then
        SetVehicleDoorsLocked(Vehicle, 1)
        TriggerEvent('wasabi_adminmenu:notify', Strings.notify_unlocked_doors, Strings.notify_unlocked_doors_desc, 'success', 'fa-car')
    end
end

local ChangePlate = function()
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    local Plate = lib.inputDialog('Custom LicensePlate', { {
        type = 'input',
        label = 'Plate..',
        placeholder = 'License Plate'
    } })
    if not Plate[1] then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_invalid_entry, 'error', 'fa-xmark')
    end
    SetVehicleNumberPlateText(Vehicle, Plate[1])
end

local DeleteCar = function()
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    SetEntityAsMissionEntity(Vehicle, true, true)
    DeleteEntity(Vehicle)
end

local RepairCar = function()
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    SetVehicleUndriveable(Vehicle, false)
    SetVehicleFixed(Vehicle)
    SetVehicleEngineOn(Vehicle, true, false)
    SetVehicleDirtLevel(Vehicle, 0.0)
    SetVehicleOnGroundProperly(Vehicle)
    SetVehicleFuelLevel(Vehicle, GetFuelLevel(Vehicle))
end

local setVehicleMods = function(vehicle, mods)
    if not DoesEntityExist(vehicle) or not mods then return end
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    SetVehicleModKit(vehicle, 0)
    if mods?.plate then SetVehicleNumberPlateText(vehicle, tostring(mods.plate)) end
    if mods?.color1 then SetVehicleColours(vehicle, tonumber(mods.color1), secondaryColor) end
    if mods?.color2 then SetVehicleColours(vehicle, tonumber(mods?.color1) or primaryColor, mods.color2) end
    if mods?.modTurbo then ToggleVehicleMod(vehicle, 18, mods.modTurbo) end
end

local Refuel = function()
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    SetVehicleFuelLevel(Vehicle, SetMaxFuel(Vehicle))
end

local SpawnCar = function()
    local Colors = {}
    for i = 1, #Config.VehicleColors do
        Colors[#Colors + 1] = {
            label = Config.VehicleColors[i].label,
            value = Config.VehicleColors[i].value
        }
    end
    local Spawn = lib.inputDialog(Strings.dialog_spawn_a_car, { {
        type = 'input',
        label = Strings.dialog_car_model,
        placeholder = Strings.dialog_car_model_holder
    }, {
        type = 'input',
        label = Strings.dialog_car_plate,
        placeholder = Strings.dialog_car_plate_holder
    }, {
        type = 'select',
        label = Strings.dialog_car_color_primary,
        options = Colors
    }, {
        type = 'select',
        label = Strings.dialog_car_color_second,
        options = Colors
    }, {
        type = 'checkbox',
        label = Strings.dialog_car_maxed,
        checked = false
    } })
    if not Spawn then return end
    if not Spawn[1] then return end
    local Ply = cache.ped
    local coords = GetEntityCoords(Ply)
    lib.requestModel(Spawn[1], 100)
    local vehicle = CreateVehicle(GetHashKey(Spawn[1]), coords.x, coords.y, coords.z, 300.0, 1, 0)
    local data = {
        color1 = tonumber(Spawn[3]) or nil,
        color2 = tonumber(Spawn[4]) or nil,
        modTurbo = Spawn[5] or nil
    }
    if Spawn[2] then data.plate = tostring(Spawn[2]) end
    if not data.plate and not data.color1 and not data.color2 and not data.modTurbo then data = nil end
    if data then setVehicleMods(vehicle, data) end
    if Config.UsingVehicleKeys and Config.UsingVehicleKeys ~= '' then
        GiveVehKeys(GetVehicleNumberPlateText(vehicle), Spawn[1], vehicle)
    end
    TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
end

local ChangeVehColor = function(value)
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    local data = { color1 = value, color2 = value }
    setVehicleMods(Vehicle, data)
end

local GiveKeys = function()
    if not Config.UsingVehicleKeys then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_disabled_keys, 'error', 'fa-xmark')
    end
    local coords = GetEntityCoords(cache.ped)
    local Vehicle = lib.getClosestVehicle(coords, 5.0, true)
    if not Vehicle or not DoesEntityExist(Vehicle) then
        return TriggerEvent('wasabi_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    GiveVehKeys(GetVehicleNumberPlateText(Vehicle))
end


---- this function is global since its needed in main.lua where its getting triggered to open

VehicleOptions = function()
    local VehicleColor = {}
    local Torque = {}
    for i = 1, #Config.VehicleColors do
        VehicleColor[#VehicleColor + 1] = Config.VehicleColors[i]
    end
    for i = 1, #Config.TorqueMultiplier do
        Torque[#Torque + 1] = Config.TorqueMultiplier[i]
    end
    lib.registerMenu({
        id = 'admin_menu_vehicleoptions',
        title = Strings.vehicle_menu,
        position = Config.MenuPosition,
        onClose = function()
            AdminMenu()
        end,
        options = { {
            icon = 'fa-car-on',
            label = Strings.spawn_car,
            description = Strings.spawn_car_desc
        }, {
            icon = 'fa-screwdriver-wrench',
            close = false,
            label = Strings.repair_car,
            description = Strings.repair_car_desc
        }, {
            icon = 'fa-trash',
            close = false,
            label = Strings.delete_car,
            description = Strings.delete_car_desc
        }, {
            icon = 'fa-pen',
            label = Strings.number_plate,
            description = Strings.number_plate_desc
        }, {
            icon = 'fa-gas-pump',
            close = false,
            label = Strings.refuel,
            description = Strings.refuel_desc
        }, {
            icon = 'fa-key',
            close = false,
            label = Strings.give_keys,
            description = Strings.give_keys_desc
        }, {
            icon = 'fa-unlock-keyhole',
            label = Strings.doors,
            description = Strings.doors_desc,
            values = { 'Unlock', 'Lock' },
            defaultIndex = 1,
            close = false
        }, {
            icon = 'fa-bolt',
            label = Strings.boost_car,
            description = Strings.boost_car_desc,
            values = Torque,
            defaultIndex = 1,
            close = false
        }, {
            icon = 'fa-palette',
            label = Strings.color_change,
            description = Strings.color_change_desc,
            values = VehicleColor,
            defaultIndex = 1,
            close = false
        } }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            SpawnCar()
        elseif selected == 2 then
            RepairCar()
        elseif selected == 3 then
            DeleteCar()
        elseif selected == 4 then
            ChangePlate()
        elseif selected == 5 then
            Refuel()
        elseif selected == 6 then
            GiveKeys()
        elseif selected == 7 then
            DoorStatus(scrollIndex)
        elseif selected == 8 then
          SetTorque(Torque[scrollIndex].value)
        elseif selected == 9 then
            ChangeVehColor(VehicleColor[scrollIndex].value)
        end
    end)
    lib.showMenu('admin_menu_vehicleoptions')
end
