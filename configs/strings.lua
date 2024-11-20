-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
Strings = {
    -- Main Menu
    main_title = 'Admin Menu',
    self_options = 'Self Options',
    self_options_desc = 'Self related options',
    player_options_title = 'Player Options',
    player_options_desc = 'Player related options',
    vehicle_options = 'Vehicle Options',
    vehicle_options_desc = 'Vehicle related options',
    server_options = 'Server Options',
    server_options_desc = 'Server related options',
    admin_zone_options = 'Admin Zones',
    admin_zone_options_desc = 'Manage, add, and delete admin zones',
    developer_options = 'Developer Options',
    developer_options_desc = '',

    -- Self Options Menu
    self_options_menu = 'Self Options',
    self_health = 'Health (%s%%)',
    self_noclip = 'No Clip',
    self_revive = 'Revive',
    self_revive_desc = 'Revive yourself',
    self_heal = 'Heal',
    self_heal_desc = 'Heal yourself',
    self_skinmenu = 'Skin Menu',
    self_set_ped = 'Change Ped',
    self_skinmenu_desc = 'Open skin menu locally',
    self_invisible = 'Invisible',
    self_godmode = 'God Mode',


    -- Player Options Menu
    player_options_menu = 'Players Online %s/%s',
    player_options = 'Player: %s',
    player_health = 'Player Health (%s%%)',
    player_freeze = 'Freeze',
    player_freeze_desc = 'Toggle on/off',
    player_noclip = 'No Clip',
    player_noclip_desc = 'Toggle on/off',
    player_playerdata = 'Player Data',
    player_playerdata_desc = 'View player\'s data',
    player_revive = 'Revive',
    player_revive_desc = 'Revive player',
    player_heal = 'Heal',
    player_heal_desc = 'Heal player',
    player_skinmenu = 'Skin Menu',
    player_skinmenu_desc = 'Give player a skin menu',
    player_money = 'Give Money',
    player_money_desc = 'Give selected player money',
    player_item = 'Give Item',
    player_item_desc = 'Give selected player an item',
    player_openinv = 'Open Inventory',
    player_openinv_desc = 'Open player\'s inventory',
    player_clearinv = 'Clear Inventory',
    player_clearinv_desc = 'Clear player\'s inventory',
    player_teleport_to = 'Teleport To Player',
    player_teleport_to_desc  = 'Teleport to player',
    player_bring = 'Bring',
    player_bring_desc = 'Bring player to your location',
    player_kick = 'Kick',
    player_kick_desc = 'Kick player from the server',
    player_ban = 'Ban Player',


    -- Vehicle Menu
    vehicle_menu = 'Vehicle Menu',
    spawn_car = 'Spawn Vehicle',
    spawn_car_desc = 'Spawn in a vehicle',
    repair_car = 'Repair Vehicle',
    repair_car_desc = 'Repair the current or closest vehicle',
    delete_car = 'Delete Vehicle',
    delete_car_desc = 'Delete the current or closest vehicle',
    number_plate = 'Modify License Plate',
    number_plate_desc = 'Change current license plate text',
    refuel = 'Refuel Vehicle',
    refuel_desc = 'Refuel the current or closest vehicle',
    give_keys = 'Give Keys',
    give_keys_desc = 'Give yourself keys to current vehicle',
    doors = 'Lock/Unlock Doors',
    doors_desc = 'Toggles locks of closest vehicle',
    boost_car = 'Torque Modifier',
    boost_car_desc = 'Modify the torque of current vehicle',
    color_change = 'Change Vehicle Color',
    color_change_desc = 'Change the current or closest vehicle color',

    -- Server Management Menu
    server_management = 'Server Management',
    server_announcement = 'Server Announcement',
    server_announcement_desc = 'Send out a global server announcement',
    ban_list = 'Ban List',
    ban_list_desc = 'Check all active bans',
    objects_list = 'Delete Entities',
    objects_list_desc = 'Delete vehicles and peds',
    objects_list_label = 'Options',
    weather_menu = 'Weather Management',
    weather_menu_desc = 'Manage the weather',

    -- Admin Zone Menu
    zones_create = 'Create Zone',
    zones_create_desc = 'Create a new admin zone',
    zones_manage = 'Manage Zones',
    zones_manage_desc = 'Edit or delete active zones',
    zone_edit_current = 'Edit Current Zone',
    zone_edit_current_desc = 'Manage the zone you are currently within',
    zone_delete_current = 'Delete Current Zone',
    zone_delete_current_desc = 'Delete the zone you are currently within',
    zone_manage_menu = 'Editing Zone (%s)',
    zone_edit = 'Edit Zone',
    zone_edit_desc = 'Modify zone: %s',
    zone_delete = 'Delete Zone',
    zone_delete_desc = 'Delete zone: %s',
    zone_teleport = 'Teleport To Zone',
    zone_teleport_desc = 'Go to zone: %s',

    -- Developer Menu
    dev_options = 'Developer Options',
    debug_mode = 'Debug Mode',
    debug_mode_desc = 'Toggle debug mode',
    copy_vec3 = 'Copy Vector3 Coords',
    copy_vec3_desc = 'Will copy your current location (vector3) to your clipboard',
    copy_vec4 = 'Copy Vector4 Coords',
    copy_vec4_desc = 'Will copy your current location (vector4) to your clipboard',
    copy_heading = 'Copy Heading',
    copy_heading_desc = 'Will copy your current player heading to your clipboard',
    cant_delete = 'Can\'t Delete!',
    cant_delete_player_desc = 'You can not delete player peds!',
    cant_delete_entity_desc = 'You can not delete default objects!',

    -- Ban List Menu
    ban_list_menu = 'Ban List',
    ban_list_name = 'Name: %s',
    ban_list_license = 'License:';
    ban_list_by = 'Issuer: %s',
    ban_list_reason = 'Reason: %s',
    ban_list_length = 'Time Left: %s hours %s minutes',
    ban_list_modify = 'Modify Ban',
    ban_list_unban = 'Unban Player',
    ban_list_no_data = 'No Bans Found',
    ban_list_no_data_desc = 'There are no active bans found!',

    -- PlayerData Menu
    playerdata_menu = 'Player Data',
    playerdata_license_esx = 'License: %s',
    playerdata_license_qbcore = 'Citizen ID: %s',
    playerdata_license_desc = 'Click to copy full license',
    playerdata_igname = 'Name: %s',
    playerdata_igname_desc = 'Players full ingame name',
    playerdata_steam = 'Steam Name: %s',
    playerdata_steam_desc = 'Players full steam name',
    playerdata_gender = 'Gender: %s',
    playerdata_gender_desc = 'Players Gender',
    playerdata_cash = 'Cash: %s',
    playerdata_cash_desc = 'Players Cash Balance',
    playerdata_bank = 'Bank: %s',
    playerdata_bank_desc = 'Players Bank Money Balance',
    playerdata_blackmoney = 'Black Money: %s',
    playerdata_blackmoney_desc = 'Players Black Money Balance',



    -- TextUI
    -- Debug Mode Text Uis
    debug_textui_name = '**Press [E] to delete entity**  \nHash: %s  \nCoords: vec3(%s, %s, %s)  \nHeading: %s  \nOwner: [%s] - %s',
    debug_textui_noname = '**Press [E] to delete entity**\n  Hash: %s\n  Coords: vec3(%s, %s, %s)\n  Heading: %s\n  Owner: UNKNOWN',

    -- Self Option Invisible Text Ui
    textui_invisible = '**Invisible Mode** - *Activated*',
    -- Self Option GodMode  Text Ui
    textui_godmode = '**God Mode** - *Activated*',
    -- No Clip
    textui_noclip_activated = '**No Clip** -  *Activated*',
    -- Vehicle Menu, Torque multiplier
    textui_torque = '**Torque Multipler** - **%s**',

    -- Dialog Menus

    -- Announcements
    dialog_announce = 'Announcement',
    dialog_announce_label = 'Message',
    dialog_announce_select = 'Everyone',
    dialog_announce_placeholder = 'Important message here. . .',
    -- Kick Dialog used to confirm/deny the kick
    dialog_kick = 'Are you sure?',
    dialog_kick_content = 'Do You really want to kick %s?',

    --Dialog ban
    dialog_unban = 'Are you sure?',
    dialog_unban_content = 'Do You really want to unban %s?',

    -- Objects Dialog
    dialog_objects = 'Select an option',
    dialog_clear_objects = 'Clear ALL Objects',
    dialog_clear_cars = 'Clear ALL Cars(Without drivers)',
    dialog_clear_peds = 'Clear ALL Peds',

    -- Give Money Dialog Menu used for both self and player options give money
    dialog_givemoney = 'Give Money',
    givemoney_input_label = 'Amount',
    givemoney_input_placeholder = '123456',
    givemoney_select = 'Account',
    givemoney_select_option1 = 'Cash',
    givemoney_select_option2 = 'Bank',
    givemoney_select_option3 = 'Black Money',

    -- Give Item Dialog Menu used for player options give item
    dialog_giveitem = 'Give Item',
    giveitem_input_label = 'Item Name',
    giveitem_input_placeholder = 'burger',
    giveitem_amount_input_label = 'Amount',
    giveitem_amount_input_placeholder = '3',

    -- Spawn vehicle dialog
    dialog_spawn_a_car = 'Spawn Vehicle',
    dialog_car_model = 'Model Name',
    dialog_car_model_holder = 'Ex: 20charger',
    dialog_car_plate = 'License Plate (Optional)',
    dialog_car_plate_holder = 'Ex: W4S4B1',
    dialog_car_color_primary = 'Primary Color (Optional)',
    dialog_car_color_second = 'Secondary Color (Optional)',
    dialog_car_maxed = 'Max Modifications (Optional)',

    -- Kick Player Dialog Menu
    dialog_kick = 'Kick %s',
    dialog_kick_reason = 'Reason',
    dialog_kick_placeholder = 'Cheater',
    kicked_reason_replace = 'You\'ve been kicked from the server!', -- If no reason is put this will be the reason

    -- Ban Player Dialog Menu
    dialog_ban = 'Ban %s',
    dialog_ban_reason = 'Reason',
    dialog_ban_placeholder = 'Cheater',
    ban_reason_replace = 'You\'ve been banned from this server!', -- If no reason is put this will be the reason

    -- Create Admin Zone Dialog
    dialog_zone_create = 'Zone Creation',
    dialog_zone_name = 'Name',
    dialog_zone_name_desc = 'The name for the zone/blip',
    dialog_zone_name_holder = 'Admin Zone',
    dialog_zone_text = 'Display Text',
    dialog_zone_text_desc = 'The text to display to players within zone',
    dialog_zone_text_holder = 'ADMIN ZONE - ACTIVE',
    dialog_zone_size = 'Size',
    dialog_zone_speed = 'Speed Limit',
    mph = 'MPH',
    kmh = 'KM/H',
    dialog_zone_blip_id = 'Blip ID',
    dialog_zone_placeholder = '487',
    dialog_zone_blip_color = 'Color ID',
    dialog_zone_color_placeholder = '1',
    dialog_zone_blip_flashing = 'Flashing Blip',
    dialog_zone_disarm = 'Disarm',
    dialog_zone_revive = 'Revive',
    dialog_zone_invincible = 'Invincible',
    dialog_zone_edit = 'Editing \"%s\"',
    dialog_zone_delete_confirm = 'Are you sure?',
    dialog_zone_delete_confirm_desc = 'Do you really want to delete the zone: %s',



    -- Notifications

    -- Player Options Notifications
    notify_givemoney_success = 'Money Granted',
    notify_givemoney_success_desc = 'You credited %s $%s in account: %s',
    notify_givemoney_fail = 'Unsuccessful',
    notify_givemoney_fail_desc = 'You tried to credit %s but something went wrong! Please try again.',

    -- Player Give Item Notification
    notify_giveitem_success = 'Item Granted',
    notify_giveitem_success_desc = 'You credited %s. Item: %s Amount: %s',
    notify_giveitem_fail = 'Failed',
    notify_giveitem_fail_desc = 'You tried to credit %s but something went wrong! Please try again.',

    -- Player Kick Notifications
    notify_kicked_success = 'Kick Successful',
    notify_kicked_success_desc = 'You successfully kicked %s',

    -- Ban Player Notifications
    notify_banned_success = 'Ban Successful',
    notify_banned_success_desc = 'You successfully banned %s',

    -- Cleared Inv Notifications 
    notify_clearedinv = 'Cleared Inventory',
    notify_clearedinv_desc = 'You Successfully cleared the inventory of %s',

    -- Invalid ID for commands Notification 
    notify_invalidid = 'Invalid ID',
    notify_invalidid_desc = 'The ID you entered was invalid, please try again.',

    -- Deleted All Cars Notification
    notify_deleted_car = 'Cars Deleted',
    notify_deleted_car_desc = 'You Successfully deleted all cars without a driver.',

    -- Deleted All Peds Notification 
    notify_deleted_ped = 'Peds Deleted',
    notify_deleted_ped_desc = 'You Successfully deleted all peds on the map',

    -- Deleted All Objects Notification 
    notify_deleted_objects = 'Objects Deleted',
    notify_deleted_objects_desc = 'You Successfully deleted all objects on the map',

    -- Changed Weather Notification
    notify_weather = 'Weather Modified',
    notify_weather_desc = 'Weather modified to: %s',

    -- Copy Coords Notification
    notify_copied = 'Copied',
    notify_copied_vec3 = 'You successfully copied vector3 to clipboard!',
    notify_copied_vec4 = 'You successfully copied vector4 to clipboard!',
    notify_copied_headin = 'You successfully copied heading to clipboard!',

    -- Lock/Unlock vehicle doors notification
    notify_locked_doors = 'Locked',
    notify_locked_doors_desc = 'Successfully locked vehicle doors.',
    notify_unlocked_doors = 'Unlocked',
    notify_unlocked_doors_desc = 'Successfully unlocked vehicle doors.',

    -- Admin Zone notifications
    notify_zone_deleted = 'Zone Deleted',
    notify_zone_deleted_desc = 'You have successfully removed the zone: %s.',
    notify_zone_not_deleted_desc = 'An error occured when attempting to delete zone: %s.',
    notify_zone_edited = 'Zone Modified',
    notify_zone_edited_desc = 'You have successfully modified zone: %s.',
    notify_zone_not_edited_desc = 'An error occured when attempting to delete zone: %s.',
    notify_zone_action_cancelled = 'Action Cancelled',
    notify_zone_delete_cancel = 'You cancelled the deletion of zone: %s',
    notify_zone_no_weapons = 'Weapons Unauthorized',
    notify_zone_no_weapons_desc = 'You are not permitted to use weapons within the current zone.',
    notify_zones_not_found = 'No Zones Found',
    notify_zones_not_found_desc = 'There are currently no active zones to manage.',
    notify_zones_teleport = 'Teleported',
    notify_zones_teleport_desc = 'You have successfully teleported to zone: %s.',


    -- Ban system notifications
    successfully_unbanned = 'Ban Revoked',
    successfully_unbanned_desc = 'You have successfully unbanned: %s.',
    unsuccessful_unban = 'Something went wrong when trying to unban: %s.',




    -- Ban system
    deferral_welcome = '[%s] Hello %s, Checking for bans. . .',
    deferral_banned = 'You are Banned From the Server Reason: \'%s\' (Time Left: %s Hours %s Minutes).',
    deferral_banned_perm = 'You are Banned From the Server Reason: \'%s\' (Time Left: Permanent).',



    -- Error Notifys for vehicle menu
    notify_error = 'Error',
    notify_disabled_keys = 'There are no car lock scripts configured. Please contact server developer.',
    notify_no_vehicle = 'No vehicle found!',
    notify_invalid_entry = 'Invalid entry!',

    -- Key mapping strings
    keymapping_desc = 'Open Admin Menu (wasabi_adminmenu)',
}
