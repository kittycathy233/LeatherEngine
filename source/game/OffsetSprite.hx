package game;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * `FlxSprite` with a map of `String` to `FlxPoint` that offsets the sprite when playing an animation
 */
class OffsetSprite extends FlxSprite {
	public var animationOffsets:Map<String, FlxPoint>;

	public function new(x:Float, y:Float) {
		super(x, y);
		animationOffsets = new Map<String, FlxPoint>();
	}

	/**
	 * Plays the animation with the proper set offsets
	 * Will adjust the offset depending on the sprite's angle to make sure it looks consistent.
	 * @param name The name of the animation.
	 * @param force Should the animation force to play.
	 * @param reversed Should the animation be reversed.
	 * @param frame What frame the animation should start on.
	 */
	public function playAnimation(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		animation.play(name, force, reversed, frame);

		var _offset:FlxPoint = FlxPoint.get(animationOffsets.get(name).x, animationOffsets.get(name).y);

		if (animationOffsets.exists(name)) {
			offset.set((_offset.x * _cosAngle) - (_offset.y * _sinAngle), (_offset.y * _cosAngle) + (_offset.x * _sinAngle));
		} else {
			offset.set(0, 0);
		}
	}

	/**
	 * Adds an offset.
	 * @param name The name of the animation.
	 * @param x The X position.
	 * @param y The Y position.
	 */
	public function addOffset(name:String, x:Float, y:Float) {
		animationOffsets.set(name, new FlxPoint(x, y));
	}

	override public function destroy(){
		super.destroy();
		for(point in animationOffsets){
			point.put();
		}
	}
}
