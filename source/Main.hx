package;


import lime.app.Application;
import haxe.io.Path;
import haxe.CallStack;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.display.Sprite;
import openfl.text.TextFormat;
import utilities.CoolUtil;
import ui.SimpleInfoDisplay;
import flixel.FlxGame;

class Main extends Sprite {

	public static var instance:Main = null;
	
	public function new() {
		super();
		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

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


	}

	public static var display:SimpleInfoDisplay;

	public static function toggleFPS(fpsEnabled:Bool):Void
		display.infoDisplayed[0] = fpsEnabled;

	public static function toggleMem(memEnabled:Bool):Void
		display.infoDisplayed[1] = memEnabled;

	public static function toggleVers(versEnabled:Bool):Void
		display.infoDisplayed[2] = versEnabled;


	public static function changeFont(font:String):Void
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);

	#if sys
	/**
	 * Shoutout to @gedehari for making the crash logging code
	 * They make some cool stuff check them out!
	 * @see https://github.com/gedehari/IzzyEngine/blob/master/source/Main.hx
	 * @param e 
	 */
	function onCrash(e:UncaughtErrorEvent):Void {
		var error:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var date:String = Date.now().toString();

		date = StringTools.replace(date, " ", "_");
		date = StringTools.replace(date, ":", "'");

		for (stackItem in callStack){
			switch (stackItem){
				case FilePos(s, file, line, column):
					error += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}
		error += "\nUncaught Error: " + e.error;
		path = "./crash/" + "crash-" + e.error + '-on-' + date + ".txt";
		if (!sys.FileSystem.exists("./crash/"))
			sys.FileSystem.createDirectory("./crash/");

		sys.io.File.saveContent(path, error + "\n");

		Sys.println(error);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		var crashPath:String = "Crash" #if windows + ".exe" #end;


		if (sys.FileSystem.exists("./" + crashPath)){
				Sys.println("Found crash dialog: " + crashPath);
	
				#if linux
				crashPath = "./" + crashPath;
				#end
				new sys.io.Process(crashPath, [path]);
		}
		else{
			Sys.println("No crash dialog found! Making a simple alert instead...");
			Application.current.window.alert(error, "Error!");
		}
		Sys.exit(1);
	}
	#end
}
