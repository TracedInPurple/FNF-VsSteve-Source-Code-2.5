package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'gf' => new CharacterSetting(100, -75, 1.45, true),
		'bf' => new CharacterSetting(-650, -325, 0.95, true),
		'steve' => new CharacterSetting(-500, -100, 1.4),
		'alex' => new CharacterSetting(-500, -100, 1.4),
		'notch' => new CharacterSetting(-500, -25, 1.4)
	];

	private var flipped:Bool = false;

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = false;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('gf', "gf", 24);
		animation.addByPrefix('bf', "boyfriend", 24);
		animation.addByPrefix('bfConfirm', 'bfhey', 24, false);
		animation.addByPrefix('steve', "steve", 24);
		animation.addByPrefix('alex', "alex", 24);
		animation.addByPrefix('notch', "notch", 24);

		setGraphicSize(Std.int(width * 4));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		animation.play(character);

		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		//setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}
