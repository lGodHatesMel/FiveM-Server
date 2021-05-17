fx_version 'cerulean'
games { 'gta5' }

client_script "@arp-errorlog/client/cl_errorlog.lua"
client_script "@PolyZone/client.lua"

server_scripts {
    'shared.lua',
    'sv_*.lua'
}

client_scripts {
    'shared.lua',
    'cl_*.lua'
}

ui_page 'html/index.html'

files {
    "html/index.html",
    "html/scripts.js",
    "html/css/style.css"
}

exports {
    "taskBar",
    "closeGuiFail",
    "getModule",
    "addModule",
    "FetchVehProp",
    "SetVehProps",
	"getCacheData"
}

server_exports {
    "getModule",
    "addModule"
}