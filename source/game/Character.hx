package game;

import openfl.utils.Assets;
import states.PlayState;
import flixel.FlxG;
import haxe.Json;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.effects.FlxTrail;
import modding.scripts.languages.HScript;
import flixel.math.FlxPoint;
import modding.CharacterConfig;
import flxanimate.FlxAnimate;

/**
 * The base character class.
 */
class Character extends OffsetSprite {
	/**
	 * The name of the character.
	 */
	public var character:String = 'bf';

	/**
	 * Is the character on the player side?
	 */
	public var player:Bool;

    /**
     * The name of the character used when this character dies.
     */
     public var deathCharacter:String;

	/**
	 * Is the character a death character?
	 */
	public var isDeathCharacter:Bool = false;

	/**
	 * The raw character config.
	 */
	public var config:CharacterConfig;

    /**
     * Should the offsets flip when playing as this character?
     */
    public var offsetsFlipWhenPlayer:Bool = true;

	/**
	 * Should the offsets flip when not playing as this character?
	 */
	public var offsetsFlipWhenEnemy:Bool = false;

    /**
     * Does this character dance to the beat?
     * (Ex: Gf, Spooky Kids)
     */
    public var dancesLeftAndRight:Bool = false;

    /**
     * Should this character use the texture atlas?
     */
    public var atlasMode(default, null):Bool = false;

	/**
	 * The texture atlas that gets drawn using atlas mode. 
     * Only mess with if you know what you're doing!
	 */
	public var atlas:FlxAnimate;

    /**
     * `FlxTrail` used to give characters after-image like effects
     * Used on characters like spirit.
     */
    public var trail:FlxTrail;

    /**
     * Used in the character editor.
     */
    public var debug:Bool = false;

	/**
	 * Should the left and right singing animations be swapped when playing as the character?
	 */
    public var swapLeftAndRightSingPlayer:Bool = true;

    /**
     * The `HScript` of the current character.
     */
    public var script:HScript;

    /**
     * Should the full animation play
     */
    public var playFullAnim:Bool = false;

	/**
	 * Should the character not idle during the animation.
	 */
	public var preventDanceForAnim:Bool = false;


	/**
	 * Global position offset
	 */
	public var positioningOffset:FlxPoint;

	/**
	 * The prefix for singing animations
	 */
	public var singAnimPrefix:String = 'sing';

	/**
	 * Should the character dance?
	 */
	public var shouldDance:Bool = true;

	/**
	 * How long the character singing animations should last
	 */
	public var singDuration:Float = 4;


	/**
	 * Creares a new character.
	 * @param x The X position of the character.
	 * @param y The Y position of the character.
	 * @param character The name of the character.
	 * @param player Is the character on the player side?
	 * @param deathCharacter Should this character be used when the player dies?
	 */
	override public function new(x:Float, y:Float, character:String = 'bf', player:Bool = false, isDeathCharacter:Bool = false) {
		super(x, y);
		this.character = character;
		this.player = player;
		this.isDeathCharacter = isDeathCharacter;

		// Do nothing if the character is empty
		if (character == '') {
			deathCharacter = "bf-dead";
			return;
		}
        setupCharacter(character);
		if (player)
			flipX = !flipX;

        if (Assets.exists(Paths.hx('data/character data/$character/script'))) {
			script.call("createCharacterPost", [character]);
		}
	}

    override public function playAnimation(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
		if (playFullAnim)
			return;
		if (!hasAnim(name))
			return;
		
		if (singAnimPrefix != 'sing' && name.contains('sing')){
			var anim:String = name;
			anim = anim.replace('sing', singAnimPrefix);
			if (animation.getByName(anim) != null) //check if it exists so no broken anims
				name = anim;
		}

		preventDanceForAnim = false; //reset it

		if (atlasMode && atlas != null) {
			atlas.anim.play(name, force, reversed, frame);
		} else {
			animation.play(name, force, reversed, frame);
		}

		lastAnim = name;

		if (name.contains('dodge'))
			preventDanceForAnim = true;

		var _offset:FlxPoint = FlxPoint.get(animationOffsets.get(name).x, animationOffsets.get(name).y);

		if (animationOffsets.exists(name)) {
			offset.set((_offset.x * _cosAngle) - (_offset.y * _sinAngle), (_offset.y * _cosAngle) + (_offset.x * _sinAngle));
		} else {
			offset.set(0, 0);
		}
	}

	public var lastAnim:String = '';

