package tools.toolbox; 

import flixel.text.FlxText;
import modding.ModList;
import modding.PolymodHandler;
import tools.toolbox.NewModWizard;
import utilities.CoolUtil;
import flixel.addons.ui.FlxUIButton;
import flixel.ui.FlxButton;
import states.MainMenuState;
import flixel.FlxG;
import openfl.utils.Assets;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import states.MusicBeatState;
import flixel.group.FlxGroup.FlxTypedGroup;

#if discord_rpc
import utilities.Discord.DiscordClient;
#end


class Toolbox extends MusicBeatState {

	var ui_Skin:Null<String>;

	var curSelected:Int = 0;

	public var modList:FlxTypedGroup<FlxButton> = new FlxTypedGroup<FlxButton>();

	var descriptionText:FlxText;
	var descBg:FlxSprite;


	override public function create() {
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Toolbox", null);
		#end
		FlxG.mouse.visible = true;
		if (ui_Skin == null || ui_Skin == "default")
			ui_Skin = Options.getData("uiSkin");

		MusicBeatState.windowNameSuffix = " Toolbox";

		var menuBG:FlxSprite;

		if(Options.getData("menuBGs"))
			if (!Assets.exists(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuToolbox')))
				menuBG = new FlxSprite().loadGraphic(Paths.image('ui skins/default/backgrounds/menuToolbox'));
			else
				menuBG = new FlxSprite().loadGraphic(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuToolbox'));
		else
			menuBG = new FlxSprite().makeGraphic(1286, 730, FlxColor.fromString("#00E108"), false, "optimizedMenuDesat");

		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();

		descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.alpha = 0.6;
		add(descBg);

		descriptionText = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Template Description", 18);
		descriptionText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER);
		descriptionText.borderColor = FlxColor.BLACK;
		descriptionText.borderSize = 1;
		descriptionText.borderStyle = OUTLINE;
		descriptionText.scrollFactor.set();
		descriptionText.screenCenter(X);
		add(descriptionText);


		add(modList);
	}

	function loadMods()
		{
			modList.forEachExists(function(option:FlxButton)
			{
				modList.remove(option);
				option.kill();
				option.destroy();
			});
	
			var optionLoopNum:Int = 0;
	
			for(modId in PolymodHandler.metadataArrays)
			{
				var modOption = new FlxButton(10, optionLoopNum, modId);
				modList.add(modOption);
				optionLoopNum++;
			}
		}

	override public function update(elapsed){
		super.update(elapsed);
		if (curSelected < 0)
			curSelected = modList.length - 1;

		if (curSelected >= modList.length)
			curSelected = 0;
		if (controls.BACK) FlxG.switchState(new MainMenuState());
		var bruh = 0;

		for (x in modList.members)
		{
			x.y = bruh - curSelected;

			if(x.y == 0)
			{
				descriptionText.screenCenter(X);

				@:privateAccess
				descriptionText.text = 
				ModList.modMetadatas.get(x.text).description 
				+ "\nAuthor: " + ModList.modMetadatas.get(x.text)._author 
				+ "\nLeather Engine Version: " + ModList.modMetadatas.get(x.text).apiVersion 
				+ "\nMod Version: " + ModList.modMetadatas.get(x.text).modVersion 
				+ "\n";
			}

			bruh++;
		}
	}
}