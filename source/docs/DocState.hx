package docs;

import states.LoadingState;
import states.MainMenuState;
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
    override function update(elapsed:Float){
        if (FlxG.keys.justPressed.ESCAPE){
            LoadingState.loadAndSwitchState(new MainMenuState());
        }
        super.update(elapsed);
    }
}