package modding.custom;

import modding.scripts.languages.HScript;
import states.MusicBeatState;

class CustomState extends MusicBeatState {
    public var script:HScript;
    public static var instance:CustomState = null;
    override function new(script:String){
        instance = this;
        this.script = new HScript(Paths.hx("classes/states/" + script));
        this.script.start();
        super();
    }
    override function create(){
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