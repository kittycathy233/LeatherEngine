package toolbox.util;

import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.text.FlxText;
import openfl.utils.Assets;
import flixel.FlxSprite;
import flixel.FlxG;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import states.MusicBeatState;
import flixel.addons.ui.FlxUIInputText;


class NewModState extends MusicBeatState{

    var bg:FlxSprite;

    var modNameText:FlxText;
    var modName:FlxUIInputText;

    var UI_box:FlxUITabMenu;

    override function create(){
        super.create();
        #if discord_rpc
		DiscordClient.changePresence("Creating A New Mod", null, null, true);
		#end
        bg = new FlxSprite();
        if(Options.getData("menuBGs")){
            bg.loadGraphic(Paths.image(Assets.exists('ui skins/${Options.getData("uiSkin")}/backgrounds/menuCharter') ? 'ui skins/${Options.getData("uiSkin")}/backgrounds/menuCharter' : 'ui skins/default/backgrounds/menuCharter'));
            bg.screenCenter();
            add(bg);
        }

        UI_box = new FlxUITabMenu(null, [{name: "New Mod", label: 'New Mod'},], true);

		UI_box.resize(640, 480);
        UI_box.screenCenter();
		add(UI_box);

        var tab_Group_mod = new FlxUI(null, UI_box);
		tab_Group_mod.name = "New Mod";

        UI_box.addGroup(tab_Group_mod);
		UI_box.scrollFactor.set();

        modName = new FlxUIInputText(400, 250);
        modName.size = 16;
        add(modName);

        modNameText = new FlxText();
        modNameText.x = modName.x;
        modNameText.y = modName.y - 30;
        modNameText.alignment = FlxTextAlign.CENTER;
        modNameText.size = 16;
        modNameText.text = "Mod Name";
        add(modNameText);

    }
    override function update(elapsed:Float){
        super.update(elapsed);
        if(FlxG.keys.anyJustPressed([ESCAPE])){
            FlxG.switchState(() -> new ToolboxPlaceholder());
        }
    }
}