package docs;

import states.LoadingState;
import states.MainMenuState;
import flixel.FlxG;
import flixel.FlxSprite;
import states.MusicBeatState;
import flixel.util.FlxColor;
import webview.WebView;

class DocState extends MusicBeatState {
    var w:WebView = new WebView(); 
    override function create() {
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        bg.screenCenter();
        add(bg);
        w.setSize(FlxG.width, FlxG.height, NONE);
        w.setTitle("Youtube");
        w.navigate("https://www.youtube.com/");
        w.run();
        super.create();
    }
    override function update(elapsed:Float){
        if (FlxG.keys.justPressed.ESCAPE){
            LoadingState.loadAndSwitchState(new MainMenuState());
        }
        super.update(elapsed);
    }
}