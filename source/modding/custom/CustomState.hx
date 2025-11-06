package modding.custom;

import openfl.utils.Assets;
import flixel.FlxG;
import modding.scripts.languages.HScript;
import states.MusicBeatState;
import flixel.FlxObject;
import states.TitleState;
import flixel.FlxObject;


class CustomState extends MusicBeatState {
    public var script:HScript;
    public static var instance:CustomState = null;
    override function new(script:String){
        if(Assets.exists(Paths.hx("classes/states/" + script))){
            instance = this;
            this.script = new HScript(Paths.hx("classes/states/" + script));
            this.script.start();
            this.script.interp.variables.set("add", function(obj:FlxObject)
            {
                add(obj);
            });
        }
        else{
            trace('Could not find script at path ${script}', ERROR);
            FlxG.switchState(new TitleState());
        }
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