package;

import GameSequence.MapObject;
import flash.geom.Point;
import massive.munit.Assert;
class GameMapTest
{
    private var gameMap:GameMap;
    public function new()
    {

    }

    @Before
    public function setup():Void
    {
        gameMap = new GameMap(new Point(0, 0));
    }

    @Test
    public function testNew():Void
    {
        Assert.isType(gameMap, GameMap);
    }

    @Test
    public function testFoo(): Void
    {
        var me = MapObject.Player('me');
        var pos = new Point(0, 0);
        gameMap.put(me, pos);
        Assert.areEqual(gameMap.at(pos), me);
    }
}