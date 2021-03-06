package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['me (subscribe to my yt pls)'],
		['CrystalSlime',		'me',				'did practically everything',						'https://www.youtube.com/channel/UCT_wYKD4twxoYOZt2ggXHlw',		0xFFFF0059],
		[''],
		['Special Thanks'],
		['joeys pencil',		'joey',				'drew',												'https://www.youtube.com/channel/UCRLsZwUPm7Ax4ZZ3lgM77Ng/',		0xFFA820EC],
		['candina goose',		'gose',				'asked to be here- did everything',					'https://www.youtube.com/channel/UCfjYxs_8SL1JtL2TqyS-wSg',			0xFF20EC26],
		['tosslers guitar',		'tossler',			'played an epic fucking solo',						'https://twitter.com/IdoBPerez',					0xFFFF0000],
		['Ash',					'ash',				'helped me work things out while coding',			'https://twitter.com/ash__i_guess_',	0xFFFFFFFF],
		['Brightfyre',			'brightfyre',		'also helped me work things out while coding',		'https://www.youtube.com/c/BrightFyre/',	0xFFFFBD00],
		['Vidz',				'vidz',				'also also helped me work things out while coding',		'https://twitter.com/ItsVidz3',	0xFF4BC9FF],
		['Madbear422',			'madbear',			'made the logo, animated the last cuscene and did some other small things',							'https://www.youtube.com/channel/UCuUWs5LR42EaSwtI_IqxO-w',		0xFFFF66E3],
		['HugeNate',			'large nate of humongous proportions',			'helped me with charting in some parts',				'https://twitter.com/HugeNate_',	0xFF20ECAB],
		['NonsenseHumor',		'nonsense',			'animated part of the third cutscene',				'https://www.youtube.com/c/NonsenseHumorLOL',	0xFF00A6FF],
		['Star-Strawberry',		'star',				'gave me a single hex code',						'https://www.google.com/search?q=monkey&rlz=1C1CHBF_enCA886CA886&sxsrf=AOaemvIwiYclM4yO7I1izioLV6DPT-0FZg:1632187660298&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiXhsvt9I7zAhWsc98KHabbBGkQ_AUoAXoECAEQAw&biw=1920&bih=937&dpr=1#imgrc=dWg5KXN38xrNLM',	0xFFFF9700],
		['Keoiki',				'keoiki',			'Note Splash Animations',							'https://twitter.com/Keoiki_',			0xFFFFFFFF],
		['PolybiusProxy',       'polybiusproxy',   '.MP4 Video Loader Extension',                       'https://twitter.com/polybiusproxy',    0xFFFFEAA6],
		[''],
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',	0xFFFFDD33],
		['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',		0xFFC30085],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
