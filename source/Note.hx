package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx
	public var originAngle:Float = 0; // The angle the OG note of the sus note had (?)
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType:Int = 0;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public var isParent:Bool = false;

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0) 
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.noteType = noteType;
		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (PlayState.SONG.noteStyle)
		{
			case 'pixel':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);

				if (noteType == 3)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

				case 'funkyArrows':
					loadGraphic(Paths.image('weeb/pixelUI/funkyArrows-pixels','week6'), true, 17, 17);
	
					if (noteType == 3)
					{
						animation.add('greenScroll', [22]);
						animation.add('redScroll', [23]);
						animation.add('blueScroll', [21]);
						animation.add('purpleScroll', [20]);
					}
					else
					{
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
					}
	
					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/funkyArrows-arrowEnds','week6'), true, 7, 6);
	
						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);
	
						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();

					case 'hardcore-funkyArrows':
						loadGraphic(Paths.image('weeb/pixelUI/funkyArrows-hardcore-pixels','week6'), true, 17, 17);
		
						if (noteType == 3)
						{
							animation.add('greenScroll', [22]);
							animation.add('redScroll', [23]);
							animation.add('blueScroll', [21]);
							animation.add('purpleScroll', [20]);
						}
						else
						{
							animation.add('greenScroll', [6]);
							animation.add('redScroll', [7]);
							animation.add('blueScroll', [5]);
							animation.add('purpleScroll', [4]);
						}
		
						if (isSustainNote)
						{
							loadGraphic(Paths.image('weeb/pixelUI/funkyArrows-hardcore-arrowEnds','week6'), true, 7, 6);
		
							animation.add('purpleholdend', [4]);
							animation.add('greenholdend', [6]);
							animation.add('redholdend', [7]);
							animation.add('blueholdend', [5]);
		
							animation.add('purplehold', [0]);
							animation.add('greenhold', [2]);
							animation.add('redhold', [3]);
							animation.add('bluehold', [1]);
						}
						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						updateHitbox();

			case 'alex':
				loadGraphic(Paths.image('weeb/pixelUI/alex-arrows-pixels','week6'), true, 17, 17);

				if (noteType == 2)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/alex-arrowEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'notch':
				loadGraphic(Paths.image('weeb/pixelUI/notch-pixels','week6'), true, 17, 17);

				if (noteType == 5)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/notch-arrowEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'hardcore-notch':
				loadGraphic(Paths.image('weeb/pixelUI/notch-hardcore-pixels','week6'), true, 17, 17);

				if (noteType == 5)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else if (noteType == 3)
				{
					animation.add('greenScroll', [26]);
					animation.add('redScroll', [27]);
					animation.add('blueScroll', [25]);
					animation.add('purpleScroll', [24]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/notch-hardcoreEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'Majin':
				loadGraphic(Paths.image('weeb/pixelUI/Majin_Notes','week6'), true, 17, 17);

				if (noteType == 2)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/Majin_Notes_ends','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'devs':
				loadGraphic(Paths.image('weeb/pixelUI/devs-arrows-pixels','week6'), true, 17, 17);
			
				if (noteType == 2)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}
				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/devs-arrowEnds','week6'), true, 7, 6);
					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'aww':
				loadGraphic(Paths.image('weeb/pixelUI/aww-arrows-pixels','week6'), true, 17, 17);
				
				if (noteType == 2)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/aww-arrowEnds','week6'), true, 7, 6);
					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'hardcore':
				loadGraphic(Paths.image('weeb/pixelUI/hardcore-pixels','week6'), true, 17, 17);

				if (noteType == 3)
					{
						animation.add('greenScroll', [22]);
						animation.add('redScroll', [23]);
						animation.add('blueScroll', [21]);
						animation.add('purpleScroll', [20]);
					}
					else
					{
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
					}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/hardcoreEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				
			case 'hardcore-alex':
				loadGraphic(Paths.image('weeb/pixelUI/alex-hardcore-pixels','week6'), true, 17, 17);

				if (noteType == 2)
					{
						animation.add('greenScroll', [22]);
						animation.add('redScroll', [23]);
						animation.add('blueScroll', [21]);
						animation.add('purpleScroll', [20]);
					}
					else
					{
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
					}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/alex-hardcoreEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'hardcore-aww':
				loadGraphic(Paths.image('weeb/pixelUI/aww-hardcore-pixels','week6'), true, 17, 17);
	
				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);
	
				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/aww-hardcoreEnds','week6'), true, 7, 6);
	
					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
	
					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
	
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'hardcore-devs':
				loadGraphic(Paths.image('weeb/pixelUI/devs-hardcore-pixels','week6'), true, 17, 17);
	
				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);
	
				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/devs-hardcoreEnds','week6'), true, 7, 6);
	
					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
	
					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
	
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			
			default:
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);

				if (noteType == 2)
				{
					animation.add('greenScroll', [22]);
					animation.add('redScroll', [23]);
					animation.add('blueScroll', [21]);
					animation.add('purpleScroll', [20]);
				}
				else
				{
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;
			x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				
				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!modifiedByLua)
			angle = modAngle + localAngle;
		else
			angle = modAngle;

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
