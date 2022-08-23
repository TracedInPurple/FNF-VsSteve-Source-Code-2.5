package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var stevamor:FlxSprite;
	var bf:FlxSprite;
	var alex:FlxSprite;
	var stevnormal:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
	//i disabled the dialogs with lmaos, LMAOOOOOOO -babobias
	//enabled again by tigo -Tigo
	//added dialouge  -Nosadx
	// enabled by google chrome - chromasen
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'Uoh':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'Craft Away':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'Suit Up':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			//case 'overseen':
			//	FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
			//	FlxG.sound.music.fadeIn(1, 0, 0.8);
			//case 'iron picks':
			//	FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
			//	FlxG.sound.music.fadeIn(1, 0, 0.8);
			//case 'underrated':
			//	FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
			//	FlxG.sound.music.fadeIn(1, 0, 0.8);
			//case 'tick tock':
			//	FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
			//	FlxG.sound.music.fadeIn(1, 0, 0.8);

		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'Uoh':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('portraits/dialogueBox-pixel', 'shared');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance', [11], "", 24);

			case 'Craft Away':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('portraits/dialogueBox-pixel', 'shared');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance', [11], "", 24);

			case 'Suit Up':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('portraits/dialogueBox-pixel', 'shared');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear instance', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance', [11], "", 24);
				
			//case 'overseen':
			//	hasDialog = true;
			//	box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad', 'shared');
			//	box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
			//	box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [11], "", 24);

			//case 'iron picks':
			//	hasDialog = true;
			//	box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad', 'shared');
			//	box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
			//	box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [11], "", 24);
			//
			//case 'underrated':
			//	hasDialog = true;
			//	box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad', 'shared');
			//	box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
			//	box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [11], "", 24);
		
			//case 'tick tock':
			//	hasDialog = true;
			//	box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad', 'shared');
			//	box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
			//	box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [11], "", 24);

			//case 'eyes':
			//	hasDialog = true;
			//	box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
			//	box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
			//	box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

			//	var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
			//	face.setGraphicSize(Std.int(face.width * 6));
			//	add(face);
	
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		if (PlayState.SONG.song.toLowerCase() == 'Uoh' || PlayState.SONG.song.toLowerCase() == 'Craft Away' ||PlayState.SONG.song.toLowerCase() == 'Suit Up')
		{
		stevamor = new FlxSprite(-20, 40);
		stevamor.frames = Paths.getSparrowAtlas('portraits/armorstevPortrait','shared');
		stevamor.animation.addByPrefix('enter', 'armorstevPortrait instance', 24, false);
		stevamor.setGraphicSize(Std.int(stevamor.width * PlayState.daPixelZoom * 0.9));
		stevamor.updateHitbox();
		stevamor.scrollFactor.set();
		add(stevamor);
		stevamor.visible = false;

		stevnormal = new FlxSprite(-20, 40);
		stevnormal.frames = Paths.getSparrowAtlas('portraits/tuxstevnormal','shared');
		stevnormal.animation.addByPrefix('enter', 'tuxstev Portrait', 24, false);
		stevnormal.setGraphicSize(Std.int(stevamor.width * PlayState.daPixelZoom * 0.9));
		stevnormal.updateHitbox();
		stevnormal.scrollFactor.set();
		add(stevnormal);
		stevnormal.visible = false;

		alex = new FlxSprite(-20, 40);
		alex.frames = Paths.getSparrowAtlas('portraits/alexNormal','shared');
		alex.animation.addByPrefix('enter', 'alexNormal idle', 24, false);
		alex.setGraphicSize(Std.int(alex.width * PlayState.daPixelZoom * 0.9));
		alex.updateHitbox();
		alex.scrollFactor.set();
		add(alex);
		alex.visible = false;

		bf = new FlxSprite(0, 40);
		bf.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		bf.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		bf.setGraphicSize(Std.int(bf.width * PlayState.daPixelZoom * 0.9));
		bf.updateHitbox();
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		stevamor.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'craft away')
			stevamor.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			stevamor.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'Uoh' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						stevamor.visible = false;
						bf.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'stev':
				bf.visible = false;
				alex.visible = false;
				stevnormal.visible = false;
				if (!stevamor.visible)
				{
					stevamor.visible = true;
					stevamor.animation.play('enter');
				}
				case 'stevnor':
					bf.visible = false;
					alex.visible = false;
					if (!stevnormal.visible)
					{
						stevnormal.visible = true;
						stevnormal.animation.play('enter');
					}
			case 'bf':
				stevamor.visible = false;
				alex.visible = false;
				stevnormal.visible = false;
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('enter');
				}
			case 'alex':
				stevamor.visible = false;
				bf.visible = false;
				stevnormal.visible = false;
				if (!alex.visible)
				{
					alex.visible = true;
					alex.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