	/**
	 * Sets up scripts and character JSON files.
	 * @param character The name of the character.
	 */
	public function setupCharacter(character:String) {
		var characterPath:String = 'character data/$character/config';
		if (!Assets.exists(Paths.json('character data/$character/config'))) {
			this.character = 'bf';
            character = 'bf';
		}
        if(Assets.exists(Paths.hx('data/character data/$character/script'))){
			script = new HScript(Paths.hx('data/character data/$character/script'));
			script.interp.variables.set("character", this);
			PlayState.instance.scripts.push(script);
			script.call("createCharacter", [character]);
		}
		config = cast Json.parse(Assets.getText(Paths.json(characterPath)).trim());
		flipX = player ? !config.defaultFlipX : config.defaultFlipX;

        if (Options.getData("dinnerbone")){
            flipY = !config.defaultFlipY;
        }

        if (config.offsetsFlipWhenPlayer == null)
            offsetsFlipWhenPlayer = !character.contains("bf");
        else
            offsetsFlipWhenPlayer = config.offsetsFlipWhenPlayer;

        if (config.offsetsFlipWhenEnemy == null) 
            offsetsFlipWhenEnemy = character.contains("bf");
        else
            offsetsFlipWhenEnemy = config.offsetsFlipWhenEnemy;

        dancesLeftAndRight = config.dancesLeftAndRight;

        if (Assets.exists(Paths.file('images/characters/${config.imagePath}/Animation.json', TEXT))){
            atlasMode = true;
            atlas = new FlxAnimate(0.0, 0.0, Paths.getTextureAtlas('characters/${config.imagePath}', "shared"));
            atlas.showPivot = false;
        }
        else{
            frames = getAtlas(config.imagePath);
        }

        if(config.extraSheets != null){
            for (sheet in config.extraSheets){
                cast(frames, FlxAtlasFrames).addAtlas(getAtlas(sheet)); //multiatlas support.
            }
        }

        var size:Null<Float> = config.graphicsSize ?? config.graphicSize;

        antialiasing = Options.getData("antialiasing") ? ((config.antialiased ?? config.antialiasing) ?? true) : false;

		if (size != null)
			scale.set(size, size);

        if (!atlasMode) {
            for (selected_animation in config.animations) {
                if (selected_animation.indices != null && selected_animation.indices.length > 0) {
                    animation.addByIndices(selected_animation.name, selected_animation.animation_name, selected_animation.indices, "", selected_animation.fps, selected_animation.looped);
                } else {
                    animation.addByPrefix(selected_animation.name, selected_animation.animation_name, selected_animation.fps, selected_animation.looped);
                }
            }
        } else {
            for (selected_animation in config.animations) {
                if (selected_animation.indices != null && selected_animation.indices.length > 0) {
                    atlas.anim.addBySymbolIndices(selected_animation.name, selected_animation.animation_name, selected_animation.indices, selected_animation.fps, selected_animation.looped);
                } else {
                    atlas.anim.addBySymbol(selected_animation.name, selected_animation.animation_name, selected_animation.fps, selected_animation.looped);
                }
            }
        }

		loadOffsetFile(character);

        if (isDeathCharacter)
            playAnimation("firstDeath");
        else if (dancesLeftAndRight)
            playAnimation("danceRight");
        else
            playAnimation("idle");

        if (debug)
            flipX = config.defaultFlipX;

        if(!atlasMode)
            updateHitbox();
        else
            atlas.updateHitbox();

        if (config.positionOffset != null)
            positioningOffset = new FlxPoint(config.positionOffset[0], config.positionOffset[1]);
		else{
			positioningOffset = new FlxPoint(0, 0);
		}

        if (config.trail == true)
            trail = new FlxTrail(this, null, config.trailLength, config.trailDelay, config.trailStalpha, config.trailDiff);

        if (config.swapDirectionSingWhenPlayer != null)
            swapLeftAndRightSingPlayer = config.swapDirectionSingWhenPlayer;
        else if (character.contains("bf"))
            swapLeftAndRightSingPlayer = false;

        if (config.singDuration != null)
            singDuration = config.singDuration;

	}
	
	override public function destroy(){
		super.destroy();
		positioningOffset.put();
	}

    public var holdTimer:Float = 0;

	var mostRecentAlt:String = "";

    override function update(elapsed:Float) {
		if (!debug && character != '' && hasAnims()) {
			if(curAnimFinished() && hasAnim(curAnimName() + '-loop'))
				{
					playAnimation(curAnimName() + '-loop');
				}
				else if (playFullAnim && curAnimFinished())
				{
					playFullAnim = false;
					dance('');
				}
				else if (preventDanceForAnim && curAnimFinished())
				{
					preventDanceForAnim = false;
					dance('');
				}
			if (!player) {
				if (curAnimName().startsWith('sing'))
					holdTimer += elapsed * (FlxG.state is PlayState ? PlayState.songMultiplier : 1);

				if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001) {
					dance(mostRecentAlt);
					holdTimer = 0;
				}
			}

			// fix for multi character stuff lmao
			if (hasAnims()) {
				if (curAnimName() == 'hairFall' && curAnimFinished())
					playAnimation('danceRight');
			}
		}
		
		if (atlasMode && atlas != null) {
			atlas.update(elapsed);
		}

