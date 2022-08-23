package;

import flixel.FlxSprite;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class SpammingSubState extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var BG:FlxSprite;
	var curSelected:Int = 0;
	var defaultCamZoom:Float = 0.6;
	public static var finishedFunnyMove:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['retry', 'quit'];


	override function create()
		{
			#if windows
			// Updating Discord Rich Presence
			DiscordClient.changePresence("In the Main Menu", null);
			#end
	
			persistentUpdate = persistentDraw = true;
	
			FlxG.mouse.visible = true;

	
			BG = new FlxSprite(0, 0).loadGraphic(Paths.image('KickedBG'));
			BG.setGraphicSize(Std.int(BG.width * 1.2));
			BG.y -= 300;
			BG.screenCenter(X);
			BG.x -= 200;
			BG.scrollFactor.set(0,0);
			BG.updateHitbox();
			BG.antialiasing = false;
			add(BG);

			camFollow = new FlxObject(0, 0, 0, 0);
			add(camFollow);
	
			menuItems = new FlxTypedGroup<FlxSprite>();
			
			var tex = Paths.getSparrowAtlas('FNF_kicked_assets');
	
			for (i in 0...optionShit.length)
			{
				var butos:FlxSprite = new FlxSprite(0, FlxG.height * 1.2);
				butos.ID = i;
				butos.frames = tex;
				butos.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				butos.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				butos.animation.play('idle');
				butos.antialiasing = false;
				butos.setGraphicSize(Std.int(butos.width * 1.65));
				butos.updateHitbox();
				butos.screenCenter(X);
				butos.scrollFactor.set();
				switch(i) 
				{
					case 0: //retry
						butos.setPosition(butos.x, 420);
					case 1: //quit
						butos.setPosition(butos.x, 520);
				}
				menuItems.add(butos);
			}
	
			add(menuItems);
			FlxG.camera.zoom = defaultCamZoom;
			super.create();
		}
		var selectedSomethin:Bool = false;

		var canClick:Bool = true;
		var usingMouse:Bool = false;
		
	override function update(elapsed:Float)
	{
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
						selectSomething();
					}
				}
			});
					
			super.update(elapsed);

		//if (controls.ACCEPT)
		//{
		//	endBullshit();
		//}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

	
		
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}


	function selectSomething()
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			
			canClick = false;

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxG.camera.fade(FlxColor.BLACK, 0.2, false);
					FlxTween.tween(spr, {alpha: 0}, 0.2, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxG.camera.fade(FlxColor.BLACK, 0.2, false);
					new FlxTimer().start(0.4, function(tmr:FlxTimer)
						{
							goToState();
						});
				}
			});	
		}
	
		function goToState()
		{
			var daChoice:String = optionShit[curSelected];
	
			switch (daChoice)
			{
				case 'retry':
					LoadingState.loadAndSwitchState(new PlayState());
					trace("retry");


				case 'quit':
					FlxG.sound.music.stop();

					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
					PlayState.loadRep = false;

					trace("Quit");
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