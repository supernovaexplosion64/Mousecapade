package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

class ScoreState extends FlxState
{
    public var scorePre:Int;
    public var scorePreText:FlxText;
	public var rankingText:FlxText;

	public var outputSuffix:String;

    override public function create():Void
    {
    	super.create();

		#if desktop
		outputSuffix = '.ogg';
		#else
		outputSuffix = '.mp3';
		#end

        scorePre = PlayState.score;
        scorePreText = new FlxText();
        scorePreText.text = Std.string(scorePre);
        scorePreText.size = 48;
        scorePreText.font = "Times New Roman";
        scorePreText.x = 12;
        scorePreText.y = 12;
        add(scorePreText);
		rankingText = new FlxText();
		rankingText.text = returnRankings();
		rankingText.size = 48;
		rankingText.font = "Times New Roman";
		rankingText.x = 12;
		rankingText.y = scorePreText.x + scorePreText.height + 12;
		add(rankingText);
		if (FlxG.sound.music == null) // don't restart the music if it's already playing BLUD
		{
			FlxG.sound.playMusic("assets/music/welcome-old" + outputSuffix, 1, true);
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
	public function returnRankings():String
	{
		if (scorePre >= 50000)
			return 'S++';
		if (scorePre >= 40000)
			return 'S+';
		if (scorePre >= 35000)
			return 'S';
		if (scorePre >= 30000)
			return 'S-';
		if (scorePre >= 25000)
			return 'A+';
		if (scorePre >= 20000)
			return 'A';
		if (scorePre >= 18000)
			return 'A-';
		if (scorePre >= 16000)
			return 'B+';
		if (scorePre >= 14000)
			return 'B';
		if (scorePre >= 12000)
			return 'B-';
		if (scorePre >= 10000)
			return 'C+';
		if (scorePre >= 8000)
			return 'C';
		if (scorePre >= 6000)
			return 'C-';
		if (scorePre >= 5000)
			return 'D+';
		if (scorePre >= 4000)
			return 'D';
		if (scorePre >= 3000)
			return 'D-';
		if (scorePre >= 2000)
			return 'F+';
		if (scorePre >= 1000)
			return 'F';
		return 'F-';
	}
}