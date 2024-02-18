package ui;

import flixel.addons.ui.FlxUISlider;
import flixel.tweens.FlxTween;
import utilities.Ratings;
import utilities.CoolUtil;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.math.FlxMath;
import flixel.FlxObject;
import states.MainMenuState;
import game.Boyfriend;
import flixel.FlxG;
import game.Character;
import flixel.FlxSprite;
import game.StageGroup;
import flixel.FlxCamera;
import states.MusicBeatState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import flixel.ui.FlxButton;


class HUDAdjustment extends MusicBeatState{

    /* OPTIONS */
    var ui_settings:Array<String>;
	var characterPlayingAs:Int = 0;
	var reset:FlxButton;

    /* CAMERA */
	var camGame:FlxCamera;
	var camHUD:FlxCamera;

    var camFollow:FlxObject;

	/*STAGE*/
	var stage:StageGroup;
	var stagePosition:FlxSprite;

	var stages:Array<String>;
	var stage_Name:String = 'stage';
	var stageData:StageData;
	
	var stage_Dropdown:FlxUIDropDownMenuCustom;
	var objects:Array<Array<Dynamic>> = [];


    /* CHARACTER*/  
    var bf:Boyfriend;
    var gf:Character;
    var characters:Map<String, Array<String>> = ["default" => ["bf", "gf"]];

    /* RATINGS */
    var ratingsGroup:FlxSpriteGroup = new FlxSpriteGroup();
    var rating:FlxSprite = new FlxSprite();
    var accuracyText:FlxText = new FlxText(0, 0, 0, "bruh", 24);
    var numbers:Array<FlxSprite> = [];
    var uiMap:Map<String, FlxGraphic> = [];
    var combo:Int = 123;
    var ratings:Map<String, Int> = ["marvelous" => 0, "sick" => 0, "good" => 0, "bad" => 0, "shit" => 0];

    var rating_Pos:FlxSprite;
	var combo_Pos:FlxSprite;

    var selectedObject:Int = 0;
    var selectedThing:Bool = false;
	var selected:Dynamic;



