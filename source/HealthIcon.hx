package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = false;
		animation.add('bf', [0, 1, 2], 0, false, isPlayer);
		animation.add('bf-pixel', [3, 5, 4, 33], 0, false, isPlayer);
		animation.add('bfminecraft', [25, 27, 26, 32], 0, false, isPlayer);
		animation.add('gf-pixel', [6, 8, 7], 0, false, isPlayer);
		animation.add('gf-christmas', [6, 8, 7], 0, false, isPlayer);
		animation.add('tuxsteveuoh', [9, 10, 11], 0, false, isPlayer);
		animation.add('tuxsteve', [12, 10, 13], 0, false, isPlayer);
		animation.add('steve-armor', [14, 10, 13], 0, false, isPlayer);
		animation.add('tuxstevewhatever', [14, 10, 13], 0, false, isPlayer);
		animation.add('stevehorse', [9, 10, 13], 0, false, isPlayer);
		animation.add('alexnormal', [15, 17, 16], 0, false, isPlayer);	
		animation.add('alexpickaxe', [18, 17, 19], 0, false, isPlayer);
		animation.add('alexpickaxemad', [20, 17, 19], 0, false, isPlayer);
		animation.add('alex', [20, 17, 19], 0, false, isPlayer);
		animation.add('alexchill', [21, 17, 18], 0, false, isPlayer);
		animation.add('notch', [22, 23, 24], 0, false, isPlayer);
		animation.add('303', [31, 31, 31], 0, false, isPlayer);
		animation.add('jaziel', [28, 28, 28], 0, false, isPlayer);
		animation.add('bos', [29, 29, 29], 0, false, isPlayer);
		animation.add('irfan', [30, 30, 30], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
