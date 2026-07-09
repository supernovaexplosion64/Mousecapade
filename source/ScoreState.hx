package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

class ScoreState extends FlxState
{
    public var scorePre:Int;
    public var scorePreText:FlxText;

    override public function create():Void
    {
    	super.create();

        scorePre = PlayState.score;
        scorePreText = new FlxText();
        scorePreText.text = Std.string(scorePre);
        scorePreText.size = 48;
        scorePreText.font = "Times New Roman";
        scorePreText.x = 12;
        scorePreText.y = 12;
        add(scorePreText);
		if (FlxG.sound.music == null) // don't restart the music if it's already playing BLUD
		{
			#if desktop
			FlxG.sound.playMusic("assets/music/welcome-old.ogg", 1, true);
			#else
			FlxG.sound.playMusic("assets/music/welcome-old.mp3", 1, true);
			#end
		}
    }

    override public function update(elapsed:Float):Void
    {
        #if debug
        if (FlxG.keys.justPressed.Q)
		{
			FlxG.switchState(new PlayState());
		}
        if (FlxG.keys.justPressed.W)
		{
			FlxG.switchState(new InstructionGuideState());
		}
		if (FlxG.keys.justPressed.E)
		{
			FlxG.switchState(new MainMenuState());
		}
		#end
    	super.update(elapsed);
    }
}