package ui;

import lime.app.Application;
import lime.graphics.Image;
import utilities.CoolUtil;
import states.TitleState;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import modding.ModList;
import flixel.FlxSprite;
import flixel.FlxState;
import states.OptionsMenu;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * The base option class that all options inherit from.
 */
class Option extends FlxTypedGroup<FlxSprite> {
	// variables //
	public var Alphabet_Text:Alphabet;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "downscroll";


	public function new(_Option_Name:String = "", _Option_Value:String = "downscroll", _Option_Row:Int = 0) {
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);
	}
}

/**
 * Simple Option with a checkbox that changes a bool value.
 */
class BoolOption extends Option {
	// variables //
	var Checkbox_Object:Checkbox;

	// options //
	public var Option_Checked:Bool = false;

	override public function new(_Option_Name:String = "", _Option_Value:String = "downscroll", _Option_Row:Int = 0) {
		super(_Option_Name, _Option_Value, _Option_Row);

		// SETTING VALUES //
		this.Option_Checked = GetObjectValue();

		// CREATING OTHER OBJECTS //
		Checkbox_Object = new Checkbox(Alphabet_Text);
		Checkbox_Object.checked = GetObjectValue();
		add(Checkbox_Object);
	}

	public function GetObjectValue():Bool {
		return Options.getData(Option_Value);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
			ChangeValue();
	}

	public function ChangeValue() {
		Options.setData(!Option_Checked, Option_Value);

		Option_Checked = !Option_Checked;
		Checkbox_Object.checked = Option_Checked;

		switch (Option_Value) // extra special cases
		{
			case "fpsCounter":
				Main.toggleFPS(Option_Checked);
			case "memoryCounter":
				Main.toggleMem(Option_Checked);
			#if discord_rpc
			case "discordRPC":
				if (Option_Checked && !DiscordClient.active)
					DiscordClient.initialize();
				else if (!Option_Checked && DiscordClient.active)
					DiscordClient.shutdown();
			#end
			case "versionDisplay":
				Main.toggleVers(Option_Checked);
		}
	}
}


/**
 * Very simple option that transfers you to a different page when selecting it.
 */
class PageOption extends Option {
	// OPTIONS //
	public var Page_Name:String = "Categories";

	override public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Page_Name:String = "Categories", _Description:String = "Test Description") {
		super(_Option_Name, _Page_Name, _Option_Row);

		// SETTING VALUES //
		this.Page_Name = _Page_Name;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Std.int(Alphabet_Text.targetY) == 0 && !OptionsMenu.inMenu)
			OptionsMenu.LoadPage(Page_Name);
	}
}

class GameSubstateOption extends Option {
	public var game_substate:Dynamic;

	public function new(_Option_Name:String = "", _Option_Row:Int = 0, _game_substate:Dynamic) {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		this.game_substate = _game_substate;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
			FlxG.state.openSubState(Type.createInstance(this.game_substate, []));
	}
}

/**
 * Very simple option that transfers you to a different game-state when selecting it.
 */
class GameStateOption extends Option {
	// OPTIONS //
	public var Game_State:FlxState;

	public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Game_State:Dynamic) {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		this.Game_State = _Game_State;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
			FlxG.switchState(Game_State);
	}
}

/**
 * Stuff for toolbox.
 */
 class ToolboxOption extends Option {
	// OPTIONS //
	public var Game_State:FlxState;

	public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Game_State:Dynamic) {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		this.Game_State = _Game_State;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!Options.getData("developer")) this.visible = false; else { this.visible = true;}

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0 && Options.getData("developer"))
			FlxG.switchState(Game_State);
	}
}

/**
 * Thing for Animation Debug.
 */
 class CharacterCreatorOption extends Option {
	// OPTIONS //

	public var Game_State:FlxState;

	public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Game_State:Dynamic) {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		toolbox.CharacterCreator.lastState = "OptionsMenu";
		this.Game_State = _Game_State;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
			FlxG.switchState(Game_State);
	}
}

#if sys
/**
 * Option for enabling and disabling mods.
 */
class ModOption extends FlxTypedGroup<FlxSprite> {
	// variables //
	public var Alphabet_Text:Alphabet;
	public var Mod_Icon:ModIcon;

	public var Mod_Enabled:Bool = false;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "Template Mod";

	public function new(_Option_Name:String = "", _Option_Value:String = "Template Mod", _Option_Row:Int = 0) {
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);

		Mod_Icon = new ModIcon(Option_Value);
		Mod_Icon.sprTracker = Alphabet_Text;
		add(Mod_Icon);

		Mod_Enabled = ModList.modList.get(Option_Value);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0) {
			Mod_Enabled = !Mod_Enabled;
			ModList.setModEnabled(Option_Value, Mod_Enabled);
		}

		if (Mod_Enabled) {
			Alphabet_Text.alpha = 1;
			Mod_Icon.alpha = 1;
		} else {
			Alphabet_Text.alpha = 0.6;
			Mod_Icon.alpha = 0.6;
		}
	}
}

