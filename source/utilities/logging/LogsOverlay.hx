package utilities.logging;

import openfl.text.TextFormat;
import flixel.util.FlxColor;
import utilities.logging.messages.LogMessage;
import openfl.text.TextField;
import openfl.display.Sprite;

class LogsOverlay extends Sprite{
    public static var open:Bool = false;
    public static var isVisible:Bool = false;

    public static var logs:TextField;
    public static var guide:TextField;

    public static var logsText:Sprite;
    public static var lastPos:Int = 0;
    public static var tracedShit:Int = 0;
    public static var errors:Int = 0;
    public static var lastErrors:Int = 0;
    public static var oldLogsText:String = "";
    public static var lastCommands:Array<String> = [];

	public static var messages:Array<LogMessage> = [];

    public static function log(value:Dynamic, color:FlxColor = FlxColor.WHITE){
        var val = "";
        if (Std.isOfType(value, String)){val = value;}else{val = Std.string(value);}

        if(logsText != null){
            if (messages.length > 0) {
                var msg = messages[messages.length - 1];
                if (msg != null && msg.message == val) {
                    msg.messageCount++;
                    return;
                }
            }
            var e = new LogMessage(0, 0, val, color);
            messages.push(e);
            logsText.addChild(e);
            while(messages.length > Options.getData("maxLogs"))
                logsText.removeChild(messages.shift());
            tracedShit++;
        }
    }

    public function new() {
        super();
        logsText = new Sprite();

        guide = new TextField();
        guide.autoSize = LEFT;
        guide.selectable = false;
        guide.textColor = 0xDDDDDD;
        guide.defaultTextFormat = new TextFormat("Pixel Arial 11 Bold", 12);
        guide.text = "F6 - CLOSE || F7 - CLEAR";

        addChild(logsText);
        addChild(guide);
    }
}