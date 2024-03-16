package utilities.frontend;

import flixel.system.debug.log.LogStyle;
import flixel.system.frontEnds.LogFrontEnd;

class FunkinFrontEnd extends LogFrontEnd {
    public static var onLogs:Dynamic->LogStyle->Bool->Void;

    override public function advanced(Data:Dynamic, ?Style:LogStyle, FireOnce:Bool = false){
        super.advanced(Data, Style, FireOnce);
        if (onLogs != null)
			onLogs(Data, Style, FireOnce);
    }
}