class ChangeModOption extends FlxTypedGroup<FlxSprite> {
	// variables //
	public var Alphabet_Text:Alphabet;
	public var Mod_Icon:ModIcon;

	public var Mod_Enabled:Bool = false;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "Template Mod";

	public function new(_Option_Name:String = "", _Option_Value:String = "Friday Night Funkin'", _Option_Row:Int = 0) {
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		Alphabet_Text.scrollFactor.set();
		add(Alphabet_Text);

		Mod_Icon = new ModIcon(Option_Value);
		Mod_Icon.sprTracker = Alphabet_Text;
		Mod_Icon.scrollFactor.set();
		add(Mod_Icon);

		Mod_Enabled = ModList.modList.get(Option_Value);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(Alphabet_Text.targetY == 0){
			Alphabet_Text.alpha = 1;
			Mod_Icon.alpha = 1;
			if (FlxG.keys.justPressed.ENTER) {
				Mod_Enabled = !Mod_Enabled;
				@:privateAccess
				if (Std.isOfType(FlxG.state, TitleState)) TitleState.initialized = false;
				if (FlxG.sound.music != null) {
					FlxG.sound.music.fadeOut(0.25, 0);
					FlxG.sound.music.persist = false;
				}
				FlxG.sound.play(Paths.sound('confirmMenu'), 1);
				Options.setData(Option_Value, "curMod");
				FlxG.resetState();
				lime.utils.Assets.cache.clear();
            	openfl.utils.Assets.cache.clear();
				#if windows
				//utilities.Windows.setWindowIcon("mods/"+Options.getData("curMod")+"/_polymod_icon.png");
				#end
			}
		}else {
			Alphabet_Text.alpha = 0.6;
			Mod_Icon.alpha = 0.6;
		}
	}


}
#end

/**
 * A Option for save data that is saved a string with multiple pre-defined states (aka like accuracy option or cutscene option)
 */
class StringSaveOption extends Option {
	// VARIABLES //
	var Current_Mode:String = "option 2";
	var Modes:Array<String> = ["option 1", "option 2", "option 3"];
	var Cool_Name:String;
	var Save_Data_Name:String;

	override public function new(_Option_Name:String = "String Switcher", _Modes:Array<String>, _Option_Row:Int = 0, _Save_Data_Name:String = "hitsound") {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		this.Modes = _Modes;
		this.Save_Data_Name = _Save_Data_Name;
		this.Current_Mode = Options.getData(Save_Data_Name);
		this.Cool_Name = _Option_Name;
		this.Option_Name = Cool_Name + " " + Current_Mode;

		// CREATING OTHER OBJECTS //
		remove(Alphabet_Text);
		Alphabet_Text.kill();
		Alphabet_Text.destroy();

		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && Std.int(Alphabet_Text.targetY) == 0 && !OptionsMenu.inMenu) {
			var prevIndex = Modes.indexOf(Current_Mode);

			if (prevIndex != -1) {
				if (prevIndex + 1 > Modes.length - 1)
					prevIndex = 0;
				else
					prevIndex++;
			} else
				prevIndex = 0;

			Current_Mode = Modes[prevIndex];

			this.Option_Name = Cool_Name + " " + Current_Mode;

			remove(Alphabet_Text);
			Alphabet_Text.kill();
			Alphabet_Text.destroy();

			Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
			Alphabet_Text.isMenuItem = true;
			Alphabet_Text.targetY = Option_Row;
			add(Alphabet_Text);

			SetDataIGuess();
		}
	}

	function SetDataIGuess() {
		Options.setData(Current_Mode, Save_Data_Name);
	}
}

class DisplayFontOption extends StringSaveOption {
	override function SetDataIGuess() {
		super.SetDataIGuess();
		Main.changeFont(Options.getData("infoDisplayFont"));
	}
}

/**
 * Very simple option that renders a webpage when selected
 */
 class WebViewOption extends Option {
	// OPTIONS //
	public var Title:String;
	public var Url:String;

	public function new(_Option_Name:String = "", _Option_Row:Int = 0, Title:String, Url:String) {
		super(_Option_Name, null, _Option_Row);

		// SETTING VALUES //
		this.Url = Url;
		this.Title = Title;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		
		#if windows
		if (FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
			sys.thread.Thread.createWithEventLoop(() ->
		{
            var w:webview.WebView = new webview.WebView(#if debug true #else false #end);

			w.setTitle(Title);
			w.setSize(FlxG.width, FlxG.height, NONE);
			w.navigate(Url);

			Application.current.onExit.add((_) ->
			{
				w.terminate();
				w.destroy();
			});
			w.run();
		});   
		#end 
	}
}