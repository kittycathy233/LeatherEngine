package utilities.logs;

import hscript.Parser;
import openfl.ui.Keyboard;
import flixel.FlxG;
import openfl.events.KeyboardEvent;
import lime.utils.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import hscript.Interp;
import openfl.display.Sprite;

using StringTools;


class Log extends Sprite{

    public static var logsText:Sprite;
    public static var titleText:TextField;
    public static var legend:TextField;
    public static var command:TextField;
    public static var dummyText:TextField;
    public static var commandLabel:TextField;
    public static var hscript:Interp;
    public var wheel:Float = 0;

    public function new() {
        super();
        x = 0;
        y = 0;

        hscript = new Interp();
        /*hscript.errorHandler = function(e) {
            CoolUtil.coolError(e);
        };*/
        hscript.variables.set("trace", CoolUtil.haxe_print);

        titleText = new TextField();
        titleText.autoSize = LEFT;
        titleText.selectable = false;
        titleText.textColor = 0xFFFFFFFF;
        titleText.defaultTextFormat = new TextFormat("Pixel Arial 11 Bold", 16);
        titleText.text = 'Leather Engine ${Assets.getText("version.txt")}';

        logsText = new Sprite();

        legend = new TextField();
        legend.autoSize = LEFT;
        legend.selectable = false;
        legend.textColor = 0xDDDDDD;
        legend.defaultTextFormat = new TextFormat("Pixel Arial 11 Bold", 12);
        #if windows
            legend.text = "[F6] Close";
        #else
            legend.text = "[F6] Close";
        #end

        command = new TextField();
        command.selectable = true;
        command.type = INPUT;
        command.text = "";
        command.textColor = 0xFFFFFFFF;
        command.defaultTextFormat = new TextFormat("Pixel Arial 11 Bold", 12);
        command.height = 22;

        commandLabel = new TextField();
        commandLabel.selectable = true;
        commandLabel.text = "Enter command here:";
        commandLabel.textColor = 0xDDDDDD;
        commandLabel.defaultTextFormat = new TextFormat("Pixel Arial 11 Bold", 6);
        commandLabel.height = 11;

        dummyText = new TextField();
        dummyText.selectable = true;
        dummyText.text = "";
        dummyText.width = 2;
        dummyText.x = -5000;

        
        // command.ed
        addChild(titleText);
        addChild(logsText);
        addChild(legend);
        addChild(commandLabel);
        addChild(command);
        addChild(dummyText);

        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
        {
            if (Options.getData("developer")) {
                if (e.keyCode == Keyboard.F6) {
                    switchState();
                }
                if (visible) {
                    if (FlxG.stage.focus == command) {
                        if (e.keyCode == Keyboard.ENTER && command.text.trim() != "") { // COMMAND!
                            var e = new Parser();
                            e.allowJSON = true;
                            e.allowMetadata = true;
                            e.allowTypes = true;
                            try {
                                var expr = e.parseString(command.text);
                                @:privateAccess
                                CoolUtil.haxe_trace(hscript.exprReturn(expr));
                            } catch(e) {
                                CoolUtil.coolError(Std.string(e));
                            }
                            CoolUtil.lastCommands.push(command.text);
                            while(CoolUtil.lastCommands.length > 10) {
                                CoolUtil.lastCommands.pop();
                            }
                            command.text = "";
                        }
                    }
                }
                
            }
            
        });
        // cant import mouseEvent cause hxcpp is going to fuck itself
        FlxG.stage.addEventListener("mouseWheel", function(event:Dynamic) {
            wheel = event.delta;
        });
        visible = true;
        switchState();
    }
    function switchState() {
        FlxG.mouse.useSystemCursor = (visible = !visible);
        FlxG.mouse.enabled = !FlxG.mouse.useSystemCursor;
        FlxG.keys.enabled = true;
    }
}