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

	public var scoreText:FlxText;
	public var randomCheeseNum:Int = FlxG.random.int(1, 5);

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

		spawnCheese();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.pixelPerfectOverlap(player, cheese))
		{
			feedMe();
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
	public function returnDaCheese():String
	{
		if (randomCheeseNum == 5)
		{
			return 'bluecheese';
		}
		else
		{
			return 'cheese';
		}
	}
	public function spawnCheese()
	{
		var randomX:Int = FlxG.random.int(0, 1200);
		var randomY:Int = FlxG.random.int(0, 600);
		returnDaCheese();
		if (returnDaCheese() == 'bluecheese')
		{
			cheese.loadGraphic("assets/images/items/bluecheese.png");
		}
		cheese.x = randomX;
		cheese.y = randomY;
		add(cheese);
	}

	public function feedMe()
	{
		addScore();
		remove(cheese);
		spawnCheese();
		showPopUp();
	}

	public function addScore()
	{
		scoreMultiplier = 1;
		score += Std.int(1 * scoreMultiplier);
		scoreText.text = "SCORE: " + Std.string(score);
	}

	public function showPopUp()
	{
		popUp = new FlxSprite();
		popUp.loadGraphic("assets/images/popups/revenge.png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/mickey-mouse.ogg");
		mickeySound.play();
	}
}
