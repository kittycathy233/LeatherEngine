package plugins;

#if SCREENSHOTS_ALLOWED
import flixel.input.keyboard.FlxKey;
import screenshotplugin.ScreenShotPlugin;
#end

class ScreenshotPluginConfig {
    public static function setScreenshotConfig(#if SCREENSHOTS_ALLOWED format:FileFormatOption, bind:FlxKey #end) {
        #if SCREENSHOTS_ALLOWED
        ScreenShotPlugin.screenshotKey = bind;
        ScreenShotPlugin.saveFormat = format;
        #end
    }
}