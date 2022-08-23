package;
//If youre seeing this... Tiago here...

import Options.SpectatorMode;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.filters.ColorMatrixFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	var camMovement:Float = 0.09;

	public static var songPosBG:FlxSprite;
	public static var songPosXP:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;
    var spinArray:Array<Int>;
	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	var duoDad:Character;
	var useCamChange:Bool = true;
	var hasDuoDad:Bool = false;
	var usesDuoDadChart:Bool = false;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var healthBarBGG:FlxSprite;
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var daSection:Int = 1;

	var songName:FlxText;

	var doggo:FlxSprite; 
	var alexPickaxeBG:FlxSprite; 
	var catto:FlxSprite; 
	var sheep:FlxSprite; 
	var minijukebox:FlxSprite; 
	var musicnotes:FlxSprite; 
	var alecs:FlxSprite; 
	var gfHorse:FlxSprite;
	var alexHorse:FlxSprite;
	var steveHorse:FlxSprite;
	var hors:FlxSprite; 
	var stev:FlxSprite; 
	var notchStanding:FlxSprite; 
	var gfminecraft:FlxSprite; 
	var irfan:FlxSprite; 
	var vignette:FlxSprite; 
	var fc:Bool = true;

	var evilTrail:FlxTrail;

	//HOT BAR VARIABLES
	var hotbar:FlxSprite;



	//Blockinf Stuff
	var achievementBlock:FlxSprite;
	var blackStuff:FlxSprite;
	var whiteStuff:FlxSprite;
	var detectAttack:Bool = false;

	var bgGirls:BackgroundGirls;
	var bgDevs:BackgroundDevs;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var scoreTxTMovement:FlxTween;
	var replayTxt:FlxText;

	public static var duoDadSONG:SwagSong;
	private var duoDadNotes:FlxTypedGroup<Note>;

	public static var campaignScore:Int = 0;

	var dadnoteMovementXoffset:Int = 0;
	var dadnoteMovementYoffset:Int = 0;

	var bfnoteMovementXoffset:Int = 0;
	var bfnoteMovementYoffset:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;

	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// SpectatorMode text
	private var SpectatorModeState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff

	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	//Fast Travel shit
	private var floatvalue:Float = 0;
	private var runvalue:Float = 0;
	
	private var fasttravelbg:FlxSprite;
	private var fasttravelbgClone:FlxSprite;
	private var bigmountian:FlxSprite;
	private var smallmountian:FlxSprite;
	private var smallmountian2:FlxSprite;
	private var houseFT:FlxSprite;
	var scroll:Bool = false;
	var tween:FlxTween;

	var hurtIcon:Bool = false;
	var strengthActive:Bool = false;
	
	
	private var hero:Float = 0;


	override public function create()
	{
		instance = this;

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;
        spinArray = [272, 276, 336, 340, 400, 404, 464, 468, 528, 532, 592, 596, 656, 660, 720, 724, 789, 793, 863, 867, 937, 941, 1012, 1016, 1086, 1090, 1160, 1164, 1531, 1535, 1607, 1611, 1681, 1685, 1754, 1758];
		repPresses = 0;
		repReleases = 0;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Peaceful";
			case 1:
				storyDifficultyText = "Hard";
			case 2:
				storyDifficultyText = "Hardcore";
			case 3:
				storyDifficultyText = "Ultra Hardcore";
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);


		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nSpectator Mode : ' + FlxG.save.data.SpectatorMode);

		//i disabled dialogues by replacing names with lmao, LMAOOOOOOOO -babobias
    //haha enbaled dialogues go BRRRRRRR -Taigo
	
	


		switch (SONG.song.toLowerCase())
		{
			case 'lmao':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'uoh':
				dialogue = CoolUtil.coolTextFile(Paths.txt('uoh/uohDialogue'));
			case 'craft away':
				dialogue = CoolUtil.coolTextFile(Paths.txt('craft away/craft awayDialogue'));
			case 'suit up':
				dialogue = CoolUtil.coolTextFile(Paths.txt('suit up/suit upDialogue'));

      // wek 2
    	//gonna disable so it doenst crash since the files dont exist and we dont have the dialogues ready... -Tiago
			/*
      case 'overseen':
				dialogue = CoolUtil.coolTextFile(Paths.txt('overseen/overseenDialogue'));
      case 'iron picks':
				dialogue = CoolUtil.coolTextFile(Paths.txt('iron picks/iron picksDialogue'));
			case 'underrated':
				dialogue = CoolUtil.coolTextFile(Paths.txt('underrated/underratedDialogue'));
    	case 'tick tock':
				dialogue = CoolUtil.coolTextFile(Paths.txt('tick tock/tick tockDialogue'));
    */

    }
	if (SONG.song.toLowerCase() == 'entity')
	{
		health = 2;
	}

		switch(SONG.stage)
		{

			case 'school':
			{
					curStage = 'school';

					//defaultCamZoom = 0.9;
					camMovement = 0.3;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'craft away')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6); 
					add(bg); 

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'house':
			{
					curStage = 'house';

					defaultCamZoom = 0.96;
					camMovement = 0.2;

					var houseBG = new FlxSprite().loadGraphic(Paths.image('house/houseBG'));
					houseBG.scrollFactor.set(1, 1);
					houseBG.y -= 1200;
					houseBG.x -= 1500;
					houseBG.setGraphicSize(Std.int(houseBG.width * 6));
					add(houseBG);

					var repositionShit = -200;

					var house:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('house/house'));
					house.y -= 425;
					house.x -= 1600;
					house.setGraphicSize(Std.int(house.width * 6));
					add(house);

					doggo = new FlxSprite(-820, 450);
				    doggo.frames = Paths.getSparrowAtlas('house/doggo');
					doggo.animation.addByPrefix('bop', 'dog idle', 24, false);
					doggo.setGraphicSize(Std.int(doggo.width * 6));
					doggo.updateHitbox();
			 		add(doggo);

					alexPickaxeBG = new FlxSprite(-375, 200);
				    alexPickaxeBG.frames = Paths.getSparrowAtlas('house/alexPickaxeBG');
					alexPickaxeBG.animation.addByPrefix('bop', 'alexPickaxeBG idle', 24, false);
					alexPickaxeBG.setGraphicSize(Std.int(alexPickaxeBG.width * 6));
					alexPickaxeBG.updateHitbox();
			 		add(alexPickaxeBG);

					catto = new FlxSprite(0, -320);
				    catto.frames = Paths.getSparrowAtlas('house/catto');
					catto.animation.addByPrefix('bop', 'catto idle', 24, false);
					catto.setGraphicSize(Std.int(catto.width * 5.5));
					catto.updateHitbox();
			 		add(catto);

					sheep = new FlxSprite(1500, 420);
				    sheep.frames = Paths.getSparrowAtlas('house/sheep');
					sheep.animation.addByPrefix('bop', 'sheep idle', 24, false);
					sheep.setGraphicSize(Std.int(sheep.width * 6));
					sheep.updateHitbox();
			 		add(sheep);

					houseBG.updateHitbox();
					house.updateHitbox();
			}
			case 'mine':
			{
					curStage = 'mine';

					defaultCamZoom = 0.96;
					camMovement = 0.2;

					var repositionShit = -200;

					var mine:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('mine/floor'));
					mine.y -= 150;
					mine.x -= 350;
					mine.setGraphicSize(Std.int(mine.width * 5.5));
					add(mine);

					var caveLeaves:FlxSprite = new FlxSprite(-200, 0);
					caveLeaves.frames = Paths.getSparrowAtlas('cave/leaves');
					caveLeaves.animation.addByPrefix('leaves', 'leaves', 24, true);
					caveLeaves.animation.play('leaves');
					caveLeaves.scrollFactor.set(0.85, 0.85);
					caveLeaves.setGraphicSize(Std.int(caveLeaves.width * daPixelZoom));
					add(caveLeaves);

					minijukebox = new FlxSprite(535, 395);
				    minijukebox.frames = Paths.getSparrowAtlas('mine/minijukebox');
					minijukebox.animation.addByPrefix('bop', 'minijukebox idle', 24, false);
					minijukebox.setGraphicSize(Std.int(minijukebox.width * 4.5));
					minijukebox.updateHitbox();
			 		add(minijukebox);

					mine.updateHitbox();
			}
			case 'cave':
			{
					curStage = 'cave';

					defaultCamZoom = 0.96;
					camMovement = 0.2;

					var caveBG = new FlxSprite().loadGraphic(Paths.image('cave/caveBG'));
					caveBG.scrollFactor.set(0.1, 0.1);
					caveBG.y -= 250;
					caveBG.x -= 500;
					caveBG.setGraphicSize(Std.int(caveBG.width * daPixelZoom));
					add(caveBG);

					var repositionShit = -200;

					var caveLeaves:FlxSprite = new FlxSprite(-100, -20);
					caveLeaves.frames = Paths.getSparrowAtlas('cave/leaves');
					caveLeaves.animation.addByPrefix('leaves', 'leaves', 24, true);
					caveLeaves.animation.play('leaves');
					caveLeaves.scrollFactor.set(0.96, 0.96);
					caveLeaves.setGraphicSize(Std.int(caveLeaves.width * daPixelZoom));
					add(caveLeaves);

					var caveFloor:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('cave/floor'));
					caveFloor.y -= 0;
					caveFloor.x -= 500;
					caveFloor.setGraphicSize(Std.int(caveFloor.width * 6.5));
					add(caveFloor);

					minijukebox = new FlxSprite(580, 540);
				    minijukebox.frames = Paths.getSparrowAtlas('mine/minijukebox');
					minijukebox.animation.addByPrefix('bop', 'minijukebox idle', 24, false);
					minijukebox.setGraphicSize(Std.int(minijukebox.width * 4.5));
					minijukebox.updateHitbox();
			 		add(minijukebox);


					caveBG.updateHitbox();
					caveFloor.updateHitbox();
					caveLeaves.updateHitbox();
			}
			case 'notch':
			{
					curStage = 'notch';

					defaultCamZoom = 0.7;
					camMovement = 0.2;

					var templeBG = new FlxSprite().loadGraphic(Paths.image('temple/templeBG'));
					templeBG.scrollFactor.set(0.1, 0.1);
					templeBG.y -= 250;
					templeBG.x -= 285;
					templeBG.setGraphicSize(Std.int(templeBG.width * 6.2));
					add(templeBG);

					var repositionShit = -200;

					var templeFloor:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('temple/floor'));
					templeFloor.y -= -35;
					templeFloor.x -= 1600;
					templeFloor.setGraphicSize(Std.int(templeFloor.width * 7));
					add(templeFloor);

					alecs = new FlxSprite(810, 100);
				    alecs.frames = Paths.getSparrowAtlas('temple/alexBG');
			 		alecs.animation.addByPrefix('bop', 'alexBG Idle', 24, false);
			 		alecs.setGraphicSize(Std.int(alecs.width * 6));
			 		alecs.updateHitbox();
			 		add(alecs);

					hors = new FlxSprite(1370, 50);
				    hors.frames = Paths.getSparrowAtlas('temple/horseBG');
			 		hors.animation.addByPrefix('bop', 'horseBG Idle', 24, false);
			 		hors.setGraphicSize(Std.int(hors.width * 6));
			 		hors.updateHitbox();
			 		add(hors);

					stev = new FlxSprite(-280, 120);
				    stev.frames = Paths.getSparrowAtlas('temple/steveBG');
			 		stev.animation.addByPrefix('bop', 'steveBG Idle', 24, false);
			 		stev.setGraphicSize(Std.int(stev.width * 6));
			 		stev.updateHitbox();
			 		add(stev);

					notchStanding = new FlxSprite(165, -70);
				    notchStanding.frames = Paths.getSparrowAtlas('temple/notchStanding');
					notchStanding.animation.addByPrefix('bop', 'notchStanding idle', 24, false);
					notchStanding.setGraphicSize(Std.int(notchStanding.width * 5.9));
					notchStanding.updateHitbox();
			 		add(notchStanding);

					templeBG.updateHitbox();
					templeFloor.updateHitbox();

			}
			case 'entity':
			{
					curStage = 'entity';

					defaultCamZoom = 0.85;
					camMovement = 1;

					var forest = new FlxSprite().loadGraphic(Paths.image('entity/forest'));
					forest.y -= 700;
					forest.x -= 1600;
					forest.setGraphicSize(Std.int(forest.width * 6));
					add(forest);

					forest.updateHitbox();
			}
			case 'templeentrance':
			{
					curStage = 'templeentrance';

					defaultCamZoom = 0.6;
					camMovement = 0.2;

					var repositionShit = -200;

					var templeentrance:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('templeentrance/templeentrance'));
					add(templeentrance);
					templeentrance.y -= 8500;
					templeentrance.x -= 200;

					gfminecraft = new FlxSprite(690, 55);
				    gfminecraft.frames = Paths.getSparrowAtlas('templeentrance/gfminecraft');
					gfminecraft.animation.addByPrefix('bop', 'gfminecraft Idle', 24, false);
					gfminecraft.setGraphicSize(Std.int(gfminecraft.width * 6));
					gfminecraft.updateHitbox();
			 			add(gfminecraft);

					templeentrance.setGraphicSize(Std.int(templeentrance.width * daPixelZoom));

					templeentrance.updateHitbox();
			}
			case 'fasttravel':
			{
					curStage = 'fasttravel';

					defaultCamZoom = 0.7;
					camMovement = 1.3;

					fasttravelbg = new FlxSprite().loadGraphic(Paths.image('fasttravel/fastTravelBg'));
					fasttravelbg.scale.set(1.4, 1.4);
					fasttravelbg.updateHitbox();
					add(fasttravelbg);

					bigmountian = new FlxSprite().loadGraphic(Paths.image('fasttravel/big_mountain'));
					bigmountian.scale.set(1.4, 1.4);
					bigmountian.updateHitbox();
					add(bigmountian);

					smallmountian = new FlxSprite().loadGraphic(Paths.image('fasttravel/small_mountian'));
					smallmountian.scale.set(1.4, 1.4);
					smallmountian.updateHitbox();
					add(smallmountian);

					fasttravelbgClone = new FlxSprite().loadGraphic(Paths.image('fasttravel/fastTravelBg'));
					fasttravelbgClone.scale.set(1.4, 1.4);
					fasttravelbgClone.updateHitbox();
					add(fasttravelbgClone);

					alexHorse = new FlxSprite(50, 55);
				    alexHorse.frames = Paths.getSparrowAtlas('fasttravel/alexHorse');
					alexHorse.animation.addByPrefix('bop', 'alexHorse idle', 24, false);
					alexHorse.scrollFactor.set(1, 1);
					alexHorse.scale.set(1.1, 1.1);
					alexHorse.setGraphicSize(Std.int(alexHorse.width * 5.6));
					alexHorse.updateHitbox();
			 		add(alexHorse);

					gfHorse = new FlxSprite(500, 100);
				    gfHorse.frames = Paths.getSparrowAtlas('fasttravel/gfHorse');
					gfHorse.animation.addByPrefix('bop', 'gfHorse idle', 24, false);
					gfHorse.scrollFactor.set(1, 1);
					gfHorse.setGraphicSize(Std.int(gfHorse.width * 6));
					gfHorse.updateHitbox();
			 		add(gfHorse);

					steveHorse = new FlxSprite(-300, 385);
				    steveHorse.frames = Paths.getSparrowAtlas('fasttravel/steveHorse');
					steveHorse.animation.addByPrefix('bop', 'steveHorse idle', 24, false); 
					steveHorse.scrollFactor.set(1, 1); 
					steveHorse.scale.set(1.1, 1.1);
					steveHorse.setGraphicSize(Std.int(steveHorse.width * 6));
					steveHorse.updateHitbox();
			 		add(steveHorse);

					fasttravelbg.updateHitbox();
					fasttravelbgClone.updateHitbox();

					scroll = true;

			}
			case 'littleman':
			{
					curStage = 'littleman';

					defaultCamZoom = 0.7;
					camMovement = 0.2;

					var repositionShit = -200;

					var littlebg:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('littleman/littlebg'));
					littlebg.scrollFactor.set(0.95, 0.95);
					add(littlebg);
					littlebg.y -= 220;
					littlebg.x -= 200;
					littlebg.setGraphicSize(Std.int(littlebg.width * daPixelZoom));

					littlebg.updateHitbox();

			}
			case 'tutorial':
			{
					curStage = 'tutorial';

					defaultCamZoom = 0.7;
					camMovement = 1;

					var repositionShit = -200;

					var tutorial:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('tutorial/tutorial'));
					tutorial.y -= 300;
					tutorial.x -= 370;
					tutorial.setGraphicSize(Std.int(tutorial.width * 7));
					add(tutorial);

					irfan = new FlxSprite(350, 150);
				    irfan.frames = Paths.getSparrowAtlas('tutorial/irfan');
					irfan.animation.addByPrefix('bop', 'irfan idle', 24, false);
					irfan.setGraphicSize(Std.int(irfan.width * 4.7));
					irfan.updateHitbox();
			 		add(irfan);

					tutorial.updateHitbox();

			}
			case 'tf2':
			{
					curStage = 'tf2';

					defaultCamZoom = 0.96;
					camMovement = 1;

					var repositionShit = -200;

					var tf2:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('tf2/tf2'));
					tf2.scrollFactor.set(0.95, 0.95);
					tf2.y += 450;
					tf2.x += 550;
					tf2.setGraphicSize(Std.int(tf2.width * 6.5));
					add(tf2);
			}
			case 'mcsm':
			{
					curStage = 'mcsm';

					defaultCamZoom = 0.96;
					camMovement = 0.2;

					var treehouse = new FlxSprite().loadGraphic(Paths.image('mcsm/treehouse'));
					treehouse.scrollFactor.set(0.95, 0.95);
					treehouse.y -= 175;
					treehouse.x -= 350;
					treehouse.setGraphicSize(Std.int(treehouse.width * 1.5));
					treehouse.antialiasing = true;
					add(treehouse);

					musicnotes = new FlxSprite(0, 0);
				    musicnotes.frames = Paths.getSparrowAtlas('mcsm/notes');
					musicnotes.animation.addByPrefix('bop', 'notes idle', 24, false);
					musicnotes.scrollFactor.set(0.95, 0.95);
					musicnotes.setGraphicSize(Std.int(musicnotes.width * 4.5));
					musicnotes.updateHitbox();
			 		add(musicnotes);
			}
			case 'lost':
			{
					curStage = 'lost';

					defaultCamZoom = 0.7;
					camMovement = 0.2;

					var repositionShit = -200;

					var lost:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('lost/lost'));
					lost.scrollFactor.set(0.95, 0.95);
					add(lost);
					lost.y -= 600;
					lost.x -= 200;
					lost.setGraphicSize(Std.int(lost.width * 8.5));

					lost.updateHitbox();

			}
			case 'espionage':
			{
					curStage = 'espionage';

					defaultCamZoom = 0.7;
					camMovement = 0.2;

					var repositionShit = -200;

					var espionage:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('espionage/espionage'));
					espionage.scrollFactor.set(0.95, 0.95);
					add(espionage);
					espionage.y -= 220;
					espionage.x -= 200;
					espionage.setGraphicSize(Std.int(espionage.width * daPixelZoom));

					espionage.updateHitbox();

			}
			case 'dev':
			{
					curStage = 'dev';

					defaultCamZoom = 0.96;
					camMovement = 0.2;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('devs/wall'));
					bgSky.scrollFactor.set(0.96, 0.96);
					bgSky.y -= 150;
					bgSky.x -= 200;
					add(bgSky);

					var repositionShit = -200;

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('devs/floor'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);

					bgSky.updateHitbox();
					bgStreet.updateHitbox();

					bgDevs = new BackgroundDevs(-100, 190);
					bgDevs.scrollFactor.set(0.9, 0.9);
					bgDevs.active = true;

					bgDevs.setGraphicSize(Std.int(bgDevs.width * daPixelZoom));
					bgDevs.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgDevs);
					}
			}
			case 'awwman':
				{
					curStage = 'awwman';
					defaultCamZoom = 0.9;
			    	var creeper:FlxSprite = new FlxSprite();
					creeper.frames = Paths.getSparrowAtlas('awwman/awwman', 'shared');
					creeper.animation.addByPrefix('idle', 'awwman stars', 24, true);
				    creeper.animation.play('idle');
					creeper.y -= 1000;
					creeper.x -= 200;
					creeper.scale.set(1.8, 1.8);
				    creeper.scrollFactor.set(0.9, 0.9);
			     	add(creeper);

					var repositionShit = -200;

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('awwman/floor'));
					add(bgStreet);

					var widShit = Std.int(creeper.width * 6);

					creeper.setGraphicSize(Std.int(widShit));
					bgStreet.setGraphicSize(widShit);

					creeper.updateHitbox();
					bgStreet.updateHitbox();

			}
			case 'diamonds':
			{
						curStage = 'diamonds';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('diamonds/stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('diamonds/stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
			}
			case 'stage':
				{						
						defaultCamZoom = 0.9;

						camMovement = 0.2;

						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
	
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'no-gf':
				gfVersion = 'no-gf';
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'steve-armor':
				dad.x -= 90;
				dad.y += 190;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'stevehorse':
				dad.x -= 200;
				dad.y -= 0;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'tuxsteveuoh':
				dad.x -= 140;
				dad.y += 200;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'tuxsteve':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'tuxstevewhatever':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'stevefnm':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'stevematt':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'stevelucky':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alex':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alexnormal':
				dad.x -= 100;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alexchill':
				dad.x -= 100;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alexsunday':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'notch':
				dad.x += 50;
				dad.y -= 70;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case '303':
				dad.x -= 180;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);

				//evilTrail = new FlxTrail(dad, null, 24, 60, 0.3, 0.069);
				//	// evilTrail.changeValuesEnabled(false, false, false, false);
				//	// evilTrail.changeGraphic()
				//add(evilTrail);

				//evilTrail.visible = false;
			case 'endless':
				dad.x -= 1100;
				dad.y -= 600;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'smollalex':
				dad.x -= 210;
				dad.y += 210;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alexpickaxe':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'alexpickaxemad':
				dad.x -= 140;
				dad.y += 240;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'herobrine':
				dad.x -= 90;
				dad.y += 230;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'tiago':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tiagoSwag':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'gabo':
				dad.x += 150;
				dad.y += 690;
			case 'jaziel':
				dad.x -= 140;
				dad.y += 150;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'bos':
				dad.x -= 140;
				dad.y += 60;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'irfan':
				dad.x -= 170;
				dad.y += 135;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'jesse':
				dad.x -= 300;
				dad.y += 0;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);
			case 'jeb':
				dad.x -= 90;
				dad.y -= 70;
				camPos.set(dad.getGraphicMidpoint().x + 310, dad.getGraphicMidpoint().y);		
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

			case 'house':
				boyfriend.x += 200;
				boyfriend.y += 215;
				gf.x += 240;
				gf.y += 400;
			case 'mine':
				boyfriend.x += 200;
				boyfriend.y += 215;
				gf.x += 180;
				gf.y += 340;				
			case 'cave':
				boyfriend.x += 200;
				boyfriend.y += 215;
				gf.x += 180;
				gf.y += 340;
			case 'notch':
				boyfriend.x += 520;
				boyfriend.y += 50;
				gf.x += 390;
				gf.y += 230;
			case 'entity':
				boyfriend.x += 500;
				boyfriend.y += 250;
				gf.x += 240;
				gf.y += 400;
			case 'endless':
				boyfriend.x += 520;
				boyfriend.y += 50;
				gf.x += 280;
				gf.y += 200;
			case 'littleman':
				boyfriend.x += 220;
				boyfriend.y += 20;
				gf.x += 240;
				gf.y += 170;
			case 'lost':
				boyfriend.x += 220;
				boyfriend.y += 20;
				gf.x += 240;
				gf.y += 170;
			case 'tutorial':
				boyfriend.x += 220;
				boyfriend.y += 20;
				gf.x += 240;
				gf.y += 170;
			case 'tf2':
				boyfriend.x += 85;
				boyfriend.y += 130;
				gf.x += 180;
				gf.y += 340;
			case 'mcsm':
				boyfriend.x -= 120;
				boyfriend.y -= 75;
				gf.x += 240;
				gf.y += 170;
			case 'espionage':
				boyfriend.x += 220;
				boyfriend.y += 75;
				gf.x += 240;
				gf.y += 170;
			case 'fasttravel':
				boyfriend.x += 210;
				boyfriend.y += 0;
				gf.x += 1000;
				gf.y += 1000;
			case 'templeentrance':
				boyfriend.x += 220;
				boyfriend.y += 100;
				gf.x += 240;
				gf.y += 230;
			case 'dev':
				boyfriend.x += 500;
				boyfriend.y -= 1;
				dad.x -= 185;
				dad.y -= 20;
			case 'awwman':
				boyfriend.x += 125;
				boyfriend.y += 230;
				gf.x += 180;
				gf.y += 340;
				dad.x += 20;
				dad.y -= 1000;
		}

		add(gf);

		if (curStage == 'mine' || curStage == 'cave' || curStage == 'espionage' || curStage == 'dev' || curStage == 'tutorial' || curStage == 'endless')
		{
			remove(gf);
		}

		add(dad);

		switch (SONG.song.toLowerCase())
		{
			case 'last craft':
				duoDad = new Character(10, 530, 'alexchill');
				add(duoDad);
				hasDuoDad = true;
		}
		if (curStage == 'notch' && SONG.song.toLowerCase() == 'gapple')
			remove(notchStanding);

		if (curStage == 'notch' && SONG.song.toLowerCase() == 'retired')
			remove(notchStanding);

		add(boyfriend);

		if (curStage == 'mine')
			{
				var grass:FlxSprite = new FlxSprite(-200).loadGraphic(Paths.image('mine/grass'));
					grass.scrollFactor.set(2, 1);
					grass.y += 390;
					grass.x += 580;
					grass.setGraphicSize(Std.int(grass.width * 5));
				add(grass);
			}

		if (curStage == 'cave')
		{
			var lanterns:FlxSprite = new FlxSprite(-200).loadGraphic(Paths.image('cave/lanterns'));
				lanterns.scrollFactor.set(2, 1);
				lanterns.y += 390;
				lanterns.x += 615;
				lanterns.setGraphicSize(Std.int(lanterns.width * 6.5));
			add(lanterns);
		}


		if (SONG.song.toLowerCase() == 'suit up')
		{
			achievementBlock = new FlxSprite(1100, 300);
			achievementBlock.frames = Paths.getSparrowAtlas('achievement/Block', 'shared');
			achievementBlock.animation.addByPrefix('Block', 'ACHD', 24, false);
			achievementBlock.antialiasing = false;
			achievementBlock.alpha = 0;
			achievementBlock.setGraphicSize(Std.int(achievementBlock.width * 2));

			add(achievementBlock);


			blackStuff = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 6, FlxG.height * 6, FlxColor.BLACK);
			blackStuff.scrollFactor.set();
			add(blackStuff);

			blackStuff.alpha = 0;

			whiteStuff = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 6, FlxG.height * 6, FlxColor.WHITE);
			whiteStuff.scrollFactor.set();
			add(whiteStuff);

			whiteStuff.alpha = 0;
		}


		hotbar = new FlxSprite();
		hotbar.frames = Paths.getSparrowAtlas('hotbar1');

		//FOR SONGS THAT USE SHIELD
		hotbar.animation.addByPrefix('Mic', 'MicSelALL', 24, false);
		hotbar.animation.addByPrefix('Shield', 'ShieldSelALL', 24, false);
		hotbar.animation.addByPrefix('Potion', 'PotionSelALL', 24, false);

		//FOR AFTER USING POTIOM IN SHIELD SONGS
		hotbar.animation.addByPrefix('MicNoPotion', 'MicSelNoPotion', 24, false);
		hotbar.animation.addByPrefix('ShieldNoPotion', 'ShieldSelNoPotion', 24, false);
		hotbar.animation.addByPrefix('PotionNoPotion', 'EmtpySelNoPotion', 24, false);

		//FOR MOSTLY ALL SONGS
		hotbar.animation.addByPrefix('MicNoShield', 'MicSelNoShield', 24, false);
		hotbar.animation.addByPrefix('ShieldNoShield', 'EmptyNoShield', 24, false);
		hotbar.animation.addByPrefix('PotionNoShield', 'PotionSelNoShield', 24, false);

		//FOR MOSTLY ALL SONGS AND AFTER USING POTION
		hotbar.animation.addByPrefix('MicNoSP', 'MicSelOnly', 24, false);
		hotbar.animation.addByPrefix('ShieldNoSP', 'EmptySNoSP', 24, false);
		hotbar.animation.addByPrefix('PotionNoSP', 'EmptyPNoSP', 24, false);
		
		hotbar.antialiasing = false;
		hotbar.setGraphicSize(Std.int(hotbar.width * 3));
		hotbar.screenCenter();
		hotbar.x += 575;
		hotbar.updateHitbox();
		hotbar.scrollFactor.set();
		hotbar.animation.play('MicNoShield', false);
		
		if(SONG.song.toLowerCase() == 'suit up')
			hotbar.animation.play('Mic', false);
		add(hotbar);

	


		if(SONG.song.toLowerCase() == 'espionage')
			{
				dad.alpha = 0;
			}
			
		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);

			FlxG.save.data.SpectatorMode = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);


		// DISABLED UNTIL HELP COMES
		//if(SONG.song.toLowerCase() == 'entity')
		//{
		//	var vgs:VideoGlitchShader;
		//	vgs = new VideoGlitchShader();
