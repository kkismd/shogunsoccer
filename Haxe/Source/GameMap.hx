package;

import GameView.IObserver;
import GameSequence.MapObject;

interface IObservable
{
    function attatch(observer:IObserver):Void;
    function detatch(observer:IObserver):Void;
    function notify():Void;
}

class GameMap implements IObservable {
    private var map:Array<MapObject>;
    private var observers:Array<IObserver>;

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
        notify();
    }

    public function at(pos:LogicalCoordinate):MapObject
    {
        var address = pointToAddress(pos);
        return map[address];
    }

    public function find(key:String):LogicalCoordinate
    {
        for (i in 0...81)
        {
            if (map[i] == MapObject.Player(key))
            {
                return {x: 0, y: 0};
            }
        }
        // TODO 見つからなかったときに返す値を考える
        return {x: 0, y: 0};
    }

    public function attatch(observer:IObserver):Void
    {
        observers.push(observer);
    }
    public function detatch(observer:IObserver):Void
    {
        observers.remove(observer);
    }
    public function notify():Void
    {
        for (observer in observers)
        {
            observer.update();
        }
    }

    private function pointToAddress(point:LogicalCoordinate):Int
    {
        return Std.int(point.x + point.y * 9);
    }
}

// 9x9の論理座標系
typedef LogicalCoordinate = {
    x: Int,
    y: Int,
}

// flashの扱う物理座標系
typedef GraphicalCoordinate = {
    x: Float,
    y: Float,
}

