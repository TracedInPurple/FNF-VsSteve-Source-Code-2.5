package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
class Headers extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
        


        var choose = FlxG.random.int(1,31);
		
        frames = Paths.getSparrowAtlas("Menu/headers/banners");
	
        animation.addByPrefix('1', 'bb0', 24, false);
        animation.addByPrefix('2', 'bb2', 24, false);
        animation.addByPrefix('3', 'bb3', 24, false);
        animation.addByPrefix('4', '4', 24, false);
        animation.addByPrefix('5', '5', 24, false);
        animation.addByPrefix('6', '6', 24, false);
        animation.addByPrefix('7', '7', 24, false);
        animation.addByPrefix('8','8', 24, false);
        animation.addByPrefix('9', '9', 24, false);
        animation.addByPrefix('10', '10', 24, false);
        animation.addByPrefix('11', '11', 24, false);
        animation.addByPrefix('12', '12', 24, false);
        animation.addByPrefix('13', '13', 24, false);
        animation.addByPrefix('14', '14', 24, false);
        animation.addByPrefix('15', '15', 24, false);
        animation.addByPrefix('16', '16', 24, false);
        animation.addByPrefix('17', '17', 24, false);
        animation.addByPrefix('18', '18', 24, false);
        animation.addByPrefix('19', '19', 24, false);
        animation.addByPrefix('20', '20', 24, false);
        animation.addByPrefix('21', '21', 24, false);
        animation.addByPrefix('22', '25', 24, false);
        animation.addByPrefix('23', '26', 24, false);
        animation.addByPrefix('24', '27', 24, false);
        animation.addByPrefix('25', '28', 24, false);
        animation.addByPrefix('26', '29', 24, false);
        animation.addByPrefix('27', '30', 24, false);
        animation.addByPrefix('28', '31', 24, false);
        animation.addByPrefix('29', '32', 24, false);
        animation.addByPrefix('30', '33', 24, false);
        animation.addByPrefix('31', '34', 24, false);
        animation.play(choose+"");
        
        antialiasing = true;
	}

	
}
