package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class PlayState extends FlxState
{
	public var player:FlxSprite;
	public var cheese:FlxSprite;
	public var popUp:FlxSprite;
	public var mickeySound:FlxSound;

	public var score:Int = 0;
	public var scoreMultiplier:Float = 1;
	public var decreasingMultiplier:Float = 100;

	public var daCheese:String;

	public var scoreText:FlxText;
	public var randomMovementX:Int = FlxG.random.int(1, 10);
	public var randomMovementY:Int = FlxG.random.int(1, 12);

	public var time:Float = 115;
	public var timeText:FlxText;

	public var wega:FlxSprite;
	public var wegaTimes:Int = 0;
	public var takeAwayPoints:Bool = false;

	override public function create()
	{
		super.create();
		player = new FlxSprite();
		player.loadGraphic("assets/images/player.png");
		player.setGraphicSize(128, 128);
		player.screenCenter(X);
		player.y = FlxG.height - 256;
		add(player);

		if (FlxG.sound.music == null) // don't restart the music if it's already playing BLUD
		{
			FlxG.sound.playMusic("assets/music/welcome-old.ogg", 1, true);
		}

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

		spawnCheese();
	}

	override public function update(elapsed:Float)
	{
		time -= 1 * FlxG.elapsed;
		decreasingMultiplier -= 8 * FlxG.elapsed;
		timeText.text = "TIME: " + Std.string(Std.int(time));
		timeText.updateHitbox();

		spawnWega();
		keepPlayerInBox(player);
		moveCheese();
		if (FlxG.pixelPerfectOverlap(player, cheese))
		{
			feedMe();
		}

		if (FlxG.pixelPerfectOverlap(player, wega))
		{
			touchWega();
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
			var randomX:Int = FlxG.random.int(0, 1212);
			var randomY:Int = FlxG.random.int(0, 656);
			wega.x = randomX;
			wega.y = randomY;
			add(wega);
		}
	}

	public function touchWega()
	{
		wega.x = wega.x *= -1;
		wega.y = wega.y *= -1;
		takeAwayScore();
		remove(wega);
		wegaPopUp();
		updateText();
	}

	public function feedMe()
	{
		addScore();
		decreasingMultiplier = 100 - (2 * wegaTimes);
		remove(cheese);
		spawnCheese();
		showPopUp();
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

	public function moveCheese()
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
			cheese.x += randomMovementX;
			cheese.y += randomMovementY;
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
			cheese.x += randomMovementX * 2;
			cheese.y += randomMovementY * 2;
		}
		cheese.updateHitbox();
		keepPlayerInBox(cheese);
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
		score += Std.int(1 * scoreMultiplier * decreasingMultiplier);
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
			score -= 15 * wegaTimes;
		}
	}

	public function showPopUp()
	{
		var randomPopUpNumber:Int = FlxG.random.int(1, 7);
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
		}
		popUp.loadGraphic("assets/images/popups/" + rPuS + ".png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/mickey-mouse.ogg");
		mickeySound.play();
	}

	public function wegaPopUp()
	{
		popUp = new FlxSprite();
		popUp.loadGraphic("assets/images/popups/scream.png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/scream.ogg");
		mickeySound.play();
		FlxG.camera.shake();
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
}
