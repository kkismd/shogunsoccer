package;

import flash.geom.Point;
import GameSequence.MapObject;
class GameMap {
    private var map:Array<MapObject>;
    private var origin:Point;

    public function new(origin:Point)
    {
        this.origin = origin;

        map = new Array<MapObject>();
        for (i in 0...81)
        {
            map.push(MapObject.None);
        }
    }

    public function put(me:MapObject, pos:Point):Void
    {
        var address = pointToAddress(pos);
        map[address] = me;
    }

    public function at(pos:Point):MapObject
    {
        var address = pointToAddress(pos);
        return map[address];
    }

    private function pointToAddress(point:Point):Int
    {
        return Std.int(point.x + point.y * 9);
    }

    private function getUnitPos(pos:Point):Point {
        var posX = (pos.x * 30 + 15) * 1.5 + origin.x;
        var posY = (pos.y * 32 + 15) * 1.5 + origin.y;
        return new Point(posX, posY);
    }
}