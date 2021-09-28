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
import Achievements;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.3.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<TheMenuItem>;
	var menuItemsBG:FlxTypedGroup<FlxSprite>;
	var ash:FlxSprite;
	var logo:FlxSprite;
	var ashMode:Bool = false;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var canDoStuff:Bool = false;
	
	var rightAnswer:Array<String> = [
		'up',
		'up',
		'down',
		'down',
		'left',
		'right',
		'left',
		'right',
	];
	var realAnswer:Array<String> = [];
	var optionShit:Array<String> = ['story_mode', 'freeplay', 'youtube', 'credits', 'options'];

	var magenta:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('jerrymenu/mainbg'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1));
		bg.screenCenter();
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);


		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItemsBG = new FlxTypedGroup<FlxSprite>();
		add(menuItemsBG);

		menuItems = new FlxTypedGroup<TheMenuItem>();
		add(menuItems);

		ash = new FlxSprite(73, 355).loadGraphic(Paths.image('jerrymenu/ash'));
		add(ash);

		logo = new FlxSprite(807, -6).loadGraphic(Paths.image('jerrymenu/logo'));
		add(logo);
		logo.antialiasing = true;

		FlxTween.angle(logo, 0, 10, 2, {ease:FlxEase.quadOut,
		onComplete: function(twn:FlxTween) {
			logoAngle();
		},});

		for (i in 0...optionShit.length) {
			var menuItemBG:FlxSprite = new FlxSprite();
			var menuItem:TheMenuItem = new TheMenuItem();
			switch (optionShit[i]) {
				case 'story_mode':
					menuItemBG.loadGraphic(Paths.image('jerrymenu/storybg'));
					menuItemBG.setPosition(0, 54);
					menuItem.loadGraphic(Paths.image('jerrymenu/story'));
					menuItem.setPosition(36, 46);
					menuItem.x -= 600;
					menuItemBG.x -= 600;
					FlxTween.tween(menuItem, {x: 36}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.5
					});
					FlxTween.tween(menuItemBG, {x: 0}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.4
					});
				case 'freeplay':
					menuItemBG.loadGraphic(Paths.image('jerrymenu/freeplaybg'));
					menuItemBG.setPosition(0, 187);
					menuItem.loadGraphic(Paths.image('jerrymenu/freeplay'));
					menuItem.setPosition(77, 188);
					menuItem.x -= 600;
					menuItemBG.x -= 600;
					FlxTween.tween(menuItem, {x: 77}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.5
					});
					FlxTween.tween(menuItemBG, {x: 0}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.4
					});
				case 'youtube':
					menuItemBG.loadGraphic(Paths.image('jerrymenu/youtubebg'));
					menuItemBG.setPosition(678, 378);
					menuItem.loadGraphic(Paths.image('jerrymenu/yt'));
					menuItem.setPosition(728, 388);
					menuItem.x += 600;
					menuItemBG.x += 600;
					FlxTween.tween(menuItem, {x: 728}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.5
					});
					FlxTween.tween(menuItemBG, {x: 678}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.4
					});
				case 'credits':
					menuItemBG.loadGraphic(Paths.image('jerrymenu/creditsbg'));
					menuItemBG.setPosition(752, 545);
					menuItem.loadGraphic(Paths.image('jerrymenu/credits'));
					menuItem.setPosition(851, 549);
					menuItem.x += 600;
					menuItemBG.x += 600;
					FlxTween.tween(menuItem, {x: 851}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.5
					});
					FlxTween.tween(menuItemBG, {x: 752}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.4
					});
				case 'options':
					menuItemBG.loadGraphic(Paths.image('jerrymenu/optionbg'));
					menuItemBG.setPosition(632, -4);
					menuItem.loadGraphic(Paths.image('jerrymenu/options'));
					menuItem.setPosition(634, 11);
					menuItem.y -= 170;
					menuItemBG.y -= 170;
					FlxTween.tween(menuItem, {y: 11}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.5,
						onComplete: function (twn:FlxTween) {
							selectedSomethin = false;
						}
					});
					FlxTween.tween(menuItemBG, {y: -14}, 0.7, {
						ease: FlxEase.quadOut,
						startDelay: 0.4
					});
			}
			menuItem.ID = i;
			
			menuItems.add(menuItem);
			menuItemsBG.add(menuItemBG);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (!Achievements.achievementsUnlocked[achievementID][1] && leDate.getDay() == 5 && leDate.getHours() >= 18) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			Achievements.achievementsUnlocked[achievementID][1] = true;
			giveAchievement();
			ClientPrefs.saveSettings();
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	var achievementID:Int = 0;
	function giveAchievement() {
		add(new AchievementObject(achievementID, camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement ' + achievementID);
	}
	#end

	var selectedSomethin:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			if (FlxG.keys.justPressed.LEFT)
				addAnswer('left');
			if (FlxG.keys.justPressed.UP)
				addAnswer('up');
			if (FlxG.keys.justPressed.DOWN)
				addAnswer('down');
			if (FlxG.keys.justPressed.RIGHT)
				addAnswer('right');

			if (controls.BACK)
			{
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'youtube' && !ashMode)
				{
					CoolUtil.browserLoad('https://www.youtube.com/channel/UCT_wYKD4twxoYOZt2ggXHlw');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					for (i in menuItems) {
						var menuItem = i;
						var menuItemBG = menuItemsBG.members[menuItems.members.indexOf(i)];
						switch (optionShit[menuItems.members.indexOf(i)]) {
							case 'story_mode':

								FlxTween.tween(menuItem, {x: 36 - 700}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0.1
								});
								FlxTween.tween(menuItemBG, {x: 0 - 700}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0
								});
							case 'freeplay':
								FlxTween.tween(menuItem, {x: 77 - 700}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0.1
								});
								FlxTween.tween(menuItemBG, {x: 0 - 700}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0
								});
							case 'youtube':
								FlxTween.tween(menuItem, {x: 728 + 600}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0.1
								});
								FlxTween.tween(menuItemBG, {x: 678 + 600}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0
								});
							case 'credits':
								FlxTween.tween(menuItem, {x: 851 + 600}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0.1
								});
								FlxTween.tween(menuItemBG, {x: 752 + 600}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0
								});
							case 'options':
								FlxTween.tween(menuItem, {y: 11 - 170}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0.1,
									onComplete: function (twn:FlxTween) {
										if (ashMode) {
											MusicBeatState.switchState(new AshMenu());
										} else {
											switch (optionShit[curSelected])
											{
												case 'story_mode':
													MusicBeatState.switchState(new StoryMenuState());
												case 'freeplay':
													MusicBeatState.switchState(new FreeplayState());
												case 'awards':
													MusicBeatState.switchState(new AchievementsMenuState());
												case 'credits':
													MusicBeatState.switchState(new CreditsState());
												case 'options':
													MusicBeatState.switchState(new OptionsState());
											}
										}
									}
								});
								FlxTween.tween(menuItemBG, {y: -14 - 170}, 0.7, {
									ease: FlxEase.quadOut,
									startDelay: 0
								});
						}
					}

					var daChoice:String = optionShit[curSelected];

					
					/*menuItems.forEach(function(spr:TheMenuItem)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							/*FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{*/
								
							//});
						
					//});
				}
			}
		}

		super.update(elapsed);

	}
	function logoAngle()
	{
		FlxTween.angle(logo, 10, -10, 4, {ease:FlxEase.quadInOut,
		onComplete: function(twn:FlxTween) {
			FlxTween.angle(logo, -10, 10, 4, {ease:FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {
				logoAngle();
			},});
		},});
	}
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if (ash.scale.x > 1) {
			FlxTween.tween(ash.scale, {x: 1, y: 1}, 0.07, {ease: FlxEase.quadOut});
			ashMode = false;
		}
		menuItems.forEach(function(spr:TheMenuItem)
		{
			if (spr.theTween.active)
				spr.theTween.cancel();
			spr.theTween = FlxTween.tween(spr.scale, {x: 0.8, y: 0.8}, 0.07, {ease: FlxEase.quadOut});
			spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);

			if (spr.ID == curSelected)
			{
				if (spr.theTween.active)
					spr.theTween.cancel();
				spr.theTween = FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.07, {ease: FlxEase.quadOut});
				spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
			}
		});
	}
	function addAnswer(thing:String) {
		realAnswer.push(thing);
		if (rightAnswer[realAnswer.length - 1] != thing) {
			if (thing == 'up') {
				realAnswer.splice(realAnswer.length - 1, realAnswer.length - 1);
			} else {
				realAnswer.splice(0, realAnswer.length);
			}
			/*if (rightAnswer[0] == thing) {
				addAnswer(thing);
			}*/
		} else {
			if (realAnswer.length == rightAnswer.length) {
				for (spr in menuItems) {
					if (spr.theTween.active)
						spr.theTween.cancel();
					spr.theTween = FlxTween.tween(spr.scale, {x: 0.8, y: 0.8}, 0.07, {ease: FlxEase.quadOut});
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
				}
	
				ashMode = true;
				FlxTween.tween(ash.scale, {x: 1.2, y: 1.2}, 0.07, {ease: FlxEase.quadOut});
			}
		}
		trace(realAnswer);
		trace(rightAnswer[realAnswer.length - 1]);
	}
}

class TheMenuItem extends FlxSprite
{
	public var theTween:FlxTween;
	public function new(?x:Int = 0, ?y:Int = 0)
	{
		super();
		theTween = FlxTween.tween(scale, {x: 1, y: 1}, 0.01, {});
	}
}