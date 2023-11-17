package modding.custom;

import modding.scripts.languages.HScript;
import states.MusicBeatState;

class CustomState extends MusicBeatState {
    public var script:HScript;
    override function new(script:String){
        this.script = new HScript(Paths.hx("classes/states/" + script));
        super();
    }
    override function create(){
        allScriptCall("create");
        super.create();
        allScriptCall("createPost");
    }
    override function update(elapsed:Float){
        allScriptCall("update", [elapsed]);
		super.update(elapsed);
		allScriptCall("updatePost", [elapsed]);
    }
    private function allScriptCall(func:String, ?args:Array<Dynamic>) {
		script.call(func, args);
	}
}