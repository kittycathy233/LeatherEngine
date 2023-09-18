package;


import flixel.util.FlxColor;
import utilities.logs.Log;
import flixel.system.debug.log.LogStyle;
import openfl.display.Sprite;
import openfl.text.TextFormat;
import utilities.CoolUtil;
import ui.SimpleInfoDisplay;
import flixel.FlxGame;

class Main extends Sprite {

	public static var instance:Main = null;
	public static var logs:Log;
	
	public function new() {
		super();

		flixel.system.frontEnds.LogFrontEnd.onLogs = function(Data, Style, FireOnce) {
			if (Options.getData("developer")) {
				var prefix = "[FLIXEL]";
				var color:FlxColor = FlxColor.WHITE;
				if (Style == LogStyle.CONSOLE)  {prefix = "> ";					color = FlxColor.WHITE;	}
				if (Style == LogStyle.ERROR)    {prefix = "[FLIXEL ERROR]";		color = FlxColor.RED;	}
				if (Style == LogStyle.NORMAL)   {prefix = "[FLIXEL]";			color = FlxColor.WHITE;	}
				if (Style == LogStyle.NOTICE)   {prefix = "[FLIXEL NOTICE]";	color = FlxColor.GREEN;	}
				if (Style == LogStyle.WARNING)  {prefix = "[FLIXEL WARNING]";	color = FlxColor.YELLOW;	}

				var d:Dynamic = Data;
				if (!(d is Array))
					d = [d];
				var a:Array<Dynamic> = d;
				var strs = [for(e in a) Std.string(e)];
				for(e in strs) {
					(Style == LogStyle.ERROR ? CoolUtil.coolError : CoolUtil.haxe_trace)('$prefix $e', color);
				}
			}
		};

		CoolUtil.haxe_trace = haxe.Log.trace;
		haxe.Log.trace = CoolUtil.haxe_print;

		addChild(new FlxGame(0, 0, states.TitleState, 60, 60, true));

		#if SCREENSHOTS_ALLOWED
		flixel.FlxG.plugins.add(new screenshotplugin.ScreenShotPlugin());
		plugins.ScreenshotPluginConfig.setScreenshotConfig(PNG, F2);
		#end

		#if !mobile
		display = new SimpleInfoDisplay(8, 3, 0xFFFFFF, "_sans");
		addChild(display);
		#end

		logs = new Log();

		addChild(logs);


	}

	public static var display:SimpleInfoDisplay;

	public static function toggleFPS(fpsEnabled:Bool):Void
		display.infoDisplayed[0] = fpsEnabled;

	public static function toggleMem(memEnabled:Bool):Void
		display.infoDisplayed[1] = memEnabled;

	public static function toggleVers(versEnabled:Bool):Void
		display.infoDisplayed[2] = versEnabled;

	public static function toggleLog(logEnabled:Bool):Void
		display.infoDisplayed[3] = logEnabled;

	public static function changeFont(font:String):Void
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);
}
