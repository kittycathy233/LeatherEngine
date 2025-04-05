import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxAngle;
import openfl.display.BitmapData;

var game:PlayState = PlayState.instance;

class DropShadowShader {
	var shader:CustomShader;

	var attachedSprite:FlxSprite;

    var altMaskImage:BitmapData;

	function new() {
		shader = new CustomShader(Assets.getText(Paths.frag("dropShadow")));
		shader.setFloat("ang", 0);
		shader.setFloat("str", 1);
		shader.setFloat("dist", 15);
		shader.setFloat("thr", 0.1);
		shader.setFloat("hue", 0);
		shader.setFloat("saturation", 0);
		shader.setFloat("brightness", 0);
		shader.setFloat("contrast", 0);
		shader.setFloat("AA_STAGES", 2);
		shader.setBool("useMask", false);
		shader.setFloat("angOffset", 0);
	}

	function setAdjustColor(b:Float, h:Float, c:Float, s:Float) {
		shader.setFloat("brightness", b);
		shader.setFloat("hue", h);
		shader.setFloat("contrast", s);
		shader.setFloat("saturation", s);
	}

	function setColor(color:Int) {
		shader.setFloatArray("dropColor", [
			FlxColor.getRedFloat(color),
			FlxColor.getGreenFloat(color),
			FlxColor.getBlueFloat(color)
		]);
	}

	function setAttachedSprite(spr:FlxSprite) {
		attachedSprite = spr;
		updateFrameInfo(attachedSprite.frame);
	}

	function updateFrameInfo(frame:FlxFrame) {
		// NOTE: uv.width is actually the right pos and uv.height is the bottom pos
		shader.setFloatArray("uFrameBounds", [frame.uv.x, frame.uv.y, frame.uv.width, frame.uv.height]);

		// if a frame is rotated the shader will look completely wrong lol
		shader.setFloat("angOffset", frame.angle * FlxAngle.TO_RAD);
	}

	public function loadAltMask(path:String) {
        shader.setSampler2D("altMask", BitmapData.fromFile(path));
	}
}

function createPost() {
	applyLighting();
}

function beatHit():Void {
	if (FlxG.random.bool(2)) {
		game.stage.getNamedProp('sniper').animation.play('sip', true, true);
	}
}

function getCharacters(character:Character):Array<Character> {
	if (character.otherCharacters != null && character.otherCharacters.length > 0) {
		character.otherCharacters;
	}
	return [character];
}

function applyLighting() {
	if (!Options.getData("shaders")) {
		return;
	}

	for (character in getCharacters(bf)) {
		var rim:DropShadowShader = new DropShadowShader();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.setColor(0xFFDFEF3C);
		character.shader = rim.shader;
		rim.setAttachedSprite(character);
		rim.shader.setFloat("ang", 90 * FlxAngle.TO_RAD);
		character.animation.onFrameChange.add(() -> {
			rim.updateFrameInfo(character.frame);
		});
	}

	for (character in getCharacters(gf)) {
		var rim:DropShadowShader = new DropShadowShader();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.setColor(0xFFDFEF3C);
		character.shader = rim.shader;
		rim.setAttachedSprite(character);
		rim.shader.setFloat("ang", 90 * FlxAngle.TO_RAD);
		character.animation.onFrameChange.add(() -> {
			rim.updateFrameInfo(character.frame);
		});

		/*if (character.curCharacter == 'gf-tankmen') {
			rim.loadAltMask(PolymodAssets.getPath('assets/shared/images/characters/masks/gfTankmen_mask.png'));
			rim.shader.setFloat("thr2", 0.4);
			rim.shader.setBool("useMask", true);
		}*/
	}

	for (character in getCharacters(dad)) {
		var rim:DropShadowShader = new DropShadowShader();
		rim.setAdjustColor(-46, -38, -25, -20);
		rim.setColor(0xFFDFEF3C);
		character.shader = rim.shader;
		rim.setAttachedSprite(character);
		rim.shader.setFloat("ang", 135 * FlxAngle.TO_RAD);
		rim.shader.setFloat("thr", 0.3);
		character.animation.onFrameChange.add(() -> {
			rim.updateFrameInfo(character.frame);
		});
	}
}
