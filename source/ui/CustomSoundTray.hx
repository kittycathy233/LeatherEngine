package ui;

import flixel.util.FlxColor;
import flixel.system.FlxAssets;
import openfl.text.TextFormatAlign;
import openfl.text.TextFormat;
import openfl.display.Bitmap;
import flixel.FlxG;
import openfl.text.GridFitType;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.display.BitmapData;
import flixel.system.ui.FlxSoundTray;

class CustomSoundTray extends FlxSoundTray{

    var percentText:TextField;

    public function new(){
        super();
		visible = false;
		scaleX = _defaultScale;
		scaleY = _defaultScale;
		var tmp:Bitmap = new Bitmap(new BitmapData(_width, 50, true, 0x7F000000));
		screenCenter();
		addChild(tmp);

		var text:TextField = new TextField();
		text.width = tmp.width;
		text.height = tmp.height;
		text.multiline = true;
		text.wordWrap = true;
		text.selectable = false;

        percentText = new TextField();
		percentText.width = tmp.width;
		percentText.height = tmp.height;
		percentText.multiline = true;
		percentText.wordWrap = true;
		percentText.selectable = false;

		#if flash
		text.embedFonts = true;
		text.antiAliasType = AntiAliasType.NORMAL;
		text.gridFitType = GridFitType.PIXEL;
        percentText.embedFonts = true;
		percentText.antiAliasType = AntiAliasType.NORMAL;
		percentText.gridFitType = GridFitType.PIXEL;
		#end
		var dtf:TextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 10, FlxColor.WHITE);
		dtf.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = dtf;
		addChild(text);
		text.text = "VOLUME";
		text.y = 16;

        percentText.defaultTextFormat = dtf;
		addChild(percentText);
		percentText.text = Math.round(FlxG.sound.volume * 10) + "%";
		percentText.y = 30;

		var bx:Int = 10;
		var by:Int = 14;
		_bars = new Array();

		for (i in 0...10)
		{
			tmp = new Bitmap(new BitmapData(4, i + 1, false, FlxColor.WHITE));
			tmp.x = bx;
			tmp.y = by;
			addChild(tmp);
			_bars.push(tmp);
			bx += 6;
			by--;
		}

		y = -height;
		visible = false;
    }
    override public function show(up:Bool = false){
        super.show(up);
        var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
        percentText.text = globalVolume * 10 + "%";
    }
}