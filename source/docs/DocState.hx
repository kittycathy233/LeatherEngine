package docs;

#if windows
import states.LoadingState;
import states.MainMenuState;
import flixel.FlxG;
import lime.app.Application;
import states.MusicBeatState;
import flixel.util.FlxColor;
import webview.WebView;
import sys.thread.Thread;

class DocState extends MusicBeatState {
    override function create() {
        Thread.createWithEventLoop(() ->
		{
            var w:WebView = new WebView(#if debug true #else false #end);

			w.setTitle("Documentation");
			w.setSize(FlxG.width, FlxG.height, NONE);
			w.navigate("https://vortex2oblivion.github.io/Leather-Engine-Docs/");

			Application.current.onExit.add((_) ->
			{
				w.terminate();
				w.destroy();
			});
			w.run();
		});    
        super.create();
    }
}
#end