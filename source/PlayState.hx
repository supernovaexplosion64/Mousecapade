package;

#if desktop
import Sys;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
#if (desktop || android)
import hxcodec.flixel.FlxVideo;
#end

class PlayState extends FlxState
{
	public static var gameJustStarted:Bool = false;
	public var player:FlxSprite;
	public var cheese:FlxSprite;
	public var popUp:FlxSprite;
	public var mickeySound:FlxSound;

	public var bg:FlxSprite;

	public static var score:Int = 0;
	public var scoreMultiplier:Float = 1;
	public var decreasingMultiplier:Float = 100;

	public var daCheese:String;

	public var scoreText:FlxText;
	public var randomMovementX:Int = FlxG.random.int(1, 10);
	public var randomMovementY:Int = FlxG.random.int(1, 12);

	public var time:Float = 120;
	public var timeText:FlxText;

	public var wega:FlxSprite;
	public var wegaTimes:Int = 0;
	public var takeAwayPoints:Bool = false;

	public var pickUp:FlxSprite;
	public var videoPlaying = false;

	public static var enemiesCaught:Int = 0;
	public static var cheesesCaught:Int = 0;

	public var phoneAppear:Bool = false;
	public var wegaAppear:Bool = false;

	public var outputSuffix:String;
	public var bonusStreak:Int = 0;

	public var randomObj:Array<FlxSprite>;

	override public function create()
	{
		super.create();
		gameJustStarted = true;
		if (gameJustStarted)
		{
			score = 0;
			enemiesCaught = 0;
			cheesesCaught = 0;
			bonusStreak = 0;
		}
		gameJustStarted = false;

		bg = new FlxSprite();
		bg.loadGraphic("assets/images/bg.png");
		bg.screenCenter();
		add(bg);

		player = new FlxSprite();
		player.loadGraphic("assets/images/player.png");
		player.setGraphicSize(128, 128);
		player.screenCenter(X);
		player.y = FlxG.height - 256;
		add(player);

		#if desktop
		outputSuffix = '.ogg';
		#else
		outputSuffix = '.mp3';
		#end

		FlxG.sound.playMusic("assets/music/welcome-old" + outputSuffix, 1, true);

		cheese = new FlxSprite();
		cheese.loadGraphic("assets/images/items/cheese.png");

		scoreText = new FlxText();
		scoreText.size = 48;
		scoreText.font = "Times New Roman";
		scoreText.text = "SCORE: " + Std.string(score);
		add(scoreText);

		timeText = new FlxText();
		timeText.size = 48;
		timeText.font = "Times New Roman";
		timeText.text = "TIME: " + Std.string(time);
		timeText.y = scoreText.y + timeText.height + 12;
		add(timeText);

		wega = new FlxSprite();
		wega.loadGraphic("assets/images/enemies/wega.png");
		wega.x = wega.width * -1;
		wega.y = wega.height * -1;

		pickUp = new FlxSprite();
		pickUp.loadGraphic("assets/images/enemies/fnati.png");
		pickUp.x = pickUp.width * -1;
		pickUp.y = pickUp.height - 1;
	}

	override public function update(elapsed:Float)
	{
		time -= 1 * FlxG.elapsed;
		decreasingMultiplier -= 8 * FlxG.elapsed;
		if (decreasingMultiplier < 2)
			decreasingMultiplier = 2;
		if (bonusStreak > 100)
			bonusStreak = 100;
		timeText.text = "TIME: " + Std.string(Std.int(time));
		timeText.updateHitbox();
		spawnRandomObj(2);
		keepPlayerInBox(player);
		moveCheese(cheese);
		if (FlxG.pixelPerfectOverlap(player, cheese))
		{
			feedMe();
		}

		if (FlxG.pixelPerfectOverlap(player, wega) && wegaAppear)
		{
			touchWega();
		}

		if (FlxG.pixelPerfectOverlap(player, pickUp) && phoneAppear)
		{
			loadUpVideo();
		}

		if (FlxG.keys.pressed.LEFT)
		{
			player.x -= 640 * elapsed;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			player.x += 640 * elapsed;
		}
		if (FlxG.keys.pressed.UP)
		{
			player.y -= 640 * elapsed;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			player.y += 640 * elapsed;
		}
		if (time <= 0)
		{
			FlxG.switchState(new ScoreState());
		}
		#if debug
		if (FlxG.keys.justPressed.Q)
		{
			FlxG.switchState(new ScoreState());
		}
		#end
		super.update(elapsed);
	}
	/*public function returnDaCheese()
	{
		if (randomCheeseNum == 5)
		{
			daCheese = 'blue';
		}
		else
		{
			daCheese = 'normal';
		}
		return daCheese;
	}*/
	public function updateText()
	{
		scoreText.text = "SCORE: " + Std.string(score);
	}
	public function spawnCheese()
	{
		var randomX:Int = FlxG.random.int(0, 1212);
		var randomY:Int = FlxG.random.int(0, 656);
		//returnDaCheese();
		var randomCheeseNum:Int = FlxG.random.int(1, 10);
		if (randomCheeseNum == 1)
		{
			daCheese = 'red';
		}
		else if (randomCheeseNum >= 2 && randomCheeseNum <= 3)
		{
			daCheese = 'blue';
		}
		else
		{
			daCheese = 'normal';
		}

		switch (daCheese)
		{
			case 'red':
				cheese.loadGraphic("assets/images/items/redcheese.png");
			case 'blue':
				cheese.loadGraphic("assets/images/items/bluecheese.png");
				//cheese.x += randomMovement;
				//cheese.y += randomMovement;
			default:
				cheese.loadGraphic("assets/images/items/cheese.png");
		}
		cheese.x = randomX;
		cheese.y = randomY;
		add(cheese);
	}

