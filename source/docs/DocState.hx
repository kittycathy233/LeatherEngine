package docs;

import states.MusicBeatState;
import cocktail.api.Cocktail;
#if js
import js.Browser;
#end

class DocState extends MusicBeatState {
    override public function create(){
        #if !js
		cocktail.api.Cocktail.boot("https://github.com/Vortex2Oblivion/LeatherEngine-Extended-Support/blob/main/version.txt");
		#end
        #if js
        Browser.window.onload = function(e) {
			 
			//document is now loaded
			var document = Browser.document;
		};
        #end
        super.create();
    }
}