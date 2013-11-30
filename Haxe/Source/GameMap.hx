package;

import flash.geom.Point;
import GameSequence.MapObject;
class GameMap {
    private var map:Array<MapObject>;

    public function new()
    {
        map = new Array<MapObject>();
        for (i in 0...81)
        {
            map[i] = MapObject.None;
        }
    }

    public function put(me:MapObject, pos:LogicalCoordinate):Void
    {
        var address = pointToAddress(pos);
        map[address] = me;
    }

    public function at(pos:LogicalCoordinate):MapObject
    {
        var address = pointToAddress(pos);
        return map[address];
    }

    private function pointToAddress(point:LogicalCoordinate):Int
    {
        return Std.int(point.x + point.y * 9);
    }
}

typedef LogicalCoordinate = {
    x: Int,
    y: Int,
}

typedef GraphicalCoordinate = {
    x: Float,
    y: Float,
}