	public function spawnWega()
	{
		if (FlxG.random.bool(0.5))
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				wegaAppear = true;
			});
			var randomX:Int = FlxG.random.int(0, 1212);
			var randomY:Int = FlxG.random.int(0, 656);
			// wega.alpha = 0;
			wega.x = randomX;
			wega.y = randomY;
			add(wega);
			wega.updateHitbox();
			// FlxTween.tween(wega, {alpha: 1}, 0.2);
			new FlxTimer().start(6, function(tmr:FlxTimer)
			{
				wega.x = wega.x *= -1;
				wega.y = wega.y *= -1;
				remove(wega);
				wega.updateHitbox();
				wegaAppear = false;
			});
		}
		wega.updateHitbox();
	}

	public function touchWega()
	{
		wega.x = wega.x *= -1;
		wega.y = wega.y *= -1;
		bonusStreak = 0;
		takeAwayScore();
		remove(wega);
		wegaAppear = false;
		wegaPopUp();
		updateText();
		enemiesCaught += 1;
		#if debug
		trace(enemiesCaught);
		#end
	}

	public function spawnPhone()
	{
		if (FlxG.random.bool(0.06))
		{
			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				phoneAppear = true;
			});
			var randomX:Int = FlxG.random.int(0, 1212);
			var randomY:Int = FlxG.random.int(0, 656);
			// pickUp.alpha = 0;
			pickUp.x = randomX;
			pickUp.y = randomY;
			add(pickUp);
			pickUp.updateHitbox();
			// FlxTween.tween(pickUp, {alpha: 1}, 0.2);
			new FlxTimer().start(6, function(tmr:FlxTimer)
			{
				pickUp.x = pickUp.x *= -1;
				pickUp.y = pickUp.y *= -1;
				remove(pickUp);
				pickUp.updateHitbox();
				phoneAppear = false;
			});
		}
		pickUp.updateHitbox();
	}

	public function feedMe()
	{
		cheese.x *= -1;
		cheese.y *= -1;
		cheese.updateHitbox();
		bonusStreak += 1;
		addScore();
		decreasingMultiplier = 100 - (2 * wegaTimes);
		remove(cheese);
		// spawnCheese();
		showPopUp();
		cheesesCaught += 1;
		#if debug
		trace(cheesesCaught);
		#end
	}

	/*public function randomMovementSucks()
	{
		var randomMovement:Int = FlxG.random.int(1, 10);
		if (FlxG.random.bool(5))
		{
			randomMovement *= -1;
		}
		cheese.x += randomMovement;
		cheese.y += randomMovement;
		trace(randomMovement);
	}*/

	public function moveCheese(obj:FlxSprite)
	{
		if (obj != cheese)
		{
			if (FlxG.random.bool(3))
			{
				randomMovementX *= -1;
				randomMovementY *= -1;
			}
			obj.x += randomMovementX;
			obj.y += randomMovementY;
		}
		else
		{
			if (daCheese == 'blue')
			{
				if (FlxG.random.bool(2))
				{
					randomMovementX *= -1;
				}
				if (FlxG.random.bool(3))
				{
					randomMovementY *= -1;
				}
				obj.x += randomMovementX;
				obj.y += randomMovementY;
			}
			else if (daCheese == 'red')
			{
				if (FlxG.random.bool(4))
				{
					randomMovementX *= -1;
				}
				if (FlxG.random.bool(5))
				{
					randomMovementY *= -1;
				}
				obj.x += randomMovementX * 2;
				obj.y += randomMovementY * 2;
			}
		}
		obj.updateHitbox();
		keepPlayerInBox(obj);
	}

	public function addScore()
	{
		switch (daCheese)
		{
			case 'red':
				scoreMultiplier = 10;
			case 'blue':
				scoreMultiplier = 5;
			default:
				scoreMultiplier = 1;
		}
		score += Std.int((100 * scoreMultiplier) + decreasingMultiplier + (bonusStreak * 75));
		updateText();
	}

	public function takeAwayScore()
	{
		takeAwayPoints = true;
		if (takeAwayPoints)
		{
			takeAwayPoints = false;
			wegaTimes += 1;
			if (wegaTimes > 50)
				wegaTimes = 50;
			trace(wegaTimes);
			score -= 50 * wegaTimes;
		}
	}

	public function showPopUp()
	{
		var randomPopUpNumber:Int = FlxG.random.int(1, 11);
		var rPuS:String = '';
		popUp = new FlxSprite();
		switch (randomPopUpNumber)
		{
			case 1:
				rPuS = 'revenge';
			case 2:
				rPuS = 'quiddy';
			case 3:
				rPuS = 'feedme';
			case 4:
				rPuS = 'donald';
			case 5:
				rPuS = 'fat';
			case 6:
				rPuS = 'omg';
			case 7:
				rPuS = 'phone';
			case 8:
				rPuS = 'billy';
			case 9:
				rPuS = 'skinny';
			case 10:
				rPuS = 'madness';
			case 11:
				rPuS = 'alpha';
		}
		popUp.loadGraphic("assets/images/popups/" + rPuS + ".png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/mickey-mouse" + outputSuffix);
		mickeySound.play();
		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			remove(popUp);
		});
	}

	public function wegaPopUp()
	{
		popUp = new FlxSprite();
		popUp.loadGraphic("assets/images/popups/scream.png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/scream" + outputSuffix);
		mickeySound.play();
		FlxG.camera.shake();
		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			remove(popUp);
		});
	}

	public function loadUpVideo()
	{
		phoneAppear = false;
		bonusStreak = 0;
		pickUp.x = pickUp.x *= -1;
		pickUp.y = pickUp.y *= -1;
		remove(pickUp);
		pickUp.updateHitbox();
		#if (desktop || android)
		var video:FlxVideo = new FlxVideo();
		if (!videoPlaying)
		{
			FlxG.sound.music.pause();
			videoPlaying = true;
			video.play("assets/videos/pick-up-the-phone.mp4");
		}
		new FlxTimer().start(5, function(tmr:FlxTimer)
		{
			#if desktop
			if (FlxG.random.bool(10))
			{
				Sys.exit(0);
			}
			else
			{
				FlxG.switchState(new MainMenuState());
				FlxG.sound.music.resume();
				video.dispose();
			}
			#else
			FlxG.switchState(new MainMenuState());
			FlxG.sound.music.resume();
			video.dispose();
			#end
		});
		#else
		if (FlxG.random.bool(20))
		{
			FlxG.openURL("https://youtu.be/ChnqPMwQIKc");
			FlxG.switchState(new MainMenuState());
		}
		else
		{
			FlxG.openURL("https://youtu.be/UwGiXZOC-SQ");
			FlxG.switchState(new MainMenuState());
		}
		#end
	}

	public function keepPlayerInBox(obj:FlxSprite)
	{
		if (obj.x < 0)
			obj.x = 0;
		if (obj.x > FlxG.width - obj.width)
			obj.x = FlxG.width - obj.width;
		if (obj.y < 0)
			obj.y = 0;
		if (obj.y > FlxG.height - obj.height)
			obj.y = FlxG.height - obj.height;
		obj.updateHitbox();
	}
	/*public function spawnRandomObj(obj:FlxSprite, chanceAppear:Float = 0.1)
		{
			if (FlxG.random.bool(chanceAppear))
			{
				var maxPositionX:Int = Std.int(FlxG.width - obj.width);
				var maxPositionY:Int = Std.int(FlxG.height - obj.height);
				var randomX:Int = FlxG.random.int(0, maxPositionX);
				var randomY:Int = FlxG.random.int(0, maxPositionY);
				daCheese = returnDaCheese();

				if (obj == cheese)
				{
					switch (daCheese)
					{
						case 'red':
							cheese.loadGraphic("assets/images/items/redcheese.png");
						case 'blue':
							cheese.loadGraphic("assets/images/items/bluecheese.png");
						default:
							cheese.loadGraphic("assets/images/items/cheese.png");
					}
				}
				cheese.x = randomX;
				cheese.y = randomY;
				add(cheese);
			}
	}*/
	public function spawnRandomObj(randomAppear:Float = 1)
	{
		var pemdas:Int = FlxG.random.int(1, 10);
		if (FlxG.random.bool(randomAppear))
		{
			if (pemdas >= 3)
				spawnCheese();
			else if (pemdas == 2)
				spawnWega();
			else
				spawnPhone();
		}
	}

	public function returnDaCheese():String
	{
		var randomCheese:Int = FlxG.random.int(1, 10);
		if (randomCheese <= 1)
			return 'red';
		if (randomCheese <= 3)
			return 'blue';
		return 'cheese';
	}

	public function pleaseExcuseMyBadCodingSkills():FlxSprite
	{
		var randomObjAppear:Int = FlxG.random.int(1, 10);
		if (randomObjAppear >= 3)
			return cheese;
		if (randomObjAppear >= 2)
			return wega;
		return pickUp;
	}
}
