package;

import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
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

	public var daCheese:String;

	public var scoreText:FlxText;
	public var randomMovementX:Int = FlxG.random.int(1, 10);
	public var randomMovementY:Int = FlxG.random.int(1, 12);

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
		keepPlayerInBox(player);
		moveCheese();
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
	public function spawnCheese()
	{
		var randomX:Int = FlxG.random.int(0, 1200);
		var randomY:Int = FlxG.random.int(0, 600);
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

	public function feedMe()
	{
		addScore();
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
		score += Std.int(1 * scoreMultiplier);
		scoreText.text = "SCORE: " + Std.string(score);
	}

	public function showPopUp()
	{
		var randomPopUpNumber:Int = FlxG.random.int(1, 4);
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
		}
		popUp.loadGraphic("assets/images/popups/" + rPuS + ".png");
		popUp.screenCenter();
		add(popUp);
		FlxTween.tween(popUp, {alpha: 0}, 0.6);
		mickeySound = FlxG.sound.load("assets/sounds/mickey-mouse.ogg");
		mickeySound.play();
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
