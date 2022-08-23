package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundDevs extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		// BG fangirls dissuaded
		frames = Paths.getSparrowAtlas('devs/bgDevs', 'shared');

		animation.addByIndices('danceLeft', 'BG devs group', CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', 'BG devs group', CoolUtil.numberArray(30, 15), "", 24, false);

		animation.play('danceLeft');
	}

	var danceDir:Bool = false;

	public function dance():Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true);
		else
			animation.play('danceLeft', true);
	}
}
