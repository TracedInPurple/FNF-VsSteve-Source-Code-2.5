package;

import Controls.KeyboardScheme;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
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

class ExtrasState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['bonus songs', 'other songs'];
	#else
	var optionShit:Array<String> = ['bonus songs', 'other songs'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;
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
		DiscordClient.changePresence("In the Extras Menu", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		FlxG.mouse.visible = true;

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
				case 0: //bonus Songs
					butos.setPosition(butos.x, 300);
				case 1: //Old Songs
					butos.setPosition(butos.x, 365);
			}
			menuItems.add(butos);
		}

		add(menuItems);

		var othersAlert:FlxSprite = new FlxSprite().loadGraphic(Paths.image("old songs alert"));
        othersAlert.antialiasing = false;
		othersAlert.screenCenter();
		othersAlert.y += 110;
		othersAlert.x += 350;
        othersAlert.updateHitbox();
		add(othersAlert);

		firstStart = false;

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

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
						FlxG.switchState(new MainMenuState());
					}
				}
				
			super.update(elapsed);
			
	}

	function selectSomething()
	{
		if(optionShit[curSelected] == 'other songs')
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));	
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
					new FlxTimer().start(1, function(tmr:FlxTimer)
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
			case 'bonus songs':
				FlxG.switchState(new FreeplayStateBonus());
				trace("bonus songs!");

			case 'other songs':
				FlxG.sound.play(Paths.sound('cancelMenu'));			
				//FlxG.switchState(new FreeplayStateOthers());
				trace("Other Songs");
				trace("Disabled!");
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