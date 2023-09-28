package docs;

import flixel.FlxG;
import flixel.FlxSprite;
import cocktail.api.Cocktail;
import states.MusicBeatState;
import flixel.util.FlxColor;

class DocState extends MusicBeatState {
    override function create() {
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        bg.screenCenter();
        add(bg);
        Cocktail.boot("https://raw.githubusercontent.com/Vortex2Oblivion/LeatherEngine-Extended-Support/main/docs/test/index.html");
        super.create();
    }
}