package modding;

#if MODDING_ALLOWED
import substates.MusicBeatSubstate;
import utilities.Options;
import modding.ModList;
import modding.PolymodHandler;
import ui.Option;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SwitchModSubstate extends MusicBeatSubstate {
	var curSelected:Int = 0;
	var ui_Skin:Null<String>;

	public var page:FlxTypedGroup<ChangeModOption> = new FlxTypedGroup<ChangeModOption>();

	public static var instance:SwitchModSubstate;

	var descriptionText:FlxText;
	var descBg:FlxSprite;

	override function create() {
		if (ui_Skin == null || ui_Skin == "default")
			ui_Skin = Options.getData("uiSkin");

		instance = this;

		var menuBG:FlxSprite;

		menuBG = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK, false, "optimizedMenuDesat");
		menuBG.alpha = 0.5;
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set();
		add(menuBG);

		super.create();
		add(page);

		PolymodHandler.loadModMetadata();

		loadMods();

		descBg = new FlxSprite(0, FlxG.height - 90).makeGraphic(FlxG.width, 90, 0xFF000000);
		descBg.alpha = 0.6;
		descBg.scrollFactor.set();
		add(descBg);

		descriptionText = new FlxText(descBg.x, descBg.y + 4, FlxG.width, "Template Description", 18);
		descriptionText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER);
		descriptionText.borderColor = FlxColor.BLACK;
		descriptionText.borderSize = 1;
		descriptionText.borderStyle = OUTLINE_FAST;
		descriptionText.scrollFactor.set();
		descriptionText.screenCenter(X);
		add(descriptionText);

		var leText:String = "Press ENTER to switch to the currently selected mod.";

		var text:FlxText = new FlxText(0, FlxG.height - 22, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		text.borderColor = FlxColor.BLACK;
		text.borderSize = 1;
		text.borderStyle = OUTLINE_FAST;
		add(text);
	}

	function loadMods() {
		page.forEachExists(function(option:ChangeModOption) {
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		for (modId in PolymodHandler.metadataArrays) {
			if (ModList.modList.get(modId) && ModList.modMetadatas.get(modId).metadata.get('canBeSwitchedTo') != 'false') {
				var modOption = new ChangeModOption(ModList.modMetadatas.get(modId).title, modId);
				page.add(modOption);
				optionLoopNum++;
			}
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (-1 * Math.floor(FlxG.mouse.wheel) != 0) {
			curSelected -= 1 * Math.floor(FlxG.mouse.wheel);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.UP_P) {
			curSelected--;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.DOWN_P) {
			curSelected++;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.BACK) {
			close();
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members) {
			x.alphabetText.targetY = bruh - curSelected;

			if (x.alphabetText.targetY == 0) {
				descriptionText.screenCenter(X);

				@:privateAccess
				descriptionText.text = ModList.modMetadatas.get(x.optionValue).description + "\nAuthor: " + ModList.modMetadatas.get(x.optionValue)._author
					+ "\nLeather Engine Version: " + ModList.modMetadatas.get(x.optionValue).apiVersion + "\nMod Version: "
					+ ModList.modMetadatas.get(x.optionValue).modVersion + "\n";
			}

			bruh++;
		}
	}
}
#end
