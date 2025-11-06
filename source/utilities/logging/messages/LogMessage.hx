package utilities.logging.messages;

import openfl.text.TextField;
import openfl.display.Bitmap;
import flixel.util.FlxColor;
import openfl.display.Sprite;

class LogMessage extends Sprite {
    public var icon:Sprite;
    public var text:TextField;
    public var count:TextField;
    public var iconInnerSprite:Bitmap;

    public var curColor:Int;
    public var actualHeight:Float = 0;

    public var messageCount:Int = 1;
    public var message:String;

    public function new(x:Float, y:Float, text:String, color:FlxColor) {
        super();
    }
}