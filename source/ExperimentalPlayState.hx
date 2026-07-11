package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class ExperimentalPlayState extends FlxState
{
    public var cheeseGroup:FlxTypedGroup<FlxSprite>;
    public var cheese:FlxSprite;
    
    override public function create()
    {
    	super.create();

        cheese = new FlxSprite();
		cheese.loadGraphic("assets/images/items/cheese.png");

        cheeseGroup = new FlxTypedGroup<FlxSprite>();
        add(cheeseGroup);
    }

    override public function update(elapsed:Float)
    {
        spawnCheese();
    	super.update(elapsed);
    }

    public function spawnCheese()
    {
        if (FlxG.random.bool(1))
        {
            var randomX:Int = FlxG.random.int(0, 1212);
		    var randomY:Int = FlxG.random.int(0, 656);
            cheeseGroup.add(cheese);
            cheese.x = randomX;
		    cheese.y = randomY;  
            new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				cheeseGroup.remove(cheese);
			});
        }
    }
}