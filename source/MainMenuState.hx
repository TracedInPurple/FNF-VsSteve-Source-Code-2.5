package;

import Controls.KeyboardScheme;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import lime.system.System;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuBG:FlxSprite;
	var menuBGClone:FlxSprite;
	var logoBl:FlxSprite;
	var tigoBabo:FlxSprite;
	var pressCount:Int = 0;
	var dimBG:FlxSprite;
	var pressEnter:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'quit', 'credits', 'ouh', 'bonus'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "1.17";

	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	var tween:FlxTween;
	var pano:FlxSprite;
	var panoclone:FlxSprite;
	var startscroll:Bool;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		FlxG.mouse.visible = true;

		//var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		//menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		//menuBG.x -= 800;
		//menuBG.y -= 400;
		//menuBG.updateHitbox();
		//menuBG.antialiasing = false;
		//menuBG.scale.set(1.3, 1.3);
		//add(menuBG);

        camFollow = new FlxObject(0, 0, 0, 0);
		add(camFollow);

		pano = new FlxSprite(-1600, 0).loadGraphic(Paths.image('menuBG'));
		pano.antialiasing = true;
		pano.updateHitbox();
		add(pano);

		panoclone = new FlxSprite(-2880, 0).loadGraphic(Paths.image('menuBG'));
		panoclone.antialiasing = true;
		panoclone.updateHitbox();
		add(panoclone);
		
		startscroll = true;
		
		var minecraft:FlxSprite = new FlxSprite().loadGraphic(Paths.image("minecraf"));
        minecraft.antialiasing = false;
		minecraft.screenCenter();
		minecraft.y -= 225;
        minecraft.updateHitbox();
		add(minecraft);

		
		tigoBabo = new FlxSprite().loadGraphic(Paths.image("Creators"));
		tigoBabo.y += 750;
		tigoBabo.x += 550;
		tigoBabo.antialiasing = false;
		tigoBabo.setGraphicSize(Std.int(tigoBabo.width * 0.4));
		tigoBabo.updateHitbox();
		add(tigoBabo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

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
				case 0: //storymode
					butos.setPosition(butos.x, 275);
				case 1: //freeplay
					butos.setPosition(butos.x, 340);
				case 2: // options
					butos.setPosition(butos.x - 110, 550);
				case 3: //quit game
					butos.setPosition(butos.x + 110, 550);
				case 4: //credits?
					butos.setPosition(butos.x - 250, 550);
				case 5: //uoh?
					butos.setPosition(butos.x + 250, 550);
				case 6: //extras
				    butos.setPosition(butos.x, 405);
				case 7: //uoh?
					butos.setPosition(butos.x + 300, 550);
			}
			menuItems.add(butos);
		}

		var storymenualert:FlxSprite = new FlxSprite().loadGraphic(Paths.image("story mode alert"));
        storymenualert.antialiasing = false;
		storymenualert.screenCenter();
		storymenualert.y -= 135;
		storymenualert.x += 350;
        storymenualert.updateHitbox();
		add(storymenualert);

		add(menuItems);

		dimBG = new FlxSprite().loadGraphic(Paths.image("blackBG"));
        dimBG.antialiasing = false;
		dimBG.screenCenter(X);
        dimBG.updateHitbox();
		dimBG.alpha = 0;
		add(dimBG);

		pressEnter = new FlxSprite(0, 0).loadGraphic(Paths.image("enter"));
        pressEnter.antialiasing = false;
		pressEnter.setGraphicSize(Std.int(pressEnter.width * 3));
		pressEnter.screenCenter(X);
		pressEnter.x -= 160;
		pressEnter.screenCenter(Y);
        pressEnter.updateHitbox();
		pressEnter.alpha = 0;
		add(pressEnter);

		firstStart = false;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 30, 0, gameVer +  (Main.watermarks ? " Minecraft " + kadeEngineVer + " Steve Engine?" : ""), 20);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		versionShit.scrollFactor.set();
		versionShit.borderSize = 1.25;
		versionShit.antialiasing = false;
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		//var textBox:FlxSprite = new FlxSprite().loadGraphic(Paths.image("textEnter"));
        //textBox.antialiasing = false;
		//textBox.screenCenter(X);
        //textBox.updateHitbox();
		//add(textBox);
		//textBox.visible = false;

		super.create();
	}

	var selectedSomethin:Bool = false;

	var canClick:Bool = true;
	var usingMouse:Bool = false;
	

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.mouse.overlaps(tigoBabo))
		{
			if(FlxG.mouse.justPressed)
			{
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong('dev battle', 1), 'dev battle');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 1;
				LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		var enter:Bool = controls.ACCEPT;

		if (FlxG.keys.justPressed.E)
			if (pressCount == 0)
			{
				pressCount = 1;
				new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						dimBG.alpha += 0.01;
			
						if (dimBG.alpha < 0.15)
						{
							tmr.reset(0.001);
						}
	
					});
			}
			else
			{
				pressCount == 0;
				new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						dimBG.alpha -= 0.03;
			
						if (dimBG.alpha > 1)
						{
							tmr.reset(0.001);
						}
	
					});

			}

		if (FlxG.keys.justPressed.N)
			if (pressCount == 1)
			{
				pressCount = 2;
				new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						dimBG.alpha += 0.01;
			
						if (dimBG.alpha < 0.3)
						{
							tmr.reset(0.001);
						}
	
					});
			}
			else
			{
				pressCount == 0;
				new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						dimBG.alpha -= 0.03;
			
						if (dimBG.alpha > 1)
						{
							tmr.reset(0.001);
						}
	
					});
			}

		if (FlxG.keys.justPressed.T)
			if (pressCount == 2)
				{
					pressCount = 3;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha += 0.01;
				
							if (dimBG.alpha < 0.45)
							{
								tmr.reset(0.001);
							}
		
						});
				}
			else
				{
					pressCount == 0;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha -= 0.03;
				
							if (dimBG.alpha > 1)
							{
								tmr.reset(0.001);
							}
		
						});
				}

		if (FlxG.keys.justPressed.I)
			if (pressCount == 3)
				{
					pressCount = 4;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha += 0.01;
				
							if (dimBG.alpha < 0.60)
							{
								tmr.reset(0.001);
							}
		
						});
				}
			else
				{
					pressCount == 0;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha -= 0.03;
				
							if (dimBG.alpha > 1)
							{
								tmr.reset(0.001);
							}
		
						});
				}

		if (FlxG.keys.justPressed.T)
			if (pressCount == 4)
				{
					pressCount = 5;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha += 0.01;
				
							if (dimBG.alpha < 0.75)
							{
								tmr.reset(0.001);
							}
		
						});
				}
			else
				{
					pressCount == 0;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha -= 0.03;
				
							if (dimBG.alpha > 1)
							{
								tmr.reset(0.001);
							}
		
						});
				}

		if (FlxG.keys.justPressed.Y)
			if (pressCount == 5)
				{
					pressCount = 6;
					FlxG.sound.music.stop();
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha += 0.01;
				
							if (dimBG.alpha < 1)
							{
								tmr.reset(0.001);
							}
		
						});
					new FlxTimer().start(0.001, function(tmrr:FlxTimer)
						{
							pressEnter.alpha += 0.01;
				
							if (pressEnter.alpha < 1)
							{
								tmrr.reset(0.001);
							}
			
						});
				}
			else
				{
					pressCount == 0;
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dimBG.alpha -= 0.03;
				
							if (dimBG.alpha > 1)
							{
								tmr.reset(0.001);
							}
		
						});
						
				}
				
		if (enter && pressCount == 6)
			{
				//new FlxTimer().start(0.001, function(tmr:FlxTimer)
				//{
				//	pressEnter.alpha += 0.01;
		//
				//	if (pressEnter.alpha < 1)
				//	{
				//		tmr.reset(0.001);
				//	}
				//});
				FlxG.camera.shake(0.05, 360);

				if(enter)
				{
					PlayState.SONG = Song.loadFromJson('entity', 'entity');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 4;
					FlxG.camera.fade(FlxColor.RED, 0.5, false);

					//PLAY SPECIAL SOUND
					//FlxG.sound.play(Paths.sound('confirmMenu'));

					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				}

			}


		if (startscroll == true)
			{
				startscroll = false;
				panoclone.x = 1280;
				pano.x = 0;
				//pano.visible = false;
				FlxTween.tween(pano, {x: -1600}, 90, {
				onComplete: function(twn:FlxTween)
			{
				tween = FlxTween.tween(pano, { x: -2880 }, 90);
				FlxTween.tween(panoclone, {x: 0}, 90, {
				onComplete: function(twn:FlxTween)
			{
				tween.cancel();
				startscroll = true;
			}
		});
			}
		});
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

				if(FlxG.mouse.justPressed && canClick)
				{
					selectSomething();
				}
			}
		});
			
			if (!selectedSomethin)
				{
					var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
				
					if (controls.BACK)
					{
						FlxG.switchState(new TitleState());
					}
				}
				
			super.update(elapsed);
			
	}

	function selectSomething()
	{
		if (optionShit[curSelected] == 'ouh')
		{
			FlxG.sound.play(Paths.sound('ouh'));
			FlxG.camera.shake(0.05, 0.05);
		}
		else if (optionShit[curSelected] == 'story mode')
		{
			goToState();
		}
		else
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			
			canClick = false;

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxG.camera.fade(FlxColor.BLACK, 0.3, false);
					FlxTween.tween(spr, {alpha: 0}, 0.6, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxG.camera.fade(FlxColor.BLACK, 0.3, false);
					new FlxTimer().start(0.3, function(tmr:FlxTimer)
						{
							goToState();
						});
				}
			});
		}
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				//FlxG.switchState(new StoryMenuState());
				FlxG.sound.play(Paths.sound('cancelMenu'));			
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new DifficultyInfo());
				trace("Freeplay Menu Selected");

			case 'ouh':
				trace("WHAT THE FUCK HAPPENED");

			case 'options':
				FlxG.switchState(new OptionsMenu());

			case 'quit':
				System.exit(0);

			case 'credits':
				FlxG.switchState(new WarnCreditState());
			case 'bonus':
				FlxG.switchState(new ExtrasState());
				trace("extras");
			
		}
	}

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
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}