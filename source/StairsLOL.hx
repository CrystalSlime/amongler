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

class StairsLOL extends MusicBeatState
{

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('jerry/jerrybg','shared'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.y += 20;
		add(bg);
		
		var txt:FlxText;
			txt = new FlxText(0, 0, FlxG.width,
				"yo whats up\n" +
				'this mod is NOT a sequal to stairs\n\n' +
				'please dont tell people it is lmao',
			32);
		
		
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromString('0xffFFFFFF'), CENTER);
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
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}
}
