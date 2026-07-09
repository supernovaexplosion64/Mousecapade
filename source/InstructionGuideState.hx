package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class InstructionGuideState extends FlxState
{
    public var text:FlxText;

    public var exit:FlxSprite;
    public var exitText:FlxText;

    public var enemyExample:FlxSprite;
    public var enemyExample2:FlxSprite;

    public var bg:FlxSprite;

	public var outputSuffix:String;

    override public function create()
    {
    	super.create();

		#if desktop
		outputSuffix = '.ogg';
		#else
		outputSuffix = '.mp3';
		#end

        bg = new FlxSprite();
		bg.loadGraphic("assets/images/bg.png");
		bg.screenCenter();
		add(bg);

        text = new FlxText();
		text.text = 'how 2 play\ntuoch da cheses\ndogde teh bad gyus\nget hgih scroe adn win';
        text.font = 'Times New Roman';
        text.size = 48;
        text.x = 12;
        text.y = 12;
        add(text);

        exit = new FlxSprite();
        exit.makeGraphic(72, 72, FlxColor.RED);
        exit.x = FlxG.width - exit.width - 12;
        exit.y = 12;
        add(exit);

        exitText = new FlxText();
        exitText.text = 'EXIT';
        exitText.size = 18;
        exitText.x = exit.x + (exit.width / 2) - (exitText.width / 2);
        exitText.y = exit.y + (exit.height / 2) - (exitText.height / 2);
        add(exitText);

        enemyExample = new FlxSprite();
        enemyExample.loadGraphic("assets/images/enemies/wega.png");
        enemyExample.x = text.x + 480;
        enemyExample.y = text.y + 72 + 12;
        add(enemyExample);

        enemyExample2 = new FlxSprite();
        enemyExample2.loadGraphic("assets/images/enemies/fnati.png");
        enemyExample2.x = enemyExample.x + enemyExample.width + 12;
        enemyExample2.y = enemyExample.y;
        add(enemyExample2);

        if (FlxG.sound.music == null) // don't restart the music if it's already playing BLUD
		{
			FlxG.sound.playMusic("assets/music/mainmenu" + outputSuffix, 1, true);
		}
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(exit))
        {
            for (e in [exit, exitText])
            {
                FlxTween.tween(e, {alpha: 0.6}, 0.6);
            }

            if (FlxG.mouse.justPressed)
            {
                FlxG.switchState(new MainMenuState());
            }
        }

    	super.update(elapsed);
    }
}