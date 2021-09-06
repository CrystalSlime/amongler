package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class StairsLOL extends TitleState
{

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('jerry/jerrybg','shared'));
		add(bg);
		
		var txt:FlxText;
			txt = new FlxText(0, 0, FlxG.width,
				"yo whats up\n" +
				'this mod is NOT a sequal to stairs\n\n' +
				'please dont tell people it is lmao',
			32);
		
		
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}
}
