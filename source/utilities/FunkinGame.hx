package utilities;

import ui.CustomSoundTray;
import states.TitleState;
import flixel.FlxGame;

class FunkinGame extends FlxGame{
    public function new (){
        super(0, 0, TitleState, 60, 60, true);
        _customSoundTray = CustomSoundTray;	
    }
}