		super.update(elapsed);

	}

    public function loadOffsetFile(character:String){

        if (!Assets.exists(Paths.txt('character data/$character/offsets'))) {
			return;
		}

		var offsets:Array<String> = CoolUtil.coolTextFile(Paths.txt('character data/$character/offsets'));

		for (x in 0...offsets.length) {
			var selectedOffset:String = offsets[x];
			var arrayOffset:Array<String>;
			arrayOffset = selectedOffset.split(" ");

			addOffset(arrayOffset[0], Std.parseInt(arrayOffset[1]), Std.parseInt(arrayOffset[2]));
		}
    }
    
    /**
     * Adds an offset
     * @param name 
     * @param x 
     * @param y 
     */
    override public function addOffset(name:String, x:Float, y:Float){
        super.addOffset(name, (player && offsetsFlipWhenPlayer) || (!player && offsetsFlipWhenEnemy) ? -x : x, flipY ? -y : y);
    }

    /**
     * Gets the proper spritesheet from all supported formats.
     * @param image 
     * @return The spritesheet as `FlxAtlasFrames` or `FlxAnimateFrames`
     */
    public function getAtlas(image:String):FlxAtlasFrames{
        var path:String = 'characters/$image';
		if (Assets.exists(Paths.file('images/$path.txt', TEXT))) {
			return Paths.getPackerAtlas(path);
		}
		else if (Assets.exists(Paths.file('images/$path.json', TEXT))){
			return Paths.getJsonAtlas(path);
		}
		else if (Assets.exists(Paths.file('images/$path.plist', TEXT))){
			return Paths.getCocos2DAtlas(path);
		} 
		else if (Assets.exists(Paths.file('images/$path.eas', TEXT))){
			return Paths.getEdgeAnimateAtlas(path);
		} 
		else if (Assets.exists(Paths.file('images/$path.js', TEXT))){
			return Paths.getEaselJSAtlas(path);
		} 
		return Paths.getSparrowAtlas(path);
	}

    override public function draw():Void {
		if (atlasMode && atlas != null && visible) {
			// thanks cne for this shits lol
			atlas.cameras = cameras;
			atlas.scrollFactor = scrollFactor;
			atlas.scale = scale;
			atlas.offset = offset;
			atlas.x = x;
			atlas.y = y;
			atlas.angle = angle;
			atlas.alpha = alpha;
			atlas.visible = visible;
			atlas.flipX = flipX;
			atlas.flipY = flipY;
			atlas.shader = shader;
			atlas.antialiasing = antialiasing;
			atlas.color = color;
			atlas.colorTransform = colorTransform;
			atlas.draw();
		} else {
			super.draw();
		}
	}

	private var danced:Bool = false;

    /**
     * For gf dancing
     * @param altAnim 
     * @param force 
     */
    public function dance(altAnim:String = '', force:Bool = false) {
		if (shouldDance) {
			if (!debug && character != '' && hasAnims() && (force || (!playFullAnim && !preventDanceForAnim))) {
				var alt:String = "";

				if ((!dancesLeftAndRight && hasAnim("idle" + altAnim))
					|| (dancesLeftAndRight
						&& hasAnim("danceLeft" + altAnim)
						&& hasAnim("danceRight" + altAnim)))
					alt = altAnim;

				mostRecentAlt = alt;

				var specialAnimation:Bool = !(curAnimName().startsWith('idle')
					|| curAnimName().startsWith('danceLeft')
					|| curAnimName().startsWith('danceRight')
					|| curAnimName().startsWith('sing'));

				if (!specialAnimation || curAnimFinished() || curAnimLooped()) {
					if (!dancesLeftAndRight)
						playAnimation('idle' + alt);
					else {
						danced = !danced;

						if (danced)
							playAnimation('danceRight' + alt);
						else
							playAnimation('danceLeft' + alt);
					}
				}
			}
		}
	}

    /**
     * Helper function for atlas mode
     * @param name 
     * @return If it exist
     */
    public inline function hasAnim(name:String):Bool {
		return (!atlasMode && animation.exists(name)) || (atlasMode && atlas.anim.existsByName(name));
	}

	/**
	 * Helper function for atlas mode
	 * @return Has animations
	 */
	public inline function hasAnims():Bool {
		return (!atlasMode && animation.curAnim != null) || (atlasMode && atlas != null && atlas.anim != null);
	}

    /**
     * Helper function for atlas mode
     * @return Is the current animation looped
     */
    public inline function curAnimLooped():Bool {
		@:privateAccess
		return (!atlasMode && animation.curAnim != null && animation.curAnim.looped) || 
				(atlasMode && atlas.anim.loopType == flxanimate.data.AnimationData.Loop.Loop);
	}

	/**
	 * Helper function for atlas mode
	 * @return is the current animation is finished.
	 */
	public inline function curAnimFinished():Bool {
		return (!atlasMode && animation.curAnim != null && animation.curAnim.finished) || 
				(atlasMode && atlas.anim.finished);
	}

    /**
     * Helper function for atlas mode
     * @return The current animation name as a string.
     */
    public function curAnimName():String {
		if (!atlasMode && animation.curAnim != null) {
			return animation.curAnim.name;
		}

		if (atlasMode) {
			return lastAnim;
		}

		return '';
	}


}
