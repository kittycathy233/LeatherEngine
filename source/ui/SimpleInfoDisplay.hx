package ui;

import ui.logs.Logs;
import openfl.utils.Assets;
import utilities.CoolUtil;
import flixel.FlxG;
import lime.app.Application;
import openfl.text.TextField;
import openfl.text.TextFormat;
import external.memory.Memory;

/**
 * Shows basic info about the game.
 */
class SimpleInfoDisplay extends TextField {
	//                                       fps    mem  version
	public var infoDisplayed:Array<Bool> = [false, false, false, false];

	public var currentFPS:Int = 0;
    private var _calculatedFPS:Int = 0;

	public var currentTime:Float = 0.0;

	public function new(x:Float = 10.0, y:Float = 10.0, color:Int = 0x000000, ?font:String) {
		super();

		this.x = x;
		this.y = y;
		selectable = false;
		defaultTextFormat = new TextFormat(font != null ? font : Assets.getFont(Paths.font("vcr.ttf")).fontName, (font == "_sans" ? 12 : 14),
        color);

        FlxG.signals.postDraw.add(update);

		width = FlxG.width;
		height = FlxG.height;
	}

	private function update():Void {
		text = "";

        currentTime += FlxG.elapsed;

        if (currentTime >= 1) {
            currentFPS = _calculatedFPS;
            _calculatedFPS = 0;
            currentTime = 0;
        } else if (_calculatedFPS < FlxG.stage.frameRate) {
            _calculatedFPS++;
        }

		@:privateAccess
		if (visible) {
			for (i in 0...infoDisplayed.length) {
				if (infoDisplayed[i]) {
					switch (i) {
						case 0: // FPS
							text += '${currentFPS}fps';
						case 1: // Memory
							text += '${CoolUtil.formatBytes(Memory.getCurrentUsage())} / ${CoolUtil.formatBytes(Memory.getPeakUsage())}';
						case 2: // Version
							text += 'v${Application.current.meta.get('version')}';
						case 3: // Console
							text += '${Main.logsOverlay.logs.length} traced lines. F5 to view.';
					}

					text += "\n";
				}
			}
		}
	}
}
