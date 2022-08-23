package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	//Using MainMenuState Stuff for the Week Buttons and im too Lazy - Tiago
	var menuItems:FlxTypedGroup<FlxSprite>;
	public static var finishedFunnyMove:Bool = false;
	var curSelected:Int = 0;


	//again more copy paste from uhh mainmenu state
	var optionShit:Array<String> = ['day1', 'day2', 'day3'];


	var weekData:Array<Dynamic> = [
		['Practice', 'Uoh', 'Craft Away', 'Suit Up', 'Whatever'],
		['Overseen', 'Mine', 'Iron Picks', 'Copper', 'Underrated', 'Tick Tock'],
		['Fast Travel', 'Gapple', 'Retired']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['steve', 'bf', 'gf'],		
		['alex', 'bf', ''],
		['notch', 'bf', 'gf']
	];

	var weekNames:Array<String> = [
		"Crafting Bars",
		"Xp farms be like",
		"The Finale?"
	];

	var difficultyText:Array<String> = [
		"Peaceful: ",
		"Hard",
		"Hardcore",
		"Ultra Hardcore"
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var txtDifficulty:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;
	var diffs:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		FlxG.mouse.visible = true;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuBGSM")); // TIAGO THIS HERE INCASE yOUR FORGET LOL -- written by tiago

		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = false;
		menuBG.scale.set(1.3, 1.3);
		menuBG.y -= 50;
		add(menuBG);

		var b:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('blackSM'));
		b.scrollFactor.x = 0;
		b.scrollFactor.y = 0;
		b.updateHitbox();
		b.screenCenter();
		b.antialiasing = true;
		add(b);


		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		
		persistentUpdate = persistentDraw = true;
		
		scoreText = new FlxText(FlxG.width * 0.675, 10, 0, "SCORE: 49324858", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32);
		scoreText.y += 660;

		txtWeekTitle = new FlxText(FlxG.width * 0.675, 10, 0, "", 32);
		txtWeekTitle.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);
		txtWeekTitle.y += 550;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("MinecraftRegular-Bmg3.otf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);
		
		
		//var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0x00000000);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 50");


		
		trace("Line 70");

		menuItems = new FlxTypedGroup<FlxSprite>();
		

		var tex = Paths.getSparrowAtlas('FNF_story_menu_assets');

		for (i in 0...optionShit.length)
		{
			var butos:FlxSprite = new FlxSprite(0, FlxG.height * 1.2);
			butos.ID = i;
			butos.frames = tex;
			butos.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			butos.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			butos.animation.play('idle');
			butos.antialiasing = false;
			butos.updateHitbox();
			butos.screenCenter(X);
			butos.scrollFactor.set();
			switch(i) 
			{
				case 0: //Day 1
					butos.setPosition(butos.x - 80, 500);
				case 1: //Day 2
					butos.setPosition(butos.x - 80, 575);
				case 2: //Day 3
					butos.setPosition(butos.x - 80, 650);
			}
			menuItems.add(butos);
		}

		add(menuItems);


		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		diffs = new FlxSprite(0, 340);
		diffs.frames = Paths.getSparrowAtlas('Diffs');
		diffs.animation.addByPrefix('easy', 'Easy', 24);
		diffs.animation.addByPrefix('normal', 'Normal', 24);
		diffs.animation.addByPrefix('harrrd', 'Very yes very much hard', 24);
		diffs.animation.addByPrefix('hardcoreee', 'Hardcore', 24);
		diffs.animation.addByPrefix('Ultrahardcoreee', 'UltraHardcore', 24);
		diffs.animation.play('normal');
		add(diffs);
		
		upArrow = new FlxSprite(150, 320);
		upArrow.frames = Paths.getSparrowAtlas('Arrows');
		upArrow.animation.addByPrefix('idle', 'Up', 24, false);
		upArrow.animation.addByPrefix('press', "Up press", 24, false);
		upArrow.animation.play('idle');
		add(upArrow);
		
		downArrow = new FlxSprite(150, 440);
		downArrow.frames = Paths.getSparrowAtlas('Arrows');
		downArrow.animation.addByPrefix('idle', 'Down Press', 24, false);
		downArrow.animation.addByPrefix('press', "very much Down", 24, false);
		downArrow.animation.play('idle');
		add(downArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, 20, 0, "Tracks", 24);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFFFFFFF;
		txtTracklist.y += 480;
		add(txtTracklist);

		txtDifficulty = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Difficulty", 32);
		txtDifficulty.alignment = CENTER;
		txtDifficulty.font = rankText.font;
		txtDifficulty.color = 0xFFFFFFFF;
		txtDifficulty.y += -480;
		add(txtDifficulty);
		// add(rankText);

		add(scoreText);
		
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	//More Main Menu Stuff - Tiago
	var selectedSomethin:Bool = false;

	var canClick:Bool = true;
	var usingMouse:Bool = false;


	override function update(elapsed:Float)
	{
		// scoreText.setFormat('vcr.ttf', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];


		if (!movedBack)
		{
			if (!selectedWeek)
			{
					
				if (controls.UP_P)
					{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					}
				if (controls.DOWN_P)
					{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					
				if (controls.UP_P)
					changeDifficulty(1);
				if (controls.DOWN_P)
					changeDifficulty(-1);
			}

			//if (controls.ACCEPT)
			//{
			//	selectWeek();
			//}
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			if(usingMouse)
			{
				if(!FlxG.mouse.overlaps(spr))
					spr.animation.play('idle');
			}

			if (FlxG.mouse.overlaps(spr))
			{
				if(canClick)
				{
					curSelected = spr.ID;
					usingMouse = true;
					spr.animation.play('selected');
				}

				if(FlxG.mouse.pressed && canClick)
				{
					selectWeek();
				}
			}
		});
				
		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}
		}
		
		if (curDifficulty == 0){
		diffs.animation.play('normal');
		}	
		if (curDifficulty == 1){
		diffs.animation.play('harrrd');
		}
		if (curDifficulty == 2){
		diffs.animation.play('hardcoreee');
		}
		if (curDifficulty == 3){
			diffs.animation.play('Ultrahardcoreee');
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				canClick = false;

				
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-normal';
				case 2:
					diffic = '-hardcore';
				case 3:
					diffic = '-ultrahardcore';
			}

			for (i in 0...optionShit.length)
			{
				switch(i)
				{
					case 0:
						curWeek = 0;
					case 1:
						curWeek = 1;
					case 2:
						curWeek = 2;
				}
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;
			

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
		updateText();
	}

		
	

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks:";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}