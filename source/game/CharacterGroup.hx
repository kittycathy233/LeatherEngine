package game;

import flixel.group.FlxSpriteGroup;
import haxe.Json;
import flixel.util.FlxColor;
import modding.CharacterConfig;
import openfl.utils.Assets;
import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;


using StringTools;

/**
 * `FlxTypedSpriteGroup` of `OffsetSprite` that make up a character
 */
class CharacterGroup extends FlxTypedSpriteGroup<Character>{

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
     * Should this be used when the player dies?
     */
    public var isDeathCharacter:Bool = false;

    /**
     * The raw character config.
     */
    public var config:CharacterConfig;


    /**
     * The index of the main character
     */
    public var mainCharacterID:Int;

    /**
     * The color of the health bar.
     */
    public var barColor:FlxColor = FlxColor.GRAY;

    /**
     * The name of the health icon
     */
    public var icon:String;

    /**
     * The position of the camera offset 
     */
    public var cameraOffset:FlxPoint;

    
	/**
	 * Prevents the character group from dancing when false.
	 */
	public var shouldDance:Bool = true;

    /**
     * Creares a new character.
     * @param x The X position of the character.
     * @param y The Y position of the character.
     * @param character The name of the character.
     * @param player Is the character on the player side?
     * @param isDeathCharacter Should this character be used when the player dies?
     */
    override public function new(x:Float, y:Float, character:String = 'bf', player:Bool = false, isDeathCharacter:Bool = false){
        super(x, y);
        this.character = character;
        this.player = player;
        this.isDeathCharacter = isDeathCharacter;

        // Do nothing if the character is empty
        if(character == ''){
            deathCharacter = 'bf-dead';
            return;
        }

        setupCharacter(character);

		icon = config.healthIcon ?? character;
        barColor = (config.barColor != null) ? FlxColor.fromRGB(config.barColor[0], config.barColor[1], config.barColor[2]) : FlxColor.GRAY;

        if (config.characters == null){
            var character:Character;
			if (!player)
				character = new Character(x, y, this.character, player, isDeathCharacter);
			else
				character = new Boyfriend(x, y, this.character, isDeathCharacter);
            character.x = character.positioningOffset.x ?? 0;
            character.y = character.positioningOffset.y ?? 0;  
            if(character.trail != null) {
                FlxG.state.add(character.trail);
                character.trail.x = x + character.x;
                character.trail.y = y + character.y;
            }
            add(character);
        }
        else{
            mainCharacterID = config.mainCharacterID ?? 0;

            for (char in config.characters){
                var character:Character;
                if (!player)
                    character = new Character(x, y, char.name, player, isDeathCharacter);
                else
                    character = new Boyfriend(x, y, char.name, isDeathCharacter);
                if(flipX)
                    character.x = -character.positioningOffset.x;
                else{
                    character.x = character.positioningOffset.x;
                }
                if(flipY)
                    character.y = -character.positioningOffset.y;
                else{
                    character.y = character.positioningOffset.y;
                }
                if(character.trail != null) {
                    FlxG.state.add(character.trail);
                    character.trail.x = x + character.x;
                    character.trail.y = y + character.y;
                }
                add(character);
            }
        }

        if (config.cameraOffset != null) {
			if (flipX)
				config.cameraOffset[0] = 0 - config.cameraOffset[0];
            cameraOffset = new FlxPoint(config.cameraOffset[0], config.cameraOffset[1]);
		}
        else
            cameraOffset = new FlxPoint(0, 0);
    }

    /**
     * Sets up scripts and character JSON files.
     * @param character The name of the character.
     */
    public function setupCharacter(character:String){
        var characterPath:String = 'character data/$character/config';
        if(!Assets.exists(Paths.json('character data/$character/config'))){
            return;
        }
        config = cast Json.parse(Assets.getText(Paths.json(characterPath)).trim());
    }

    override public function destroy(){
        super.destroy();
        cameraOffset.put();
    }


    public var followMainCharacter:Bool = false;

    public function getMainCharacter():Character{
        if (members.length > 0)
        {
            if (followMainCharacter)
                return members[mainCharacterID];
        }
        return members[0];
     }

    public function dance(altAnim:String = '', force:Bool = false){
        if(!shouldDance) return;
         getMainCharacter().dance(altAnim, force);
    }

    public function playAnimation(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0){
        getMainCharacter().playAnimation(name, force, reversed, frame);
    }
}