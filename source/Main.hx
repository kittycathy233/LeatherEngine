package;

import haxe.Log;
import ui.logs.Logs;
import utilities.FunkinGame;
import flixel.FlxG;
import lime.app.Application;
import haxe.io.Path;
import haxe.CallStack;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.display.Sprite;
import openfl.text.TextFormat;
import utilities.CoolUtil;
import ui.SimpleInfoDisplay;
import flixel.system.debug.log.LogStyle;

class Main extends Sprite {

	public static var instance:Main = null;

	static var logsOverlay:Logs;
	
	public function new() {
		super();
		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		CoolUtil.haxe_trace = Log.trace;
		Log.trace = CoolUtil.haxe_print;
		/*untyped FlxG.log = new FunkinFrontEnd();

		LogFrontEnd.onLogs = function(Data, Style, FireOnce){
			if(Options.getData("developer")){
				if (Style == LogStyle.CONSOLE || Style == LogStyle.NORMAL) Logs.debug(Data);
				if (Style == LogStyle.ERROR) Logs.error(Data);
				if (Style == LogStyle.NOTICE) Logs.log(Data);
				if (Style == LogStyle.WARNING) Logs.warn(Data);
			}
		}*/


		addChild(new FunkinGame());

		#if !mobile
		logsOverlay = new Logs();
		logsOverlay.visible = false;
		addChild(logsOverlay);
	
		display = new SimpleInfoDisplay(8, 3, 0xFFFFFF, "_sans");
		addChild(display);
		#end

		// shader coords fix
		// stolen from psych engine lol
		FlxG.signals.gameResized.add(function (w, h) {
		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				if (cam != null && cam.filters != null)
					resetSpriteCache(cam.flashSprite);
			   }
			}

			if (FlxG.game != null)
			resetSpriteCache(FlxG.game);
		});


	}

	static function resetSpriteCache(sprite:Sprite):Void {
		@:privateAccess {
		        sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	public static var display:SimpleInfoDisplay;

	public static function toggleFPS(fpsEnabled:Bool):Void
		display.infoDisplayed[0] = fpsEnabled;

	public static function toggleMem(memEnabled:Bool):Void
		display.infoDisplayed[1] = memEnabled;

	public static function toggleVers(versEnabled:Bool):Void
		display.infoDisplayed[2] = versEnabled;

	public static function toggleLogs(logsEnabled:Bool):Void
		display.infoDisplayed[3] = logsEnabled;


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
/*
                                                                 .:^^.                                                       
                                                               .^~!777:                                                      
                                                              :~!!77?J~                                                      
                                                             ^!!!777?J~                                                      
                                                           .~!!!77???J!                                                      
                                                          .~7!!!77???J7                                                      
                                                          ~!!7777?????7                                                      
                                                         ^7777777????J?:                                                     
                                                        :!77777??????JJ:                                                     
                                                        ^7?77777???JJJJ^                                                     
                                                        ~7777??JYYJJ?JY7                                                     
                                                        ~!7??JJJ???7???7.                                      .:::.         
                                                      .^!!777777???7????7.                                   :~~!7?7         
                                                   .:^~!!!!!!7777?J?????J7.                .^:.             ^~!!!7??.        
                                            ...::^~~~~~~!!!!!!!!!7777???77!^.             ^7?J!           .~!!!!7??J:        
                                   ..:::^^~~~~~~~~!!!!!!!!!!777!777777777777!^.          ~7????          .~7!!777?J7         
                           ..::^^~~~~~~!!!!!!!!!!!!!!!!!!7777777777777?????777!~^:.    .~77777?^.        ~!!!777??J~         
                     .::^^~~~~!!!!!!!!!!!!!!!!!!!777!!!777777777777777?????????777!~~^^~!!!!!!!7!~:.    ^!!!!7777?J~         
                 .^~~~~~~~~~~~~!!!!!!!!!!7777777777777777777777777777???????????777?777!!!!!777!777!!~~~!!!!!777??J!         
              .^~~!!!!!!!!!!!!!7777777777777777777777?777????77?77????????????????77?????777777777???77??7!!777????7         
           .:^~~~~~~!!!!!!!!!7777777777777777777???????????????????????????????????????????????????J????????7?????JJ:        
        .:^~~!7!!!!!!!!!!!7777777???????????????????????????????????????????????JJJ????JJJJ?????JJ?JJ???JJJJ???JJJJJ~        
       :~~!!!!!!!!7777777777777?????J???J???????????????????J?????????????????????JJJ??JJJJJ?????JJ??J???JJJJJJ?JJJJ!        
     .^!~77?777!77777777777????????JJJJJJJJJ?J????????????????JJJJ????????????JJJJJJJJ?JJJJJJJJJ?JJJ?JJJ?JJJJJ?JYJJJ?.       
    .~~!???????????????J????JJ??JJJJJJYJJJJJJJJJ?JJJJ??J??JJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J?JJJJJJJYYJJJJ7       
   .~~7YYYJJJ?JJJJ??JJJJ?J?JJJ?JJJJJJYYYYYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?????!7JY5555YYJJJ!      
   :~7YYYYYYYYYYJJJYJJYJJJJYJJJYYYYYYYYYYYYYYYJYYJYYYJJJJJJJJYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?7~~:.   ~?5PP55YYJJJ7     
  .~!?5YYYY5YYYYJYYYYYYYYYYYJYYY55YY5YYYYYYYYYYYYYYYYYYYJJJJJYJY5JJYJJJYYJJJJJJJJJJJJJJJJJJJJJJJ?!:         .!YP5555YJJJ7:   
  .~!?55YYYYYYYYYYYY5YYYYY5YYY555555YYYYYYYY5YYYYYYYYYYYYJJJJYJYYJY5JYYYYJJJJJJJJYYYJJJJJJJJJJ7~.             :7Y555YYJJJ7   
   .!7JP5555555YYY555YYYY5555555555YYYYYYYYYY55P5YYYYYYYJJJJYYJYYJ5YJY55YY5YJJJ???????JJJJJJ7^.                 :7Y55YYJJJ.  
    .!?J5PPPP55555P555555555555555555YYYYYY5B#GG#PYJJYYYJJJJYJYYJY5YJ55555YJJJJ??????7~^^^^:                      .^?YYYY7.  
     .^7?YY5PP555PPP5555555555555555555YYYY5GBGGPYYYYYYYYJJYYY5YJ5YY5555YYJJJJJJJJJJ??!~:                             .::    
       .:~7?JY55YYYYYYYYYYYYY5YJJJJJJJJ???777777!!!!!!!!!!~~!!!!!!!~!55YYYJYYJJJJJJJJJ??7!:                                  
          ..:^^^^^^^^^^^^^^^^^^^::::^:::::::::::::::::::::::::::::::^J55YYYYYYYJJJJJJJJJJJ?!^.                               
             ...:::::::::::::::::::^:::::::::::::^::^:::::::::::::::^!JY5YYYYYYJJYYJJJYYJJJ??7^                              
                 ..::.:::::^::^^^^^^^^^^^^^^^^^^^^^^:::::::::::::::^^^!?JYYYYYYJJYYYYYJJJJJJJJJ7^.                           
                      ....:^^^^^^^^^^~^^^^^^^::::::::::::::::::::::^^^~~!!7?YYYYY5YYYJJJJYYYJJJJJ?~.                         
                          ..::^^:^^:^^:::::::::::::::::::::::::::^^^^^^^:.. :~7J5YYYYJJJJYJJJYYYYJJ?7^.                      
                                  ......:::::::::::::::::::::^^^::::..         .^7JYYYYYYYYYYYJJJJJJJJ?7~.                   
                                                ...............                   .~7JYYY55YYYYYJYYYJJYYJJ7^.                
                                                                                     .:~7JYY5555YYYYYYYYJJYJ?:               
                                                                                         .::^~!?JYY555YYYJJ7!.               
                                                                                                ..:^~^^^~^.                 
*/