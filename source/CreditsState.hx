package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class CreditsState extends FlxState
{
    public var credText:FlxText;
    public var specialText:FlxText;
    public var outputSuffix:String;
    public var bg:FlxSprite;

    public var exit:FlxSprite;
    public var exitText:FlxText;

    override public function create():Void
    {
    	super.create();

        #if desktop
		outputSuffix = '.ogg';
		#else
		outputSuffix = '.mp3';
		#end

        bg = new FlxSprite();
		bg.loadGraphic("assets/images/bg-misery.png");
		bg.screenCenter();
		add(bg);

        credText = new FlxText();
        credText.text = 'game by ME (rico)\nmain menu song by ME (rico)\nwelcome old (play theme) by crisnosensexd';
        credText.size = 36;
		credText.font = "Times New Roman";
        credText.x = 12;
        credText.y = 12;
        add(credText);
        
		specialText = new FlxText();
        specialText.text = 'special thanks to\nthe ancient mice dev team\nbindu\nand vs mouse: cheesed up';
        specialText.size = 36;
        specialText.font = "Times New Roman";
		specialText.x = 12;
		specialText.y = FlxG.height - specialText.height - 12;
		add(specialText);

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
    }

    override public function update(elapsed:Float):Void
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