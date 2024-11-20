-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Wasabi ESX/QBCore Admin Menu'
author 'wasabirobby#5110'
version '1.0.0'

shared_scripts {'@ox_lib/init.lua', 'configs/strings.lua', 'configs/config.lua'}

client_scripts {'bridge/**/client.lua', 'configs/peds.lua', 'configs/modifyme.lua', 'client/*.lua'}

server_scripts {'@oxmysql/lib/MySQL.lua', 'bridge/**/server.lua', 'server/*.lua', 'configs/sconfig.lua'}

dependecies {'ox_lib', 'oxmysql'}

escrow_ignore {'bridge/**/*.lua', 'configs/*.lua', 'client/*.lua', 'server/*.lua'}

dependency '/assetpacks'