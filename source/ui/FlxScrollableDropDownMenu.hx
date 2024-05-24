package ui;

import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.addons.ui.FlxUIDropDownMenu;

class FlxScrollableDropDownMenu extends FlxUIDropDownMenu  {

    private var currentScroll:Int = 0; //Handles the scrolling
    public var canScroll:Bool = true;
    
    override private function set_dropDirection(dropDirection):FlxUIDropDownMenuDropDirection
        {
            this.dropDirection = Down;
            updateButtonPositions();
            return dropDirection;
        }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        #if FLX_MOUSE
		if (dropPanel.visible)
		{
			if(list.length > 1 && canScroll) {
				if(FlxG.mouse.wheel > 0 || FlxG.keys.justPressed.UP) {
					// Go up
					--currentScroll;
					if(currentScroll < 0) currentScroll = 0;
					updateButtonPositions();
				}
				else if (FlxG.mouse.wheel < 0 || FlxG.keys.justPressed.DOWN) {
					// Go down
					currentScroll++;
					if(currentScroll >= list.length) currentScroll = list.length-1;
					updateButtonPositions();
				}
			}

			if (FlxG.mouse.justPressed && !FlxG.mouse.overlaps(this, this.camera))
			{
				showList(false);
			}
		}
		#end
    }
    override function updateButtonPositions():Void{
        super.updateButtonPositions();
        var buttonHeight = header.background.height;
		dropPanel.y = header.background.y;
		if (dropsUp())
			dropPanel.y -= getPanelHeight();
		else
			dropPanel.y += buttonHeight;

		var offset = dropPanel.y;
        for (i in 0...currentScroll) { //Hides buttons that goes before the current scroll
			var button:FlxUIButton = list[i];
			if(button != null) {
				button.y = -99999;
			}
		}
		for (i in currentScroll...list.length)
		{
			var button:FlxUIButton = list[i];
			if(button != null) {
				button.y = offset;
				offset += buttonHeight;
			}
		}
    }
}