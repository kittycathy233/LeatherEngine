package game;

import states.PlayState;
import flixel.FlxG;

using StringTools;


/**
 * The ``Boyfriend`` class
 * Has extra code for playing the death animation and such.
 */
class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf', ?isDeathCharacter:Bool = false)
	{
		super(x, y, char, true, isDeathCharacter);
		flipX = !flipX;
	}

	override function update(elapsed:Float)
	{
		if (!debug && animation.curAnim != null)
		{
			if (animation.curAnim.name.startsWith('sing'))
				holdTimer += elapsed * (FlxG.state is PlayState ? PlayState.songMultiplier : 1);
			else
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debug)
				dance();

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
				playAnimation('deathLoop');
		}

		super.update(elapsed);
	}
}
