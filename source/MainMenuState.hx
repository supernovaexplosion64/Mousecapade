package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
    public var button:FlxSprite;
    public var instruct:FlxSprite;
    public var buttonText:FlxText;
    public var instructText:FlxText;

    public var bg:FlxSprite;

    
    public var warning:FlxText;
    public var credits:FlxText;

    override public function create()
    {
    	super.create();

        bg = new FlxSprite();
		bg.loadGraphic("assets/images/bg-misery.png");
		bg.screenCenter();
		add(bg);

        button = new FlxSprite();
        button.makeGraphic(400, 150, FlxColor.LIME);
        button.screenCenter(X);
        button.y = 12;
        add(button);

        instruct = new FlxSprite();
        instruct.makeGraphic(400, 150, FlxColor.LIME);
        instruct.screenCenter(X);
        instruct.y = button.y + button.height + 12;
        add(instruct);

        buttonText = new FlxText();
        buttonText.text = 'PLAY MY GAME';
        buttonText.size = 32;
        buttonText.font = "Times New Roman";
        buttonText.x = button.x + (button.width / 2) - (buttonText.width / 2);
        buttonText.y = button.y + (button.height / 2) - (buttonText.height / 2);
        add(buttonText);

        instructText = new FlxText();
        instructText.text = 'instructions';
        instructText.size = 32;
        instructText.font = "Times New Roman";
        instructText.x = instruct.x + (instruct.width / 2) - (instructText.width / 2);
        instructText.y = instruct.y + (instruct.height / 2) - (instructText.height / 2);
        add(instructText);

        warning = new FlxText();
        warning.text = 'Please DO NOT play this game if you are a person with epilepsy and/or prone to seizures.';
        warning.fieldWidth = FlxG.width;
        warning.size = 36;
        warning.font = "Times New Roman";
        warning.screenCenter(X);
        warning.y = 500;
        add(warning);

        credits = new FlxText();
        credits.text = 'Created by Rico W./supernovaexplosion64: 2026-2026';
        credits.font = "Times New Roman";
        credits.size = 24;
        credits.x = 12;
        credits.y = FlxG.height - credits.height - 12;
        add(credits);

		FlxG.sound.playMusic("assets/music/mainmenu.ogg", 1, true);
    }

    override public function update(elapsed:Float)
    {
    	super.update(elapsed);

        if (FlxG.mouse.overlaps(button))
        {
            for (e in [button, buttonText])
            {
                FlxTween.tween(e, {alpha: 0.6}, 0.6);
            }

            if (FlxG.mouse.justPressed)
            {
                FlxG.switchState(new PlayState());
            }
        }
        else
        {
            if (button.alpha < 1)
            {
                for (e in [button, buttonText])
                {
                    FlxTween.tween(e, {alpha: 1}, 0.6);
                }
            }
        }

        if (FlxG.mouse.overlaps(instruct))
        {
            for (e in [instruct, instructText])
            {
                FlxTween.tween(e, {alpha: 0.6}, 0.6);
            }

            if (FlxG.mouse.justPressed)
            {
                FlxG.switchState(new InstructionGuideState());
            }
        }
        else
        {
            if (instruct.alpha < 1)
            {
                for (e in [instruct, instructText])
                {
                    FlxTween.tween(e, {alpha: 1}, 0.6);
                }
            }
        }
    }
}