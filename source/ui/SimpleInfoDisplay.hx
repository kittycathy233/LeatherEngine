package ui;

import openfl.events.Event;
import flixel.math.FlxMath;
import lime.system.System;
import macros.GithubCommitHash;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import openfl.utils.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import external.memory.Memory;
import macros.GithubCommitHash;
import haxe.macro.Compiler;

/**
 * Shows basic info about the game.
 */
class SimpleInfoDisplay extends TextField {
	//                                      fps    mem   version console info
	public var infoDisplayed:Array<Bool> = [false, false, false, false];

	public var framerate:Int = 0;

	private var framerateTimer:Float = 0.0;
	private var framesCounted:Int = 0;

	public var version:String = CoolUtil.getCurrentVersion();

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000, ?font:String) {
		super();

		this.x = x;
		this.y = y;
		selectable = false;
		defaultTextFormat = new TextFormat(font ?? Assets.getFont(Paths.font("vcr.ttf")).fontName, (font == "_sans" ? 12 : 14), color);

		width = FlxG.width;
		height = FlxG.height;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private var _framesPassed:Int = 0;
	private var _previousTime:Float = 0;
	private var _updateClock:Float = 999999;

	/**
	 * @see https://github.com/swordcube/friday-again-garfie-baby/blob/main/source/funkin/backend/StatsDisplay.hx#L46
	 */
	private function onEnterFrame(e:Event):Void {
		_framesPassed++;

		final deltaTime:Float = Math.max(System.getTimerPrecise() - _previousTime, 0);
		_updateClock += deltaTime;

		if (_updateClock >= 1000) {
			framerate = (FlxG.drawFramerate > 0) ? FlxMath.minInt(_framesPassed, FlxG.drawFramerate) : _framesPassed;

			_framesPassed = 0;
			_updateClock = 0;
		}
		_previousTime = System.getTimerPrecise();

		if (!visible) {
			return;
		}

		text = '';
		for (i in 0...infoDisplayed.length) {
			if (!infoDisplayed[i]) {
				continue;
			}

			switch (i) {
				case 0: // FPS
					text += '${framerate}fps\n';
				case 1: // Memory
					text += '${FlxStringUtil.formatBytes(Memory.getCurrentUsage())} / ${FlxStringUtil.formatBytes(Memory.getPeakUsage())}\n';
				case 2: // Version
					text += '$version\n';
				case 3: // Console
					text += Main.logsOverlay.logs.length > 0 ? '${Main.logsOverlay.logs.length} traced lines. F3 to view.\n' : '';
				case 4:
					text += 'Commit ${GithubCommitHash.getGitCommitHash().substring(0, 7)}';
			}
		}
	}
}
