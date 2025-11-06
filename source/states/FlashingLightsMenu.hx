package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class FlashingLightsMenu extends MusicBeatState {
	var text:FlxText;

	override public function create() {
		super.create();

		text = new FlxText(0, 0, 0, "Hey! Leather Engine has flashing lights\nPress Y to enable them, or anything else to not.\n(Any key closes this menu)",
			32);
		text.font = Paths.font("vcr.ttf");
		text.screenCenter();
		text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5, 1);
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.Y)
			Options.setData(true, "flashingLights");
		else if (!FlxG.keys.justPressed.Y && FlxG.keys.justPressed.ANY)
			Options.setData(false, "flashingLights");

		if (FlxG.keys.justPressed.ANY) {
			FlxG.sound.play(Paths.sound("confirmMenu"));

			FlxTween.tween(text, {alpha: 0}, 2.5, {
				ease: FlxEase.cubeInOut,
				onComplete: (_) -> FlxG.switchState(new TitleState())
			});
		}
	}
}
