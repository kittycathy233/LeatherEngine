package states;

import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.input.FlxInput.FlxInputState;
import flixel.FlxSprite;
import flixel.FlxBasic;
import lime.app.Application;
import game.Conductor;
import utilities.PlayerSettings;
import game.Conductor.BPMChangeEvent;
import utilities.Controls;
import flixel.FlxG;

class MusicBeatState extends #if MODCHARTING_TOOLS modcharting.ModchartMusicBeatState #else flixel.addons.ui.FlxUIState #end {
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	private var controls(get, never):Controls;

	public static var windowNameSuffix:String = "";
	public static var windowNamePrefix:String = "Leather Engine";

	public static var fullscreenBind:String = "F11";

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override public function new() {
		if (!Options.getData('memoryLeaks')) {
			clear_memory();
		}

		super();
	}

	/**
	 * Clears all assets and other objects from the game's memory.
	 */
	 public static function clear_memory():Void {
		// Remove cached assets (prevents memory leaks that i can prevent)
		lime.utils.Assets.cache.clear();
		openfl.utils.Assets.cache.clear();
		#if polymod
		polymod.Polymod.clearCache();
		#end


		// Remove lingering sounds from the sound list
		FlxG.sound.list.forEachAlive(function(sound:flixel.sound.FlxSound):Void {
			FlxG.sound.list.remove(sound, true);
			sound.stop();
			sound.destroy();
		});
		FlxG.sound.list.clear();

		FlxG.bitmap.clearCache();

		// Clear actual assets from OpenFL and Lime itself
		var cache:openfl.utils.AssetCache = cast openfl.utils.Assets.cache;
		var lime_cache:lime.utils.AssetCache = cast lime.utils.Assets.cache;

		// this totally isn't copied from polymod/backends/OpenFLBackend.hx trust me
		for (key in cache.bitmapData.keys())
			cache.bitmapData.remove(key);
		for (key in cache.font.keys())
			cache.font.remove(key);
		@:privateAccess
		for (key in cache.sound.keys()) {
			cache.sound.get(key).close();
			cache.sound.remove(key);
		}

		// this totally isn't copied from polymod/backends/LimeBackend.hx trust me
		for (key in lime_cache.image.keys())
			lime_cache.image.remove(key);
		for (key in lime_cache.font.keys())
			lime_cache.font.remove(key);
		for (key in lime_cache.audio.keys()) {
			lime_cache.audio.get(key).dispose();
			lime_cache.audio.remove(key);
		};

		#if cpp
		cpp.vm.Gc.enable(true);
		#end
		// Run built-in garbage collector
		#if sys
		openfl.system.System.gc();
		#end
	}

	override function update(elapsed:Float) {
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);

		if (FlxG.stage != null)
			FlxG.stage.frameRate = FlxMath.bound(Options.getData("maxFPS"), 0.1, 1000);

		if (!Options.getData("antialiasing")) {
			forEachAlive(function(basic:FlxBasic) {
				if (Std.isOfType(basic, FlxSprite))
					Reflect.setProperty(basic, "antialiasing", false);
			}, true);
		}

		if (FlxG.keys.checkStatus(FlxKey.fromString(Options.getData("fullscreenBind", "binds")), FlxInputState.JUST_PRESSED))
			FlxG.fullscreen = !FlxG.fullscreen;

		#if debug
		if (FlxG.keys.justPressed.F5)
			FlxG.resetState();
		#end

		FlxG.autoPause = Options.getData("autoPause");

		Application.current.window.title = windowNamePrefix + windowNameSuffix;
	}

	private function updateBeat():Void {
		curBeat = Math.floor(curStep / Conductor.timeScale[1]);
	}

	private function updateCurStep():Void {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		var dumb:TimeScaleChangeEvent = {
			stepTime: 0,
			songTime: 0,
			timeScale: [4, 4]
		};

		var lastTimeChange:TimeScaleChangeEvent = dumb;

		for (i in 0...Conductor.timeScaleChangeMap.length) {
			if (Conductor.songPosition >= Conductor.timeScaleChangeMap[i].songTime)
				lastTimeChange = Conductor.timeScaleChangeMap[i];
		}

		if (lastTimeChange != dumb)
			Conductor.timeScale = lastTimeChange.timeScale;

		var multi:Float = 1;

		if (FlxG.state == PlayState.instance)
			multi = PlayState.songMultiplier;

		Conductor.recalculateStuff(multi);

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);

		updateBeat();
	}

	public function stepHit():Void {
		if (curStep % Conductor.timeScale[0] == 0)
			beatHit();
	}

	public function beatHit():Void {/* do literally nothing dumbass */}
}
