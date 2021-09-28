package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import Achievements;

using StringTools;

class AshMenu extends MusicBeatState
{

	var ash:FlxBackdrop;
	override function create()
	{
		var ashSpr = new FlxSprite().loadGraphic(Paths.image('ashmenu/ash'));
		ash = new FlxBackdrop(ashSpr.graphic);
		add(ash);
		if (FlxG.sound.music.playing)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('breakfast', 'shared'));
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		ash.x += 1;
		ash.y += 1;

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}