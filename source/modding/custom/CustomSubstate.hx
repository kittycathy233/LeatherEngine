package modding.custom;

import openfl.utils.Assets;
import modding.scripts.languages.HScript;
import substates.MusicBeatSubstate;
import flixel.FlxObject;

class CustomSubstate extends MusicBeatSubstate {
    public var script:HScript;
    public static var instance:CustomSubstate = null;
    override function new(script:String){
        if(Assets.exists(Paths.hx("classes/substates/" + script))){
            instance = this;
            this.script = new HScript(Paths.hx("classes/substates/" + script));
            this.script.start();
            this.script.interp.variables.set("add", function(obj:FlxObject)
                {
                    add(obj);
                });
        }
        else
            trace('Could not find script at path ${script}', ERROR);
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
    override function beatHit(){
        allScriptCall("beatHit");
		super.beatHit();
		allScriptCall("beatHitPost");
    }
    override function stepHit(){
        allScriptCall("stepHit");
		super.stepHit();
		allScriptCall("stepHitPost");
    }
    private inline function allScriptCall(func:String, ?args:Array<Dynamic>) {
		script.call(func, args);
	}
}