    override function create() {
		switch (Options.getData("playAs")) {
			case "bf":
				characterPlayingAs = 0;
			case "opponent":
				characterPlayingAs = 1;
			case "both":
				characterPlayingAs = -1;
			default:
				characterPlayingAs = 0;
		}
        FlxG.mouse.visible = true;
        #if discord_rpc
		DiscordClient.changePresence("Changing HUD Settings", null, null, true);
		#end


		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset();
		FlxG.cameras.add(camGame, true);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		FlxG.camera = camGame;

		if (FlxG.sound.music.active)
			FlxG.sound.music.stop();

		reloadStage();

        gf = new Character(400, 130, "gf");
		add(gf);

        bf = new Boyfriend(770, 450, "bf");
		add(bf);
        camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.sound.playMusic(Paths.music('breakfast'));
		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = stage.camZoom;
		FlxG.camera.focusOn(camFollow.getPosition());


        ratingsGroup.cameras = [camHUD];
		add(ratingsGroup);

        ui_settings = CoolUtil.coolTextFile(Paths.txt("ui skins/" + Options.getData("uiSkin") + "/config"));
        uiMap.set("marvelous", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/ratings/marvelous")));
		uiMap.set("sick", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/ratings/sick")));
		uiMap.set("good", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/ratings/good")));
		uiMap.set("bad", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/ratings/bad")));
		uiMap.set("shit", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/ratings/shit")));

        // preload numbers
		for (i in 0...10)
			uiMap.set(Std.string(i), FlxGraphic.fromAssetKey(Paths.image("ui skins/" + Options.getData("uiSkin") + "/numbers/num" + Std.string(i))));

        popUpScore(0,0,0);

		rating_Pos = new FlxSprite(rating.x, rating.y);
		rating_Pos.makeGraphic(32, 32, FlxColor.RED);
		rating_Pos.updateHitbox();

		combo_Pos = new FlxSprite(numbers[0].x, numbers[0].y);
		combo_Pos.makeGraphic(32, 32, FlxColor.RED);
		combo_Pos.updateHitbox();

		add(rating_Pos);
		add(combo_Pos);
        reset = new FlxButton(0, FlxG.height, "RESET", function() {
			combo_Pos.screenCenter();
			rating_Pos.screenCenter();
			rating.screenCenter();
			Options.setData([combo_Pos.x, combo_Pos.y, 1, 1], "comboSettings");
			Options.setData([rating.x, rating.y, 1, 1], "ratingsSettings");
			trace("reset");
		});
		reset.cameras = [camHUD];
		add(reset);
		reset.y -= reset.height;
		super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(rating_Pos) && FlxG.mouse.pressed && !selectedThing) {
			selectedThing = true;
			selected = rating_Pos;

			selectedObject = 0;
		} else if (FlxG.mouse.overlaps(combo_Pos) && FlxG.mouse.pressed && !selectedThing) {
			selectedThing = true;
			selected = combo_Pos;

			selectedObject = 0;
		}
	 	else if (!FlxG.mouse.pressed)
			selectedThing = false;

        if (FlxG.mouse.pressed && selectedThing) {
			selected.x = FlxG.mouse.x ;
			selected.y = FlxG.mouse.y;
        }
        if(FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
            FlxG.switchState(new MainMenuState());

        if(selected == rating_Pos)
            Options.setData([rating_Pos.x, rating_Pos.y, 1, 1], "ratingsSettings");

		if(selected == combo_Pos)
            Options.setData([combo_Pos.x, combo_Pos.y, 1, 1], "comboSettings");

        popUpScore(0,0,0);

		//trace(rating_Pos.x);
		//trace(rating.x);
		//trace(Options.getData("ratingsSettings")[0]);

        super.update(elapsed);
    }

    function reloadStage() {
		objects = [];
		clear();
		stage = new StageGroup(stage_Name);
		add(stage);
		@:privateAccess
		stageData = stage.stage_Data;
		add(stage.infrontOfGFSprites);
		add(stage.foregroundSprites);
	}

    public function popUpScore(strumtime:Float, noteData:Int, ?setNoteDiff:Float):Void {
		var noteDiff:Float = 0;

		if (setNoteDiff != null)
			noteDiff = setNoteDiff;

		var daRating:String = Ratings.getRating(Math.abs(noteDiff));

	

		var hitNoteAmount:Float = 1;

		if (ratings.exists(daRating))
			ratings.set(daRating, ratings.get(daRating) + 1);




		rating.alpha = 1;
		rating.loadGraphic(uiMap.get(daRating), false, 0, 0, true, daRating);

        rating.x = Options.getData("ratingsSettings")[0];
		rating.x -= (Options.getData("middlescroll") ? 350 : (characterPlayingAs == 0 ? 0 : -150));
		rating.y = Options.getData("ratingsSettings")[1];
		rating.y -= 60;

		var noteMath:Float = FlxMath.roundDecimal(noteDiff, 2);

		accuracyText.setPosition(rating.x, rating.y + 100);
		accuracyText.text = noteMath + " ms" + (Options.getData("botplay") ? " (BOT)" : "");

		if (Math.abs(noteMath) == noteMath)
			accuracyText.color = FlxColor.CYAN;
		else
			accuracyText.color = FlxColor.ORANGE;

		accuracyText.borderStyle = FlxTextBorderStyle.OUTLINE;
		accuracyText.borderSize = 1;
		accuracyText.font = Paths.font("vcr.ttf");

		ratingsGroup.add(accuracyText);

		ratingsGroup.add(rating);

		rating.setGraphicSize(Std.int(rating.width * Std.parseFloat(ui_settings[0]) * Std.parseFloat(ui_settings[4])));
		rating.antialiasing = ui_settings[3] == "true";
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		for (i in 0...Std.string(combo).length) {
			seperatedScore.push(Std.parseInt(Std.string(combo).split("")[i]));
		}

		var daLoop:Int = 0;

		for (i in seperatedScore) {
			if (numbers.length - 1 < daLoop)
				numbers.push(new FlxSprite());

			var numScore = numbers[daLoop];
			numScore.alpha = 1;

			numScore.loadGraphic(uiMap.get(Std.string(i)), false, 0, 0, true, Std.string(i));

			numScore.x = Options.getData("comboSettings")[0];
			numScore.y = Options.getData("comboSettings")[1];
			numScore.x -= (Options.getData("middlescroll") ? 350 : (characterPlayingAs == 0 ? 0 : -150));

			numScore.x += (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.setGraphicSize(Std.int(numScore.width * Std.parseFloat(ui_settings[1])));
			numScore.updateHitbox();

			numScore.antialiasing = ui_settings[3] == "true";

			ratingsGroup.add(numScore);

			daLoop++;
		}
	}

}