//
		//	camGame.setFilters([new ShaderFilter(vgs)]);
		//	camHUD.setFilters([new ShaderFilter(vgs)]);
		//}

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 25).loadGraphic(Paths.image('healthBarBGG'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);

				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				if(dad.curCharacter == 'notch')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#F5EE00'));
				else if(dad.curCharacter == 'tuxsteve' || dad.curCharacter == 'tuxsteveuoh' || dad.curCharacter == 'steve-armor' || dad.curCharacter == 'stevehorse' || dad.curCharacter == 'tuxstevewhatever')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#0055D6'));
				else if(dad.curCharacter == 'alex' || dad.curCharacter == 'alexnormal' || dad.curCharacter == 'alexchill' || dad.curCharacter == 'alexpickaxe' || dad.curCharacter == 'alexpickaxemad')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#9AFF9A'));
				else if(dad.curCharacter == 'irfan')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#32CD32'));
				else if(dad.curCharacter == 'jaziel')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF0000'));
				else if(dad.curCharacter == 'bos')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF8008'));
				else if(dad.curCharacter == '303')
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF0000'));
				else
					songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#03AAF9'));
				add(songPosBar);

				if (dad.curCharacter == '303')
					songPosXP = new FlxSprite(0, 25).loadGraphic(Paths.image('bossbarfront'));
				else 
					songPosXP = new FlxSprite(0, 25).loadGraphic(Paths.image('healthBar'));

				if (FlxG.save.data.downscroll)
					songPosXP.y = FlxG.height * 0.9 + 45; 
				songPosXP.screenCenter(X);
				songPosXP.alpha = 0.65;
				songPosXP.scrollFactor.set();
				add(songPosXP);

				var songName = new FlxText(songPosBG.x + 36, songPosBG.y - 30, 0, SONG.song, 20);
				songName.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				songName.screenCenter(X);
				songName.borderSize = 1.25;
				songName.antialiasing = false;
				add(songName);

				songName.cameras = [camHUD];
			}

		//OUTLINE SHIT
		healthBarBGG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarBGGLong'));
		if (FlxG.save.data.downscroll)
			healthBarBGG.y = 50;
		healthBarBGG.screenCenter(X);
		healthBarBGG.scrollFactor.set();

		add(healthBarBGG);


		//HEALTH BAR SHIT -- COLORS YK
		healthBar = new FlxBar(healthBarBGG.x + 4, healthBarBGG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBGG.width - 8), Std.int(healthBarBGG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
		// healthBar
		add(healthBar);

		//XP BAR SHIT
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarLong'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.alpha = 0.65;
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(5, healthBarBG.y + 45 ,0,SONG.song + " " + (storyDifficulty == 3 ? "Ultra Hardcore" : storyDifficulty == 2 ? "Hardcore" : storyDifficulty == 1 ? "Hard" : "Peaceful") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 20);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		kadeEngineWatermark.antialiasing = false;
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		//scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		//if (!FlxG.save.data.accuracyDisplay)
		//	scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		//scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		//scoreTxt.scrollFactor.set();
		//if (offsetTesting)
		//	scoreTxt.x += 300;
		//if(FlxG.save.data.SpectatorMode) 
		//scoreTxt.x = FlxG.width / 2 - 20;													  
		//add(scoreTxt);


		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);


		// idk how I SHOULD MAKE THIS WORK WITH THE SECOND HEALTHBAR BGG LMAOOOOO HELP
		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		SpectatorModeState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "", 20);
		SpectatorModeState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		SpectatorModeState.scrollFactor.set();

		if(FlxG.save.data.SpectatorMode && !loadRep) 
		add(SpectatorModeState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		
		if(SONG.song.toLowerCase() == 'entity')
		{
			dad.alpha = 0;
			vignette = new FlxSprite().loadGraphic(Paths.image('entity/vignette'));
			//vignette.setGraphicSize(Std.int(vignette.width * 6));
			vignette.alpha = 0;
			add(vignette);
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthBarBGG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		hotbar.cameras = [camHUD];

		if(SONG.song.toLowerCase() == 'entity')
			vignette.cameras = [camHUD];

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songPosXP.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'uoh':
					schoolIntro(doof);
				case 'craft away':
					schoolIntro(doof);
				case 'suit up':
					schoolIntro(doof);
				case 'whatever':
					schoolIntro(doof);
        /*
      	case 'overseen':
					schoolIntro(doof);
      	case 'iron picks':
					schoolIntro(doof);
		case 'copper':
					schoolIntro(doof);
        case 'underrated':
					schoolIntro(doof);
        case 'tick tock':
					schoolIntro(doof);
				*/
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'craft away' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	//var funnyNyomHappened = false;
	//public function funnyNyom() 
	//{
	//	if (funnyNyomHappened) return;
	//	funnyNyomHappened = true;
		//camHUD.alpha = 0;
//
		////doing some weird shit for Fancy HUD movement
		//healthBar.y += 200;
		//healthBarBG.y += 200;
		//healthBarBGG.y += 200;
		//iconP1.y += 200;
		//iconP2.y += 200;
		//scoreTxt.y += 200;
//
		//hotbar.x += 300;
//
		//songPosBG.y -= 400;
		//songPosBar.y -= 400;
		//songPosXP.y -= 400;
//
		//// this very dumb i think BUT HEY works nontheless
		//if (!isStoryMode)
		//{
		//	FlxTween.tween(healthBar, {y: healthBar.y -= 200}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(healthBarBG, {y: healthBarBG.y -= 200}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(healthBarBGG, {y: healthBarBGG.y -= 200}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(iconP1, {y: iconP1.y -= 200}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(iconP2, {y: iconP2.y -= 200}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(scoreTxt, {y: scoreTxt.y -= 200}, 2, {ease: FlxEase.backInOut});
////
		//	FlxTween.tween(songPosBG, {y: songPosBG.y += 400}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(songPosBar, {y: songPosBar.y += 400}, 2, {ease: FlxEase.backInOut});
		//	FlxTween.tween(songPosXP, {y: songPosXP.y += 400}, 2, {ease: FlxEase.backInOut});
//
		//	FlxTween.tween(hotbar, {x: hotbar.x -= 300}, 2, {ease: FlxEase.backInOut});
//
		//	FlxTween.tween(camHUD, {alpha: 1}, 0.4, {ease: FlxEase.backInOut, startDelay: 0.2});
		//}

	//	for (elem in [healthBar, iconP1, iconP2, scoreTxt, healthBarBG, healthBarBGG]) 
	//	{
	//		if (elem != null) {
	//			var oldElemY = elem.y;
	//			var oldAlpha = elem.alpha;
	//			elem.alpha = 0;
	//			FlxTween.tween(elem, {y : oldElemY, alpha : oldAlpha}, 0.75, {ease : FlxEase.quartInOut});
	//		}
	//		elem.visible = true;
	//	}

	//}


	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (hasDuoDad)
				duoDad.dance();
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['ready', "set", "go"]);
			introAssets.set('schoolevil', ['ready', "set", "go"]);
			introAssets.set('house', ['ready', "set", "go"]);
			introAssets.set('entity', ['ready', "set", "go"]);
			introAssets.set('mine', ['ready', "set", "go"]);
			introAssets.set('cave', ['ready', "set", "go"]);
			introAssets.set('notch', ['ready', "set", "go"]);
			introAssets.set('lost', ['ready', "set", "go"]);
			introAssets.set('tutorial', ['ready', "set", "go"]);
			introAssets.set('tf2', ['ready', "set", "go"]);
			introAssets.set('mcsm', ['ready', "set", "go"]);
			introAssets.set('espionage', ['ready', "set", "go"]);
			introAssets.set('fasttravel', ['ready', "set", "go"]);
			introAssets.set('templeentrance', ['ready', "set", "go"]);
			//introAssets.set('school', [
			//	'weeb/pixelUI/ready-pixel',
			//	'weeb/pixelUI/set-pixel',
			//	'weeb/pixelUI/date-pixel'
			//]);
			//introAssets.set('schoolEvil', [
			//	'weeb/pixelUI/ready-pixel',
			//	'weeb/pixelUI/set-pixel',
			//	'weeb/pixelUI/date-pixel'
			//]);
			//introAssets.set('awwman', [
			//	'awwman/pixelUI/ready-pixel',
			//	'awwman/pixelUI/set-pixel',
			//	'awwman/pixelUI/date-pixel'
			//]);
			//introAssets.set('house', [
			//	'house/pixelUI/ready-pixel',
			//	'house/pixelUI/set-pixel',
			//	'house/pixelUI/date-pixel'
			//]);
			//introAssets.set('entity', [
			//	'entity/pixelUI/ready-pixel',
			//	'entity/pixelUI/set-pixel',
			//	'entity/pixelUI/date-pixel'
			//]);
			//introAssets.set('mine', [
			//	'mine/pixelUI/ready-pixel',
			//	'mine/pixelUI/set-pixel',
			//	'mine/pixelUI/date-pixel'
			//]);	
			//introAssets.set('cave', [
			//	'cave/pixelUI/ready-pixel',
			//	'cave/pixelUI/set-pixel',
			//	'cave/pixelUI/date-pixel'
			//]);
			//introAssets.set('notch', [
			//	'temple/pixelUI/ready-pixel',
			//	'temple/pixelUI/set-pixel',
			//	'temple/pixelUI/date-pixel'			
			//]);
			//introAssets.set('lost', [
			//	'lost/pixelUI/ready-pixel',
			//	'lost/pixelUI/set-pixel',
			//	'lost/pixelUI/date-pixel'		
			//]);
			//introAssets.set('tutorial', [
			//	'tutorial/pixelUI/ready-pixel',
			//	'tutorial/pixelUI/set-pixel',
			//	'tutorial/pixelUI/date-pixel'		
			//]);
			//introAssets.set('tf2', [
			//	'tf2/pixelUI/ready-pixel',
			//	'tf2/pixelUI/set-pixel',
			//	'tf2/pixelUI/date-pixel'
			//]);	
			//introAssets.set('mcsm', [
			//	'mcsm/pixelUI/ready-pixel',
			//	'mcsm/pixelUI/set-pixel',
			//	'mcsm/pixelUI/date-pixel'		
			//]);
			//introAssets.set('espionage', [
			//	'espionage/pixelUI/ready-pixel',
			//	'espionage/pixelUI/set-pixel',
			//	'espionage/pixelUI/date-pixel'		
			//]);
			//introAssets.set('fasttravel', [
			//	'fasttravel/pixelUI/ready-pixel',
			//	'fasttravel/pixelUI/set-pixel',
			//	'fasttravel/pixelUI/date-pixel'		
			//]);
			//introAssets.set('templeentrance', [
			//	'templeentrance/pixelUI/ready-pixel',
			//	'templeentrance/pixelUI/set-pixel',
			//	'templeentrance/pixelUI/date-pixel'			
			//]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";
//
			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.setGraphicSize(Std.int(ready.width * 0.8));
					ready.y -= 300;

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);

				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					set.setGraphicSize(Std.int(set.width * 0.8));
					set.y -= 300;

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);

				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					go.setGraphicSize(Std.int(go.width * 0.8));

					go.updateHitbox();
					go.y -= 300;

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);

				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);

		//funnyNyom();
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songPosXP);
			remove(songName);

			songPosBG = new FlxSprite(0, 25).loadGraphic(Paths.image('healthBarBGG'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			if(dad.curCharacter == 'notch')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#F5EE00'));
			else if(dad.curCharacter == 'tuxsteve' || dad.curCharacter == 'tuxsteveuoh' || dad.curCharacter == 'steve-armor' || dad.curCharacter == 'stevehorse' || dad.curCharacter == 'tuxstevewhatever')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#0055D6'));
			else if(dad.curCharacter == 'alex' || dad.curCharacter == 'alexnormal' || dad.curCharacter == 'alexchill' || dad.curCharacter == 'alexpickaxe' || dad.curCharacter == 'alexpickaxemad')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#9AFF9A'));
			else if(dad.curCharacter == 'irfan')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#32CD32'));
			else if(dad.curCharacter == 'jaziel')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF0000'));
			else if(dad.curCharacter == 'bos')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF8008'));
			else if(dad.curCharacter == '303')
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#FF0000'));
			else
				songPosBar.createFilledBar(FlxColor.fromString('#3D3540'), FlxColor.fromString('#03AAF9'));

				
			add(songPosBar);

			if (dad.curCharacter == '303')
				songPosXP = new FlxSprite(0, 25).loadGraphic(Paths.image('bossbarfront'));
			else 
				songPosXP = new FlxSprite(0, 25).loadGraphic(Paths.image('healthBar'));

			
			if (FlxG.save.data.downscroll)
				songPosXP.y = FlxG.height * 0.9 + 45; 
			songPosXP.screenCenter(X);
			songPosXP.alpha = 0.65;
			songPosXP.scrollFactor.set();
			add(songPosXP);

			var songName = new FlxText(songPosBG.x + 36, songPosBG.y - 30, 0, SONG.song, 20);
			songName.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			songName.screenCenter(X);
			songName.borderSize = 1.25;
			songName.antialiasing = false;
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songPosXP.cameras = [camHUD];
			songName.cameras = [camHUD];
		}


		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end

		if (hasDuoDad && usesDuoDadChart) {
			var duoDadNoteData = duoDadSONG.notes;
			duoDadNotes = new FlxTypedGroup<Note>();
			for (section in duoDadNoteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1]);
					var gottaHitNote:Bool = section.mustHitSection;
					var daType = songNotes[3];
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					if (duoDadNotes.members.length > 0)
						oldNote = duoDadNotes.members[Std.int(duoDadNotes.members.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					swagNote.sustainLength = songNotes[2];
					duoDadNotes.add(swagNote);
				}
			}
		}

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			if (daSection == 58 && curSong.toLowerCase() == 'endless') SONG.noteStyle = 'Majin';

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];

				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daSection += 1;
			daBeats += 1;
		}


		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();

				case 'funkyArrows':
					babyArrow.loadGraphic(Paths.image('lost/pixelUI/funkyArrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();



				case 'hardcore-funkyArrows':
					babyArrow.loadGraphic(Paths.image('lost/pixelUI/funkyArrows-hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();


				case 'alex':
					babyArrow.loadGraphic(Paths.image('cave/pixelUI/alex-arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					babyArrow.updateHitbox();
					babyArrow.scrollFactor.set();

				case 'notch':
					babyArrow.loadGraphic(Paths.image('temple/pixelUI/notch-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					babyArrow.updateHitbox();
					babyArrow.scrollFactor.set();

				case 'hardcore-notch':
					babyArrow.loadGraphic(Paths.image('temple/pixelUI/notch-hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
					babyArrow.updateHitbox();
					babyArrow.scrollFactor.set();

				case 'Majin':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/Majin_Notes','week6'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();



				case 'devs':
					babyArrow.loadGraphic(Paths.image('devs/pixelUI/devs-arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();				

				case 'aww':
					babyArrow.loadGraphic(Paths.image('creeps/pixelUI/aww-arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();				


				case 'hardcore':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();



				case 'hardcore-alex':
					babyArrow.loadGraphic(Paths.image('cave/pixelUI/alex-hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();

				case 'hardcore-aww':
					babyArrow.loadGraphic(Paths.image('creeps/pixelUI/aww-hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();


				case 'hardcore-devs':
					babyArrow.loadGraphic(Paths.image('devs/pixelUI/devs-hardcore-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();




				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
					babyArrow.updateHitbox();
					babyArrow.scrollFactor.set();

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
					babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.backInOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.quadOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}


	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		floatvalue += 0.07;
		runvalue += 0.1;
		hero += 0.02;
		#if !debug
		perfectMode = false;
		#end


		if (detectAttack)
		{
			detectSpace();
		}
		if(SONG.song.toLowerCase() == 'suit up')
		{
		if (FlxG.keys.justPressed.SPACE)
		{
			boyfriend.playAnim('block', true);
			if(oneTimeUse == false)
				hotbar.animation.play('Shield', true);
			else
			   hotbar.animation.play('ShieldNoPotion', true);
			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				if(oneTimeUse == false)
					hotbar.animation.play('Mic', true);
				else
				   hotbar.animation.play('MicNoPotion', true);
			});
		}
		}
		

		if(SONG.song.toLowerCase() == 'entity')
		{
			cpuStrums.visible = false;
			oneTimeUse = true;
			hotbar.animation.play('MicNoSP', false);
			if (health > 0.03)
				health -= 0.0001;
		}

		if(SONG.song.toLowerCase() == 'espionage')
		{
			cpuStrums.visible = false;
		}

		if (SONG.song.toLowerCase() == 'practice')
		{
			hotbar.animation.play('MicNoSP', false);
			cpuStrums.visible = false;
			oneTimeUse = true;
		}

		if (SONG.song.toLowerCase() != 'practice' || SONG.song.toLowerCase() != 'entity')
		{
			
			if(FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.regenPotionBind)]) && oneTimeUse == false)
			{
				if(SONG.song.toLowerCase() == 'suit up')
					hotbar.animation.play('Potion', true);
				else 
					hotbar.animation.play('PotionNoShield', true);

				FlxG.sound.play(Paths.sound('misc/drink'), 0.75);
				Regen();
			}
		}
		
		/*
		UN-USED FOR THIS UPDATE
		if(FlxG.keys.justPressed.T && oneTimeUse == false || FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.strengthPotionBind)]) && oneTimeUse == false)
		{
			Strength();
		}
		*/

		if (dad.animation.curAnim.name == 'hit' || dad.animation.curAnim.name == 'prepare' || dad.animation.curAnim.name == 'bonk' || dad.animation.curAnim.name == 'unequipPickaxe' || dad.animation.curAnim.name == 'idle-alt')
		{
			if (dad.animation.finished)
			{
				dad.dance();
			}
		}

		if (boyfriend.animation.curAnim.name == 'block')
		{
			if (boyfriend.animation.finished)
			{
				boyfriend.playAnim('idle');
			}
		}

		if (FlxG.keys.justPressed.ONE && !FlxG.save.data.SpectatorMode)
			camHUD.visible = !camHUD.visible;

		if(FlxG.save.data.SpectatorMode)
			camHUD.visible = false;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				healthBarBGG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				healthBarBGG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			iconP1.animation.curAnim.curFrame = 3;
		}

		switch (curStage)
		{
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		if (curStage.startsWith('fasttravel') /*|| curStage.startsWith('school')*/)
		{
			//Horse Movement
			dad.y += Math.sin(floatvalue);
			dad.y += Math.cos(floatvalue);
			boyfriend.y += Math.sin(floatvalue);
			boyfriend.y += Math.cos(floatvalue);
			alexHorse.y += Math.sin(floatvalue);
			alexHorse.y += Math.cos(floatvalue);
			steveHorse.y += Math.sin(floatvalue);
			steveHorse.y += Math.cos(floatvalue);
			gfHorse.y += Math.sin(floatvalue);
			gfHorse.y += Math.cos(floatvalue);
			dad.x += Math.sin(runvalue);
			boyfriend.x += Math.sin(runvalue);
			alexHorse.x += Math.sin(runvalue);
			steveHorse.x += Math.sin(runvalue);
			gfHorse.x += Math.sin(runvalue);

			//Panoramaaaaaaa
			//litterally basically a copy paste from the main menu but FU-
			//if (scroll == true)
			//	{
			//		scroll = false;
			//		fasttravelbgClone.x = 1280;
			//		fasttravelbg.x = 0;
			//		//pano.visible = false;
			//		FlxTween.tween(fasttravelbg, {x: -1600}, 10, {
			//		onComplete: function(twn:FlxTween)
			//	{
			//		tween = FlxTween.tween(fasttravelbg, { x: -2880 }, 10);
			//		FlxTween.tween(fasttravelbgClone, {x: 0}, 10, {
			//		onComplete: function(twn:FlxTween)
			//	{
			//		tween.cancel();
			//		scroll = true;
			//	}
			//});
			//	}
			//});
			//	}

			new FlxTimer().start(2, function(swagTimer:FlxTimer)
			{
			});
			

		}

		if (dad.curCharacter == "herobrine")
		{
			dad.y += Math.sin(hero);
		}
		//iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		//iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		//iconP1.updateHitbox();
		//iconP2.updateHitbox();


		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		//iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		//iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		if (health > 2)
			health = 2;
		
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else if (healthBar.percent > 80)
			iconP1.animation.curAnim.curFrame = 2;
		else
			iconP1.animation.curAnim.curFrame = 0;

		

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else if (healthBar.percent < 20)
			iconP2.animation.curAnim.curFrame = 2;
		else
			iconP2.animation.curAnim.curFrame = 0;



		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
					}
				}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				camFollow.setPosition(dad.getMidpoint().x + 150 + dadnoteMovementXoffset, dad.getMidpoint().y - 100 + offsetY + dadnoteMovementYoffset);
				
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
						case 'tuxsteveuoh':
							camFollow.y = dad.getMidpoint().y - 175;
							camFollow.x = dad.getMidpoint().x - -250;
							defaultCamZoom = 0.6;

						case 'tuxsteve':
							camFollow.y = dad.getMidpoint().y - 300;
							camFollow.x = dad.getMidpoint().x - -300;
							defaultCamZoom = 0.5;

						case 'tuxstevewhatever':
							camFollow.y = dad.getMidpoint().y - 300;
							camFollow.x = dad.getMidpoint().x - -300;
							defaultCamZoom = 0.5;

						case 'stevehorse':
							camFollow.y = dad.getMidpoint().y - 200;
							camFollow.x = dad.getMidpoint().x - -170;
							defaultCamZoom = 0.7;

						case '303':
							camFollow.y = dad.getMidpoint().y - 300 + dadnoteMovementYoffset;
							camFollow.x = dad.getMidpoint().x - 0 + dadnoteMovementXoffset;
							defaultCamZoom = 0.5;

						case 'alex':
							camFollow.y = dad.getMidpoint().y - 140;
							camFollow.x = dad.getMidpoint().x - -300;
							defaultCamZoom = 0.7;
		
						case 'alexnormal':
							camFollow.y = dad.getMidpoint().y - 140;
							camFollow.x = dad.getMidpoint().x - 0;
							defaultCamZoom = 0.85;

						case 'alexchill':
							camFollow.y = dad.getMidpoint().y - 140;
							camFollow.x = dad.getMidpoint().x - 0;
							defaultCamZoom = 0.8;

						case 'alexpickaxe':
							camFollow.y = dad.getMidpoint().y - 140;
							camFollow.x = dad.getMidpoint().x - -300;
							defaultCamZoom = 0.8;

						case 'alexpickaxemad':
							camFollow.y = dad.getMidpoint().y - 140;
							camFollow.x = dad.getMidpoint().x - -300;
							defaultCamZoom = 0.7;

						case 'notch':
							camFollow.y = dad.getMidpoint().y - 120 + dadnoteMovementYoffset;
							camFollow.x = dad.getMidpoint().x - -125 + dadnoteMovementXoffset;
							defaultCamZoom = 0.7;

						case 'steve-armor':
							camFollow.y = dad.getMidpoint().y - 260;
							camFollow.x = dad.getMidpoint().x - -140;
							defaultCamZoom = 0.7;              
						
						case 'jaziel':
							camFollow.y = dad.getMidpoint().y - 100;
							camFollow.x = dad.getMidpoint().x - -200;
							defaultCamZoom = 0.6;

						case 'bos':
                            camFollow.y = dad.getMidpoint().y - 100 + dadnoteMovementYoffset;
                            camFollow.x = dad.getMidpoint().x - -300 + dadnoteMovementXoffset;
                            defaultCamZoom = 0.7;

						case 'jesse':
							camFollow.y = dad.getMidpoint().y - 100 + dadnoteMovementYoffset;
							camFollow.x = dad.getMidpoint().x - -160 + dadnoteMovementXoffset;
                            defaultCamZoom = 0.7;
						
						case 'irfan':
                            camFollow.y = dad.getMidpoint().y - 100 + dadnoteMovementYoffset;
                            camFollow.x = dad.getMidpoint().x - 70 + dadnoteMovementXoffset;
                            defaultCamZoom = 0.6;

						case 'jeb':
							camFollow.y = dad.getMidpoint().y - 120 + dadnoteMovementYoffset;
							camFollow.x = dad.getMidpoint().x - -420 + dadnoteMovementXoffset;
							defaultCamZoom = 0.8;
				}

			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX + bfnoteMovementXoffset, boyfriend.getMidpoint().y - 100 + offsetY + bfnoteMovementYoffset);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 210;
						defaultCamZoom = 0.9;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
						defaultCamZoom = 1.2;
					case 'house':
						camFollow.x = boyfriend.getMidpoint().x - 280;
						camFollow.y = boyfriend.getMidpoint().y - 350;
						defaultCamZoom = 0.55;
					case 'mine':
						camFollow.x = boyfriend.getMidpoint().x - 280;
						camFollow.y = boyfriend.getMidpoint().y - 240;
						defaultCamZoom = 0.9;
					case 'cave':
						camFollow.x = boyfriend.getMidpoint().x - 280;
						camFollow.y = boyfriend.getMidpoint().y - 240;
						defaultCamZoom = 0.8;
					case 'notch':
						camFollow.x = boyfriend.getMidpoint().x - 320 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 200 + bfnoteMovementYoffset;
						defaultCamZoom = 0.9;
					case 'entity':
						camFollow.x = boyfriend.getMidpoint().x - 280 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 350 + bfnoteMovementYoffset;
						defaultCamZoom = 0.55;
					case 'templeentrance':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 260;
						defaultCamZoom = 0.9;
					case 'littleman':
						camFollow.x = boyfriend.getMidpoint().x - 400;
						camFollow.y = boyfriend.getMidpoint().y - 360;
						defaultCamZoom = 0.9;
					case 'lost':
						camFollow.x = boyfriend.getMidpoint().x - 400 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 305 + bfnoteMovementYoffset;
						defaultCamZoom = 0.9;
					case 'tutorial':
						camFollow.x = boyfriend.getMidpoint().x - 400 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 400 + bfnoteMovementYoffset;
						defaultCamZoom = 0.7;
					case 'tf2':
						camFollow.x = boyfriend.getMidpoint().x - 280 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 350 + bfnoteMovementYoffset;
						defaultCamZoom = 0.7;
					case 'mcsm':
						camFollow.x = boyfriend.getMidpoint().x - 75 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 150 + bfnoteMovementYoffset;
						defaultCamZoom = 0.7;
					case 'espionage':
						camFollow.x = boyfriend.getMidpoint().x - 300 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 300 + bfnoteMovementYoffset;
						defaultCamZoom = 1;
					case 'fasttravel':
						camFollow.x = boyfriend.getMidpoint().x - 400 + bfnoteMovementXoffset;
						camFollow.y = boyfriend.getMidpoint().y - 260 + bfnoteMovementYoffset;
						defaultCamZoom = 0.8;
					case 'dev':
						camFollow.x = boyfriend.getMidpoint().x - 650;
						camFollow.y = boyfriend.getMidpoint().y - 350;
						defaultCamZoom = 1.2;
					case 'awwman':
						camFollow.x = boyfriend.getMidpoint().x - 265;
						camFollow.y = boyfriend.getMidpoint().y - 340;
						defaultCamZoom = 1.4;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;

					vocals.stop();
					FlxG.sound.music.stop();

					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end

					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}
		if (mashViolations > 12)
		{
			defaultCamZoom = 0.6;
			boyfriend.stunned = true;
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
			trace('KICK');

			vocals.stop();
			FlxG.sound.music.stop();
			openSubState(new SpammingSubState());

			#if windows
			// Kickked doesn't get his own variable because it's only used here
			DiscordClient.changePresence("KICKED FOR SPAMMING -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

					if (!daNote.modifiedByLua)
					{
						if (FlxG.save.data.downscroll)
						{
							if (daNote.mustPress)
								daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
							else
								daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
							if(daNote.isSustainNote)
							{
								// Remember = minus makes notes go up, plus makes them go down
								if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
									daNote.y += daNote.prevNote.height;
								else
									daNote.y += daNote.height / 2;

								// If not in SpectatorMode, only clip sustain notes when properly hit, SpectatorMode gets to clip it everytime
								if(!FlxG.save.data.SpectatorMode)
								{
									if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
									{
										// Clip to strumline
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;

										daNote.clipRect = swagRect;
									}
								}else {
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}else
						{
							if (daNote.mustPress)
								daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
							else
								daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
							if(daNote.isSustainNote)
							{
								daNote.y -= daNote.height / 2;

								if(!FlxG.save.data.SpectatorMode)
								{
									if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
									{
										// Clip to strumline
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;

										daNote.clipRect = swagRect;
									}
								}else {
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
						}
					}

					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";

						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						if (dad.animation.curAnim.name != 'hit' || dad.animation.curAnim.name != 'prepare' || dad.animation.curAnim.name != 'bonk' || dad.animation.curAnim.name != 'unequipPickaxe' || dad.animation.curAnim.name == 'idle-alt')
							{
								switch (Math.abs(daNote.noteData))
								{
									case 2:
										dad.playAnim('singUP' + altAnim, true);
										dadnoteMovementYoffset = -40;
										dadnoteMovementXoffset = 0;
									case 3:
										dad.playAnim('singRIGHT' + altAnim, true);
										dadnoteMovementXoffset = 40;
										dadnoteMovementYoffset = 0;	
									case 1:
										dad.playAnim('singDOWN' + altAnim, true);
										dadnoteMovementYoffset = 40;
										dadnoteMovementXoffset = 0;
									case 0:
										dad.playAnim('singLEFT' + altAnim, true);
										dadnoteMovementXoffset = -40;
										dadnoteMovementYoffset = 0;
								}
							}

						cpuStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							spr.centerOffsets();
						});


						var daSprite = dad;
							switch (daNote.noteType)
							{
								case 10:
									daSprite = duoDad;
							}

						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;

						if (SONG.needsVoices)
							vocals.volume = 1;

						daNote.active = false;

						if (dad.curCharacter == '303')
						{
							if (healthBar.percent > 20)
							{
								daNote.kill();
								notes.remove(daNote, true);
								if (daNote.noteType == 5)
									GappleEffect();
								daNote.destroy();
								health -= 0.0002;
							}
							else (healthBar.percent < 20);
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
						else if (dad.curCharacter == 'tuxsteveuoh' || dad.curCharacter == 'alexchill' || dad.curCharacter == 'smollalex')
						{

							if (healthBar.percent > 20)
							{
								daNote.kill();
								notes.remove(daNote, true);
								if (daNote.noteType == 5)
									GappleEffect();
								daNote.destroy();
								health -= 0.010;
							}
							else (healthBar.percent < 20);
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
						else if (dad.curCharacter == 'tuxsteve' || dad.curCharacter == 'notch' || dad.curCharacter == 'alexpickaxe' || dad.curCharacter == 'tiago' || dad.curCharacter == 'jeb')
						{

							if (healthBar.percent > 20)
							{
								daNote.kill();
								notes.remove(daNote, true);
								if (daNote.noteType == 5)
									GappleEffect();
								daNote.destroy();
								health -= 0.020;
							}
							else (healthBar.percent < 20);
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
						else if (dad.curCharacter == 'alex' || dad.curCharacter == 'steve-armor' || dad.curCharacter == 'tiagoswag' || dad.curCharacter == 'bos' || dad.curCharacter == 'jaziel' || dad.curCharacter == 'irfan'  )
						{

							if (healthBar.percent > 20)
							{
								daNote.kill();
								if (daNote.noteType == 5)
									GappleEffect();
								notes.remove(daNote, true);
								daNote.destroy();
								health -= 0.030;
							}
							else (healthBar.percent < 20);
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}
						else
						{
							if (healthBar.percent > 20)
							{
								daNote.kill();
								if (daNote.noteType == 5)
									GappleEffect();
								notes.remove(daNote, true);
								daNote.destroy();
								health -= 0.025;
							}
							else (healthBar.percent < 20);
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						}

					}
					if (daNote.mustPress && !daNote.modifiedByLua)
						{
							daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (daNote.isSustainNote)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
						}
						else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
						{
							daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (daNote.isSustainNote)
							{
								if (executeModchart)
									daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
						}



					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 13;


					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							health += 0.005;
							
						}
						else if(storyDifficulty == 2)
						{
							if (daNote.noteType == 2 || daNote.noteType == 3)
							{
								vocals.volume = 1;
							}
							else
								{
								if (!daNote.isSustainNote)
									health -= 0.1;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
								}
						
						}
						else if(storyDifficulty == 3)
						{
							if (daNote.noteType == 2 || daNote.noteType == 3)
							{
								vocals.volume = 1;
							}
							else
							{
							if (!daNote.isSustainNote)
								health -= 0.25;

							vocals.volume = 0;
							if (theFunne)
								noteMiss(daNote.noteData, daNote);		
							}
							
						}
						else 
						{
							if (daNote.noteType == 2 || daNote.noteType == 3)
							{
								vocals.volume = 1;
							}
							else
							{
								if (!daNote.isSustainNote)
									health -= 0.025;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
						}

						daNote.active = false;
						daNote.visible = false;
						notes.remove(daNote, true);
					}
				});
			}


		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished)
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});


		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.SpectatorMode = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-peaceful';

					if (storyDifficulty == 2)
						difficulty = '-hardcore';

					if (storyDifficulty == 3)
						difficulty = '-ultrahardcore';

					trace('LOADING NEXT SONG');

					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);


					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
					//disabled this cuz it just doesnt work -- never mind

					//i need help
					//help
					/*switch (SONG.song.toLowerCase())
					{
						case 'suit up':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/armorsteve.webm", new PlayState()));
						
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}*/
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;

			var placement:String = Std.string(combo);

			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//

			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.02;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;

				case 'bad':
					if (daNote.noteType == 2)
					{
						PoisonDrain();
					}
					else if (daNote.noteType == 3)
					{
						WitherDrain();
					}
					else
					{
						daRating = 'bad';
						score = 0;
						health -= 0.01;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;	
					}

				case 'good':
					if (daNote.noteType == 2)
					{
						PoisonDrain();					
					}
					else if (daNote.noteType == 3)
					{
						WitherDrain();
					}
					else 
					{
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (SONG.song.toLowerCase() == 'entity')
							health += 0.002;
						else if (health < 2)
							health += 0.02;
						else if (health < 2 && storyDifficulty == 2)
							health += 0.01;
						else if (health < 2 && storyDifficulty == 3)
							health += 0.005;


						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}

				case 'sick':
					if (daNote.noteType == 2)
					{
						PoisonDrain();
					}
					else if (daNote.noteType == 3)
					{
						WitherDrain();
					}
					else
					{
						if (SONG.song.toLowerCase() == 'entity')
							health += 0.005;
						else if (health < 2)
							health += 0.04;
						else if (health < 2 && storyDifficulty == 2)
							health += 0.01;

						else if (health < 2 && storyDifficulty == 3)
							health += 0.005;
				
							


						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;	
					}

			}
				// FROM PSYCH ENINGE BUT MODIFIED
				if(scoreTxTMovement != null) {
					scoreTxTMovement.cancel();
				}
				scoreTxt.scale.x = 1.05;
				scoreTxt.scale.y = 1.05;
				scoreTxTMovement = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.25, {
					onComplete: function(twn:FlxTween) {
						scoreTxTMovement = null;
					}
				});


			if (daRating != 'shit' || daRating != 'bad')
			{





			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';


			pixelShitPart1 = 'hudassets/';
			pixelShitPart2 = '-pixel';

			//if (curStage.startsWith('school'))
			//{
			//	pixelShitPart1 = 'weeb/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('house'))
			//{
			//	pixelShitPart1 = 'house/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('entity'))
			//{
			//	pixelShitPart1 = 'entity/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('cave'))
			//{
			//	pixelShitPart1 = 'cave/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('mine'))
			//{
			//	pixelShitPart1 = 'mine/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('awwman'))
			//{
			//	pixelShitPart1 = 'awwman/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('devs'))
			//{
			//	pixelShitPart1 = 'devs/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('notch'))
			//{
			//	pixelShitPart1 = 'temple/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('littleman'))
			//	{
			//		pixelShitPart1 = 'littleman/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('lost'))
			//	{
			//		pixelShitPart1 = 'lost/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('tutorial'))
			//	{
			//		pixelShitPart1 = 'tutorial/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('tf2'))
			//{
			//	pixelShitPart1 = 'tf2/pixelUI/';
			//	pixelShitPart2 = '-pixel';
			//}
			//if (curStage.startsWith('mcsm'))
			//	{
			//		pixelShitPart1 = 'mcsm/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('espionage'))
			//	{
			//		pixelShitPart1 = 'espionage/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('fasttravel'))
			//	{
			//		pixelShitPart1 = 'fasttravel/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}
			//if (curStage.startsWith('templeentrance'))
			//	{
			//		pixelShitPart1 = 'templeentrance/pixelUI/';
			//		pixelShitPart2 = '-pixel';
			//	}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.SpectatorMode) 
				msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.WHITE;
				case 'sick':
					currentTimingShown.color = FlxColor.WHITE;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;



				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2)); 
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);


			//currentTimingShown.updateHitbox();
			//comboSpr.updateHitbox();
			//rating.updateHitbox();
			if (curStage.startsWith('stage'))
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.8));
				rating.antialiasing = false;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 1.2));
				comboSpr.antialiasing = false;
			}			
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.8));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 1.2));
			}
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();

			//currentTimingShown.cameras = [camHUD];
			//comboSpr.cameras = [camHUD];
			//rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 1)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				//numScore.cameras = [camHUD];

				if (curStage.startsWith('stage'))
				{
					numScore.antialiasing = false;
					numScore.setGraphicSize(Std.int(numScore.width * 1.0));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 1 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.1, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.0025
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.1, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end

				// Prevent player input if SpectatorMode is on
				if(FlxG.save.data.SpectatorMode)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}

				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;

					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later

					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (directionList.contains(daNote.noteData))
							{
								for (coolNote in possibleNotes)
								{
									if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
									{ // if it's the same note twice at < 10ms distance, just delete it
										// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
										dumbNotes.push(daNote);
										break;
									}
									else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
									{ // if daNote is earlier than existing note (coolNote), replace
										possibleNotes.remove(coolNote);
										possibleNotes.push(daNote);
										break;
									}
								}
							}
							else
							{
								possibleNotes.push(daNote);
								directionList.push(daNote.noteData);
							}
						}
					});

					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}

					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.SpectatorMode)
					{
						if (mashViolations > 4)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
							trace('Warned For Spamming');
							//do the spamming state and spamming assets tommorow or smth

							// basically kill/kick bf for spamming, make a menu for that, and send to main menu
							// open KickedMenuu.hx make it work like MainMenuState.hx mixed with GameoverState.hx
							// Minecraft background with text and buttons to go back
							mashViolations++;
						}
						else
							mashViolations++;
					}

				}

				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.SpectatorMode && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.SpectatorMode && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}
							else if (daNote.noteType == 0 || daNote.noteType == 1) {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});

				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.SpectatorMode))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}

				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
					//dumbass pixel shit offset
					//fucking bullshit but works LOL
					spr.centerOffsets();

				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.03;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			FlxG.sound.play(Paths.soundRandom('misc/hit', 1, 3), 0.75);
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.curAnim.name != 'block')
			{
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
				}
			}
			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */

			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));

				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;
					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}


		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if(SONG.song.toLowerCase() != 'entity')
					if (note.noteType == 0 || note.noteType == 1 )
					health += 0.0175;


				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;

					if (boyfriend.animation.curAnim.name != 'block')
					{
						switch (note.noteData)
						{
							case 2:
								bfnoteMovementYoffset = -40;
								bfnoteMovementXoffset = 0;
								boyfriend.playAnim('singUP', true);
							case 3:
								bfnoteMovementXoffset = 40;
								bfnoteMovementYoffset = 0;
								boyfriend.playAnim('singRIGHT', true);
							case 1:
								bfnoteMovementYoffset = 40;
								bfnoteMovementXoffset = 0;
								boyfriend.playAnim('singDOWN', true);
							case 0:
								bfnoteMovementXoffset = -40;
								bfnoteMovementYoffset = 0;
								boyfriend.playAnim('singLEFT', true);
						}
					}

					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));

					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});

					note.wasGoodHit = true;
					vocals.volume = 1;

					note.kill();
					notes.remove(note, true);
					note.destroy();

					updateAccuracy();
				}
			}


		var healthLost:Float = 0;


		function PoisonDrain():Void
		{
			if(storyDifficulty == 2)
				healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), 0xFF66298C);
			else
				healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), 0xFF2B4505);
			new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
			{
				if(!paused)
				{
					health -= 0.05;
					healthLost += 0.05;
				}
				
				if (healthLost < 0.75)
				{
					swagTimer.reset();
				}
				else if (health < 0.1)
				{
					healthLost = 0;
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
				}
				else 
				{
					healthLost = 0;
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
				}

			});

		}
		function WitherDrain():Void
		{
			healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), 0xFF3e0707);
			new FlxTimer().start(0.75, function(swagTimer:FlxTimer)
			{
				if(!paused)
				{
				health -= 0.125;
				healthLost += 0.125;
				}
				if (healthLost < 1.75)
				{
					swagTimer.reset();
				}
				else
				{
					healthLost = 0;
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));

				}
			});
		}

		var oneTimeUse:Bool = false;
		var healthGain:Float = 0;

		function Regen():Void
		{
			oneTimeUse = true;
			healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), 0xFFFF75A7);

			new FlxTimer().start(0.0075, function(swagTimer:FlxTimer)
			{
				if(!paused)
				{
					health += 0.0005;
					healthGain += 0.0005;
				}
				
				if (healthGain < 2)
				{
					swagTimer.reset(); 
				}
				else
				{
					healthGain = 0;
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));

				}
			});

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					if(SONG.song.toLowerCase() == 'suit up')
				   		hotbar.animation.play('MicNoPotion', true);
					else
						hotbar.animation.play('MicNoSP', true);
				});
		}

			
		
		function Strength():Void
			{
				oneTimeUse = true;
				strengthActive = true;
				trace('StrengthActive is ' + strengthActive);
				healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), 0xFFA50000);
				new FlxTimer().start(30, function(swagTimer:FlxTimer)
				{
					strengthActive = false;
					trace('StrengthActive is ' + strengthActive);
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
				});
			}



		var gappleActivated:Bool = false;

		function GappleEffect():Void
		{
			healthBar.createFilledBar(0xFFEAD127, FlxColor.fromString('#' + boyfriend.iconColor));
			health -= 0.25;
			gappleActivated = true;
			new FlxTimer().start(2, function(gapple:FlxTimer)
				{
					
					if(gappleActivated = true)
						gapple.reset();
					else
					{
						gappleActivated = false;
						healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));	
					}
				}
			);
		}

		

		function blockFail()
		{
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				boyfriend.playAnim('singDOWNmiss', true);
				FlxG.sound.play(Paths.soundRandom('misc/hit', 1, 3), 0.75);
				if (health > 1)
				{
					health -= 0.4;
				}
				else
				{
					health -= 0.20;
				}	
				
			});
			FlxG.camera.shake(0.05, 0.05);

		}

		function bfBlock()
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				boyfriend.playAnim('block', true);
				if(oneTimeUse == false)
					hotbar.animation.play('Shield', true);
				else
				   hotbar.animation.play('ShieldNoPotion', true);
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					if(oneTimeUse == false)
						hotbar.animation.play('Mic', true);
					else
					   hotbar.animation.play('MicNoPotion', true);
				});
			}
		
		}
		
		function blackFade()
		{
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				blackStuff.alpha += 0.075;
	
				if (blackStuff.alpha < 1)
				{
					tmr.reset(0.01);
				}
				else
				{
				remove(dad);
				dad = new Character(100 - 90, 100 + 190, 'steve-armor');
				add(dad);
				}
		
			});
		}

		function whiteFade()
		{
			whiteStuff.alpha = 1;
			new FlxTimer().start(0.001, function(tmr:FlxTimer)
			{
				whiteStuff.alpha -= 0.05;
	
				if (whiteStuff.alpha > 0)
				{
					tmr.reset(0.001);
				}

			});
		}

		function steveAttack()
		{
			dad.playAnim("hit", true);
		}
		function stevePrepare()
		{
			dad.playAnim("prepare", true);
		}

		function alexUnequip()
		{
			dad.playAnim("unequipPickaxe", true);
		}

		var pressedSpace:Bool = false;

		function slashEvent()
		{
			trace('prepare to slash');
			blockWarning();
			achievementBlock.animation.play('block', true);
			pressedSpace = false;
			detectAttack = true;
			//steveAttack(); needs pre pare
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				if (pressedSpace)
				{
					bfBlock();
					trace('Successful Block');
					FlxG.camera.shake(0.02, 0.02);
					FlxG.sound.play(Paths.soundRandom('blocking/block', 1, 5), 0.8);
				}
				else
				{
					pressedSpace = false;
					detectAttack = false;
					blockFail();
					trace('Haha, hit');
				}
			});
		}


		function blockWarning()
		{
			pressCounter = 0;
			achievementBlock.alpha = 1;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				achievementBlock.alpha = 0;
			});
		}

		var pressCounter = 0;

		function detectSpace()
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				pressCounter += 1;
				trace('tap');
				pressedSpace = true;
				detectAttack = false;
			}
		}



		function bonkAnim()
		{
			dad.playAnim('bonk', true);		
		}

		function bonkEvent()
		{
			if (health > 0.45)
				health -= 0.45;
			else 
				health -= 0.2;
			boyfriend.playAnim('singDOWNmiss', true);
			FlxG.camera.shake(0.025, 0.025);
		}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if(SONG.song.toLowerCase() == 'entity')
		{
			switch (curStep)
			{

				case 566:
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
						{
							dad.alpha += 0.01;
				
							if (dad.alpha < 1)
							{
								tmr.reset(0.001);
							}
						});
					//evilTrail.visible = true;


				case 686 | 1008 | 1086 | 1102 | 1116 | 1214 | 1232 | 1248 | 1342 | 1358 | 1374 | 1406 | 1422 | 1438 | 1470 | 1486 | 1502 | 1550 | 1566 | 1790 | 2046:
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						vignette.alpha += 0.015;
						FlxG.camera.zoom += 0.035;
						if (vignette.alpha < 1)
						{
							tmr.reset(0.001);
						}
					});

				case 694 | 1016 | 1094 | 1112 | 1126 | 1226 | 1242 | 1260 | 1354 | 1370 | 1386 | 1418 | 1434 | 1450 | 1482 | 1498 | 1514 | 1562 | 1578 | 1802 | 2058:
					new FlxTimer().start(0.001, function(tmr:FlxTimer)
					{
						vignette.alpha -= 0.0225;
						//FlxG.camera.zoom -= 0.025;
						if (vignette.alpha != 0)
						{
							tmr.reset(0.001);
						}
					});

				}			
		}

		if(SONG.song.toLowerCase() == 'espionage')
			{
				switch (curStep)
				{
	
					case 64:
						new FlxTimer().start(0.001, function(tmr:FlxTimer)
							{
								dad.alpha += 0.01;
					
								if (dad.alpha < 1)
								{
									tmr.reset(0.001);
								}
							});
					}			
			}
	
		if (SONG.song.toLowerCase() == 'iron picks') 
		{
			switch (curStep)
			{
				case 1407:
					remove(dad);
					dad = new Character(100, 100, 'alexpickaxemad');
					add(dad);
			}
		}


		if (SONG.song.toLowerCase() == 'espionage')
		{
			switch (curStep)
			{
				//lazy and dumb but gets the job done
				case 64 | 68 | 72 | 76 | 80 | 84 | 88 | 92 | 96 | 100 | 104 | 108 | 112 | 116 | 120:
					dad.playAnim('idle-alt', true);
					trace('playing alt anim');
			}
		}

		if (SONG.song.toLowerCase() == 'practice')
		{
			switch (curStep)
			{
				case 516 | 524 | 532 | 540 | 548 | 556 | 564 | 572 | 580 | 588 | 596 | 604 | 612 | 620 | 628 | 636:
					gf.playAnim('hey', true);
			}
		}

		if (SONG.song.toLowerCase() == 'whatever')
		{
			switch (curStep)
			{
				case 392 | 408 | 424 | 440 | 456 | /*hey in note*/ 472 | /*hey in note*/ 488 | /*hey in note*/ 504 | 520 | 536 | 552 | 568:
					boyfriend.playAnim('hey', true);
					gf.playAnim('hey', true);

				
				case 1416 | 1432 | 1448 | 1464 | 1480 | 1496 | 1512 | 1528:
					boyfriend.playAnim('hey', true);
					gf.playAnim('hey', true);

				case 1544:
						boyfriend.playAnim('hey', true);
						gf.playAnim('hey', true);
 
			}
		}

		if (SONG.song.toLowerCase() == 'suit up')
		{
			switch (curStep)
			{
				case 110:
					blackFade();
				case 124:
					remove(blackStuff);
					whiteFade();
					stevePrepare();
				case 384 | 400 | 416 | 432 | 448 | 464 | 480 | 496 | 768 | 784 | 832 /*846*/ | 848 | 864 | 866 | 880 | 1166:
					slashEvent();
					stevePrepare();
				case 388 | 404 | 420 | 436 | 452 | 468 | 484 | 500 | 772 | 788 | 836 /*850 */ | 852 | 868 | 870 | 884 | 1172:
					steveAttack();
					if(FlxG.save.data.SpectatorMode)
						{
							pressedSpace = true;
							boyfriend.playAnim('block', true);
						}
				case  800 | 802 | 816 | 818:
					slashEvent();
					stevePrepare();
				case 804 | 806 | 820 | 822:
					steveAttack();
					if(FlxG.save.data.SpectatorMode)
						{
							pressedSpace = true;
							boyfriend.playAnim('block', true);
						}
			}
		}


		if (dad.curCharacter == 'irfan' && SONG.song.toLowerCase() == 'bonk')
			{
				switch (curStep)
				{
					case 395 | 427 | 459 | 492 | 652 | 716 | 844 | 908 | 940 | 972 | 1004 | 1164 | 1228:
						bonkEvent();
					case 394 | 426 | 458 | 491 | 651 | 715 | 843 | 907 | 939 | 971 | 1003 | 1163 | 1227:
						bonkAnim();
				}
	
			}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}
	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}
		if (curSong == 'Lost')
		{
			{
			remove(dad);
			}
		}



		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.animation.curAnim.name != 'hit' && dad.animation.curAnim.name != 'bonk' && dad.animation.curAnim.name != 'prepare' && dad.animation.curAnim.name != 'unequipPickaxe' && dad.animation.curAnim.name == 'idle-alt' && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (curSong == 'whatever' && curBeat >= 288 && curBeat < 352)
			{
				FlxG.camera.zoom += 0.025;
				camHUD.zoom += 0.03;
				trace(FlxG.camera.zoom);
			}
		if (curSong == 'copper' && curBeat >= 128 && curBeat < 160)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'copper' && curBeat >= 168 && curBeat < 192)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'copper' && curBeat >= 200 && curBeat < 208)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'copper' && curBeat >= 216 && curBeat < 224)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'gapple' && curBeat >= 32 && curBeat < 64)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'gapple' && curBeat >= 96 && curBeat < 128)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}
		if (curSong == 'gapple' && curBeat >= 228 && curBeat < 288)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
			trace(FlxG.camera.zoom);
		}

		if (curSong == 'espionage' && curBeat >= 32 && curBeat < 160)
			{
				FlxG.camera.zoom += 0.05;
				camHUD.zoom += 0.03;
				trace(FlxG.camera.zoom);
			}

		if (curSong == 'espionage' && curBeat >= 224 && curBeat < 288)
			{
				FlxG.camera.zoom += 0.05;
				camHUD.zoom += 0.03;
				trace(FlxG.camera.zoom);
			}


		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.03;
		}


		if (curBeat % gfSpeed == 0) 
			{
			curBeat % (gfSpeed * 2) == 0 ? 
			{
				iconP1.scale.set(1.1, 0.8);
				iconP2.scale.set(1.1, 1.3);
				//FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				//FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			} 
			: 
			{
				iconP1.scale.set(1.1, 1.3);
				iconP2.scale.set(1.1, 0.8);
				FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				
			}

			FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
			FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}




		//iconP1.scale.set(1.15, 1.15);
		//iconP2.scale.set(1.15, 1.15);
		//
		//FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quartInOut});
		//FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quartInOut});
//
		//iconP1.updateHitbox();
		//iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.animation.curAnim.name != 'block')
		{
			boyfriend.playAnim('idle');
		}

		if (!dad.animation.curAnim.name.startsWith("sing") || !dad.animation.curAnim.name.startsWith("unequipPickaxe") || !dad.animation.curAnim.name.startsWith("idle-alt"))
		{
			dad.dance();
			if (hasDuoDad)
				duoDad.dance();
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

			if (curBeat == 227 && curSong == 'endless')
			{
				startCountdown();
			}



		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'devs':
				if(FlxG.save.data.distractions){
					bgDevs.dance();
				}
			case 'house':
				if(FlxG.save.data.distractions){
					doggo.animation.play('bop', false);
					alexPickaxeBG.animation.play('bop', false);
					catto.animation.play('bop', false);
					sheep.animation.play('bop', false);
				}
			case 'mine':
				if(FlxG.save.data.distractions){
					minijukebox.animation.play('bop', true);
				}
			case 'cave':
				if(FlxG.save.data.distractions){
					minijukebox.animation.play('bop', false);
				}
			case 'mcsm':
				if(FlxG.save.data.distractions){
					musicnotes.animation.play('bop', false);
				}
			case 'notch':
				if(FlxG.save.data.distractions){
					alecs.animation.play('bop', false);
					stev.animation.play('bop', false);
					notchStanding.animation.play('bop', false);
					hors.animation.play('bop', false);
				}
			case 'templeentrance':
				if(FlxG.save.data.distractions){
					gfminecraft.animation.play('bop', false);
				}
			case 'fasttravel':
				if(FlxG.save.data.distractions){
					gfHorse.animation.play('bop', false);
					alexHorse.animation.play('bop', false);
					steveHorse.animation.play('bop', false);
				}
			case 'tutorial':
				if(FlxG.save.data.distractions){
					irfan.animation.play('bop', false);
				}
		}
	}

	var curLight:Int = 0;
}
//if you're reading this, heeelllooo from Tiago :P

//					Hey there Porters/Modders or Viewers that are looking at this Code...
//					Quick note to any of you who's trying to port this to any type of platform from scratch
//					I (Tiago) did a shit ton of rework on the health layering of the Health bar... (Not much LOL)
//					If you want to port that aswell take a good look at the code to know how its done...
//					Yea.. Thats all, ive had a lot of fun with this mod and i actually learned a lot lol...	
//					When i entered the Development of the Mod, i had ABSOLUTELY no idea how haxe works
//					But i kinda started unserstanding how stuff works by look at it and trying to understand how it works, which is actaully very
//					understandable..
//					So if any of you guys reading this is willing to make a mod but doesnt want to learn Haxe, trying using the *tecniques* i just described...
//					Or stick to the manual LOL
//					
//					Welp...
// 					Kind Regards 
//					Tiago (TracedInPurple)