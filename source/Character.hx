package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var holdTimer:Float = 0;
	public var iconColor:String = "FF82d4f5";
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				iconColor = 'FFB03060';
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-christmas':
				iconColor = 'FFB03060';
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				iconColor = 'FFB03060';
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				iconColor = 'FFB03060';
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('hey', 'HEY', 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset("hey", 0);


				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('pre-attack', 'bf pre attack', 24, false);
				animation.addByPrefix('attack', 'boyfriend attack', 24 , false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("pre-attack", 0, -32);
				addOffset("attack", 177, 275);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;


			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				animation.addByPrefix('block', 'BF BLOCK', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				addOffset("block");
				addOffset("hey", 12, -6);


				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bfminecraft':
				frames = Paths.getSparrowAtlas('characters/bfMinecraft');
				animation.addByPrefix('idle', 'bfMinecraft Idle', 24, false);
				animation.addByPrefix('singUP', 'bfMinecraft up note', 24, false);
				animation.addByPrefix('singLEFT', 'bfMinecraft left note', 24, false);
				animation.addByPrefix('singRIGHT', 'bfMinecraft right note', 24, false);
				animation.addByPrefix('singDOWN', 'bfMinecraft down note', 24, false);
				animation.addByPrefix('singUPmiss', 'bfMinecraft up miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'bfMinecraft left miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'bfMinecraft right miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'bfMinecraft down miss', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 5.8));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			
			case 'bfeyes':
				frames = Paths.getSparrowAtlas('characters/bfeyes');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				iconColor = 'FF2B5480';
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'tiago':
				iconColor = 'FF800080';
				frames = Paths.getSparrowAtlas('characters/Tiago');
				animation.addByPrefix('idle', 'Tiago Idle', 24, false);
				animation.addByPrefix('singUP', 'Tiago UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Tiago LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Tiago RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Tiago DOWN NOTE', 24, false);
			
				addOffset('idle', -3, -3);
				addOffset("singUP", -18, 14);
				addOffset("singRIGHT", -4, -21);
				addOffset("singLEFT", 19, -5);
				addOffset("singDOWN", 12, -12);
			
				playAnim('idle');
		
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;


			case 'senpai-angry':
				iconColor = 'FF264B73';
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'steve-armor':
				iconColor = 'FF224367';
				frames = Paths.getSparrowAtlas('characters/SteveArmor');
				animation.addByPrefix('idle', 'SteveArmor idle', 24, false);
				animation.addByPrefix('singUP', 'SteveArmor up', 24, false);
				animation.addByPrefix('singLEFT', 'SteveArmor left', 24, false);
				animation.addByPrefix('singRIGHT', 'SteveArmor right', 24, false);
				animation.addByPrefix('singDOWN', 'SteveArmor down', 24, false);
				animation.addByPrefix('prepare', 'SteveArmor prepare', 24, false);
				animation.addByPrefix('hit', 'SteveArmor hit', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -227, -256);
				addOffset("singRIGHT", -239, -254);
				addOffset("singLEFT", -234, -259);
				addOffset("singDOWN", -226, -260);
				addOffset("prepare", -280, -260);
				addOffset("hit", -280, -260);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'stevehorse':
				iconColor = 'FF2B5480';
				frames = Paths.getSparrowAtlas('characters/steveHorse');
				animation.addByPrefix('idle', 'steveHorse idle', 24, false);
				animation.addByPrefix('singUP', 'steveHorse up', 24, false);
				animation.addByPrefix('singLEFT', 'steveHorse left', 24, false);
				animation.addByPrefix('singRIGHT', 'steveHorse right', 24, false);
				animation.addByPrefix('singDOWN', 'steveHorse down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -247, -256);
				addOffset("singRIGHT", -249, -254);
				addOffset("singLEFT", -244, -259);
				addOffset("singDOWN", -256, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
				
			case 'tuxsteveuoh':
				iconColor = 'FF2B5480';
				frames = Paths.getSparrowAtlas('characters/tuxsteveuoh');
				animation.addByPrefix('idle', 'tuxsteveuoh idle', 24, false);
				animation.addByPrefix('singUP', 'tuxsteveuoh up', 24, false);
				animation.addByPrefix('singLEFT', 'tuxsteveuoh left', 24, false);
				animation.addByPrefix('singRIGHT', 'tuxsteveuoh right', 24, false);
				animation.addByPrefix('singDOWN', 'tuxsteveuoh down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -274, -242);
				addOffset("singRIGHT", -292, -277);
				addOffset("singLEFT", -256, -260);
				addOffset("singDOWN", -244, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.8));
				updateHitbox();

				antialiasing = false;

			case 'tuxsteve':
				iconColor = 'FF2B5480';
				frames = Paths.getSparrowAtlas('characters/tuxsteve');
				animation.addByPrefix('idle', 'tuxsteve idle', 24, false);
				animation.addByPrefix('singUP', 'tuxsteve up', 24, false);
				animation.addByPrefix('singLEFT', 'tuxsteve left', 24, false);
				animation.addByPrefix('singRIGHT', 'tuxsteve right', 24, false);
				animation.addByPrefix('singDOWN', 'tuxsteve down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -239, -272);
				addOffset("singRIGHT", -252, -260);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -250, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'tuxstevewhatever':
				iconColor = 'FF2B5480';
				frames = Paths.getSparrowAtlas('characters/tuxstevewhatever');
				animation.addByPrefix('idle', 'tuxsteve idle', 24, false);
				animation.addByPrefix('singUP', 'tuxsteve up', 24, false);
				animation.addByPrefix('singLEFT', 'tuxsteve left', 24, false);
				animation.addByPrefix('singRIGHT', 'tuxsteve right', 24, false);
				animation.addByPrefix('singDOWN', 'tuxsteve down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -239, -272);
				addOffset("singRIGHT", -252, -260);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -250, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;
				

			case 'alexnormal':
				iconColor = 'FF9AFF9A';
				frames = Paths.getSparrowAtlas('characters/alexnormal');
				animation.addByPrefix('idle', 'alexnormal idle', 24, false);
				animation.addByPrefix('singUP', 'alexnormal up', 24, false);
				animation.addByPrefix('singLEFT', 'alexnormal left', 24, false);
				animation.addByPrefix('singRIGHT', 'alexnormal right', 24, false);
				animation.addByPrefix('singDOWN', 'alexnormal down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -251, -233);
				addOffset("singRIGHT", -251, -263);
				addOffset("singLEFT", -249, -265);
				addOffset("singDOWN", -250, -265);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'alex':
				iconColor = 'FF9AFF9A';
				frames = Paths.getSparrowAtlas('characters/alex');
				animation.addByPrefix('idle', 'alex idle', 24, false);
				animation.addByPrefix('singUP', 'alex up', 24, false);
				animation.addByPrefix('singLEFT', 'alex left', 24, false);
				animation.addByPrefix('singRIGHT', 'alex right', 24, false);
				animation.addByPrefix('singDOWN', 'alex down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -239, -272);
				addOffset("singRIGHT", -252, -260);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -250, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'alexchill':
				iconColor = 'FF9AFF9A';
				frames = Paths.getSparrowAtlas('characters/alexchill');
				animation.addByPrefix('idle', 'alexchill idle', 24, false);
				animation.addByPrefix('singUP', 'alexchill up', 24, false);
				animation.addByPrefix('singLEFT', 'alexchill left', 24, false);
				animation.addByPrefix('singRIGHT', 'alexchill right', 24, false);
				animation.addByPrefix('singDOWN', 'alexchill down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -250, -254);
				addOffset("singRIGHT", -256, -254);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -250, -254);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'alexpickaxe':
				iconColor = 'FF9AFF9A';
				frames = Paths.getSparrowAtlas('characters/alexpickaxe');
				animation.addByPrefix('idle', 'alexpickaxe idle', 24, false);
				animation.addByPrefix('singUP', 'alexpickaxe up', 24, false);
				animation.addByPrefix('singLEFT', 'alexpickaxe left', 24, false);
				animation.addByPrefix('singRIGHT', 'alexpickaxe right', 24, false);
				animation.addByPrefix('singDOWN', 'alexpickaxe down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -255, -261);
				addOffset("singRIGHT", -261, -263);
				addOffset("singLEFT", -249, -265);
				addOffset("singDOWN", -250, -261);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'alexpickaxemad':
				iconColor = 'FF9AFF9A';
				frames = Paths.getSparrowAtlas('characters/alexpickaxemad');
				animation.addByPrefix('idle', 'alexpickaxemad idle', 24, false);
				animation.addByPrefix('singUP', 'alexpickaxemad up', 24, false);
				animation.addByPrefix('singLEFT', 'alexpickaxemad left', 24, false);
				animation.addByPrefix('singRIGHT', 'alexpickaxemad right', 24, false);
				animation.addByPrefix('singDOWN', 'alexpickaxemad down', 24, false);
				animation.addByPrefix('unequipPickaxe', 'alexpickaxemad unequip', 24, false);

				addOffset('idle', -249, -259);
				addOffset("singUP", -255, -259);
				addOffset("singRIGHT", -261, -259);
				addOffset("singLEFT", -255, -259);
				addOffset("singDOWN", -249, -259);
				addOffset("unequipPickaxe", -214, -259);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'gabo':
				iconColor = 'FF8FD8D4';
				frames = Paths.getSparrowAtlas('characters/gabo');
				animation.addByPrefix('idle', 'gabo Idle', 24, false);
				animation.addByPrefix('singUP', 'gabo UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'gabo LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'gabo RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'gabo DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'jaziel':
				iconColor = 'FFFF0000';
				frames = Paths.getSparrowAtlas('characters/jaziel');
				animation.addByPrefix('idle', 'jaziel idle', 24, false);
				animation.addByPrefix('idle-alt', 'jaziel espionage', 24, false);
				animation.addByPrefix('singUP', 'jaziel crouch', 24, false);
				animation.addByPrefix('singLEFT', 'jaziel crouch', 24, false);
				animation.addByPrefix('singRIGHT', 'jaziel crouch', 24, false);
				animation.addByPrefix('singDOWN', 'jaziel crouch', 24, false);

				addOffset('idle', -250, -260);
				addOffset('idle-alt', -250, -260);
				addOffset("singUP", -250, -260);
				addOffset("singRIGHT", -250, -260);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -250, -260);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'bos':
				iconColor = 'FFF5AE00';
				frames = Paths.getSparrowAtlas('characters/bos');
				animation.addByPrefix('idle', 'bos idle', 24, false);
				animation.addByPrefix('singUP', 'bos up', 24, false);
				animation.addByPrefix('singLEFT', 'bos left', 24, false);
				animation.addByPrefix('singRIGHT', 'bos right', 24, false);
				animation.addByPrefix('singDOWN', 'bos down', 24, false);

				addOffset('idle', -250, -260);
				addOffset("singUP", -231, -263);
				addOffset("singRIGHT", -250, -260);
				addOffset("singLEFT", -210, -260);
				addOffset("singDOWN", -250, -250);

				playAnim('idle');

				setGraphicSize(Std.int(width * 5.9));
				updateHitbox();

				antialiasing = false;

			case 'irfan':
				iconColor = 'FF32CD32';
				frames = Paths.getSparrowAtlas('characters/irfan');
				animation.addByPrefix('idle', 'irfan idle', 24, false);
				animation.addByPrefix('singUP', 'irfan up', 24, false);
				animation.addByPrefix('singLEFT', 'irfan left', 24, false);
				animation.addByPrefix('singRIGHT', 'irfan right', 24, false);
				animation.addByPrefix('singDOWN', 'irfan down', 24, false);
				animation.addByPrefix('bonk', 'irfan bonk', 24, false);

				addOffset('idle', -251, -258);
				addOffset("singUP", -251, -258);
				addOffset("singRIGHT", -256, -258);
				addOffset("singLEFT", -251, -258);
				addOffset("singDOWN", -256, -258);
				addOffset("bonk", -239, -258);
				playAnim('idle');

				setGraphicSize(Std.int(width * 5.8));
				updateHitbox();

				antialiasing = false;

			case 'jesse':
				iconColor = 'FFFF0000';
				frames = Paths.getSparrowAtlas('characters/jesse');
				animation.addByPrefix('idle', 'jesse idle', 24, false);
				animation.addByPrefix('singUP', 'jesse up', 24, false);
				animation.addByPrefix('singLEFT', 'jesse left', 24, false);
				animation.addByPrefix('singRIGHT', 'jesse right', 24, false);
				animation.addByPrefix('singDOWN', 'jesse down', 24, false);

				addOffset('idle');
				addOffset("singUP", 57, 11);
				addOffset("singRIGHT", 40, 9);
				addOffset("singLEFT", 40, 0);
				addOffset("singDOWN", 20, 10);

				playAnim('idle');

				setGraphicSize(Std.int(width * 1.1));

				antialiasing = true;

			case 'notch':
				iconColor = 'FFd7711a';
				frames = Paths.getSparrowAtlas('characters/notch');
				animation.addByPrefix('idle', 'notch idle', 24, false);
				animation.addByPrefix('singUP', 'notch up', 24, false);
				animation.addByPrefix('singLEFT', 'notch left', 24, false);
				animation.addByPrefix('singRIGHT', 'notch right', 24, false);
				animation.addByPrefix('singDOWN', 'notch down', 24, false);
				animation.addByPrefix('singDOWN-alt', 'notch gappledown', 24, false);
				animation.addByPrefix('singUP-alt', 'notch gappleup', 24, false);
				animation.addByPrefix('singLEFT-alt', 'notch left', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'notch right', 24, false);
	
				addOffset('idle', -246, -264);
				addOffset("singUP", -240, -270);
				addOffset("singRIGHT", -246, -270);
				addOffset("singLEFT", -246, -264);
				addOffset("singDOWN", -252, -270);
				addOffset("singDOWN-alt", -240, -270);
				addOffset("singUP-alt", -234, -270);
				addOffset("singRIGHT-alt", -246, -270);
				addOffset("singLEFT-alt", -246, -264);
	
				playAnim('idle');
	
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
	
				antialiasing = false;


			case 'jeb':
				iconColor = 'FFFFFFFF';
				frames = Paths.getSparrowAtlas('characters/jeb');
				animation.addByPrefix('idle', 'jeb idle', 24, false);
				animation.addByPrefix('singUP', 'jeb up', 24, false);
				animation.addByPrefix('singLEFT', 'jeb left', 24, false);
				animation.addByPrefix('singRIGHT', 'jeb right', 24, false);
				animation.addByPrefix('singDOWN', 'jeb down', 24, false);
	
				addOffset('idle', -250, -260);
				addOffset("singUP", -260, -260);
				addOffset("singRIGHT", -252, -260);
				addOffset("singLEFT", -250, -260);
				addOffset("singDOWN", -248, -267);
	
				playAnim('idle');
	
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
	
				antialiasing = false;

			case '303':
				iconColor = 'FFFF0000';
				frames = Paths.getSparrowAtlas('characters/303');
				animation.addByPrefix('idle', '303 idle', 24, false);
				animation.addByPrefix('singUP', '303 up', 24, false);
				animation.addByPrefix('singLEFT', '303 left', 24, false);
				animation.addByPrefix('singRIGHT', '303 right', 24, false);
				animation.addByPrefix('singDOWN', '303 down', 24, false);

				addOffset('idle', -252, -258);
				addOffset("singUP", -259, -240);
				addOffset("singRIGHT", -277, -234);
				addOffset("singLEFT", -235, -264);
				addOffset("singDOWN", -250, -240);

				playAnim('idle');

				setGraphicSize(Std.int(width * 7));
				updateHitbox();

				antialiasing = false;

			case 'bfminecraft-death': // tragically and sadly:((
				frames = Paths.getSparrowAtlas('death/bfMinecraftDies.png', 'shared');
				animation.addByPrefix('firstDeath', "bfMinecraftDies.png Dies", 24, false);
				animation.addByPrefix('deathLoop', "bfMinecraftDies.png respawnButton", 24, true);
				animation.addByPrefix('deathConfirm', "bfMinecraftDies.png respawnConfirm", 24, false);
				animation.play('firstDeath');
	
				addOffset('firstDeath', 47, 11);
				addOffset('deathLoop', -500, -129);
				addOffset('deathConfirm', -500, -129);
				playAnim('firstDeath');
				setGraphicSize(Std.int(width * 5));
				updateHitbox();
	
				antialiasing = false;
					
				flipX = true;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}