@echo off
echo Installing all required libraries.

haxelib --never install lime
haxelib --never install openfl
haxelib --never git flixel https://github.com/HaxeFlixel/flixel
haxelib --never install flixel-tools
haxelib --never git flixel-ui https://github.com/HaxeFlixel/flixel-ui
haxelib --never git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib --never git linc_luajit https://github.com/Leather128/linc_luajit.git
haxelib --never git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved codename-dev
haxelib --never git scriptless-polymod https://github.com/Vortex2Oblivion/scriptless-polymod
haxelib --never git hxNoise https://github.com/whuop/hxNoise
haxelib --never install hxvlc
haxelib --never git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib --never git fnf-modcharting-tools https://github.com/Vortex2Oblivion/FNF-Modcharting-Tools
haxelib --never git flxanimate https://github.com/Vortex2Oblivion/flxanimate
haxelib --never git thx.core https://github.com/fponticelli/thx.core
haxelib --never git thx.semver https://github.com/fponticelli/thx.semver.git
haxelib --never git jsonpath https://github.com/EliteMasterEric/jsonpath
haxelib --never git jsonpatch https://github.com/EliteMasterEric/jsonpatch
haxelib --never git funkin.vis https://github.com/FunkinCrew/funkVis
haxelib --never git grig.audio https://gitlab.com/haxe-grig/grig.audio
haxelib --never git hxcpp https://github.com/HaxeFoundation/hxcpp
haxelib --never install hxcpp-debug-server

echo Finished