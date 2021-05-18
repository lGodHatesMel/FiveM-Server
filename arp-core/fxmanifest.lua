fx_version 'cerulean'
games { 'gta5' }

client_script "@arp-errorlog/client/cl_errorlog.lua"
client_script "@PolyZone/client.lua"

server_scripts {
    'shared.lua',
    'server/sv_*.lua'
}

client_scripts {
    'shared.lua',
    'cl_cache.lua',
    'client/cl_*.lua'
}

ui_page 'html/index.html'

files {
    "html/index.html",
    "html/scripts.js",
    "html/css/style.css"
}


export "taskbar"
export "closeGuiFail"
export "getModule"
export "addModule"
export "FetchVehProps"
export "SetVehProps"
export "getCacheData"

server_export "getModule"
server_export "addModule"