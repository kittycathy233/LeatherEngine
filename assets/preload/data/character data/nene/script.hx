var pupilState:Int = 0;

var PUPIL_STATE_NORMAL = 0;
var PUPIL_STATE_LEFT = 1;

var abot:FlxAnimate;
var stereoBG:FlxSprite;
var eyeWhites:FlxSprite;
var pupil:FlxAtlasSprite;

function createPost(){
    trace('LET HIM COOK!');
    stereoBG = new FlxSprite(0, 0, Paths.image('characters/abot/stereoBG', 'shared'));
    stereoBG.scrollFactor.set(0.95, 0.95);
    eyeWhites = new FlxSprite().makeGraphic(160, 60, FlxColor.WHITE);

	pupil = new FlxAtlasSprite(0, 0, Paths.getTextureAtlas("characters/abot/systemEyes", "shared"));
	pupil.x = character.x;
	pupil.y = character.y;
    pupil.scrollFactor.set(0.95, 0.95);
    pupil.antialiasing = Options.getData("antialiasing");

	abot = new FlxAnimate(0, 0, Paths.getTextureAtlas("characters/abot/abotSystem", "shared"));
	abot.x = character.x;
	abot.y = character.y;
    abot.scrollFactor.set(0.95, 0.95);
    abot.antialiasing = Options.getData("antialiasing");

    abot.x = character.x - 100;
    abot.y = character.y + 316; // 764 - 740

    PlayState.instance.addBehindGF(stereoBG);
    PlayState.instance.addBehindGF(eyeWhites);
    PlayState.instance.addBehindGF(pupil);
    PlayState.instance.addBehindGF(abot);

    eyeWhites.x = abot.x + 40;
    eyeWhites.y = abot.y + 250;
    eyeWhites.antialiasing = Options.getData("antialiasing");
    eyeWhites.scrollFactor.set(0.95, 0.95);

    pupil.x = character.x - 607;
    pupil.y = character.y - 176;

    stereoBG.x = abot.x + 150;
    stereoBG.y = abot.y + 30;
    stereoBG.antialiasing = Options.getData("antialiasing");

    character.x += 20;
    character.y += 5;
}
function update() {
    // Set the visibility of ABot to match Nene's.
    abot.visible = character.visible;
    pupil.visible = character.visible;
    eyeWhites.visible = character.visible;
    stereoBG.visible = character.visible;

    if (pupil.anim.isPlaying)
    {
        switch (pupilState)
        {
            case PUPIL_STATE_NORMAL:
                if (pupil.anim.curFrame >= 17)
                {
                    pupilState = PUPIL_STATE_LEFT;
                    pupil.anim.pause();
                }

            case PUPIL_STATE_LEFT:
                if (pupil.anim.curFrame >= 31)
                {
                    pupilState = PUPIL_STATE_NORMAL;
                    pupil.anim.pause();
                }

        }
    }
}
function turnChange(turn:String){
	switch (turn) {
		case 'dad':
			movePupilsRight();
		case 'bf':
			movePupilsLeft();
		default:
			trace('no match!');
	}
}
function movePupilsLeft():Void {
    if (pupilState == PUPIL_STATE_LEFT) return;
    pupil.anim.play('');
    pupil.anim.curFrame = 0;
    // pupilState = PUPIL_STATE_LEFT;
}

function movePupilsRight():Void {
    if (pupilState == PUPIL_STATE_NORMAL) return;
    pupil.anim.play('');
    pupil.anim.curFrame = 17;
    // pupilState = PUPIL_STATE_NORMAL;
}