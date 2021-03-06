package;

import BaseSequence.SequenceKind;
import GameMap.LogicalCoordinate;
import GameMap.GraphicalCoordinate;
import flash.display.Bitmap;
import flash.display.Stage;
import flash.ui.Keyboard;
import openfl.Assets;

// 移動キー入力の方向
enum Direction {
    Stop;
    Up;
    Down;
    Left;
    Right;
}

// マップに置かれているオブジェクトの種類
enum MapObject
{
    None;
    Player(id : String);
}

class GameSequence implements BaseSequence
{
    private var main:Main;
    private var stage:Stage;
    private var direction:Direction;
    private var myPos:LogicalCoordinate;
    private var map:GameMap;
    private var view:GameView;

    public function new(main:Main, stage:Stage)
    {
        this.main = main;
        this.stage = stage;
    }

    // 初期化
    public function start():Void
    {
        initMyUnit();
        initBoard();
    }

    private function initMyUnit():Void
    {
        direction = Direction.Stop;
        myPos = {x:0, y:0};
    }

    private function initBoard():Void
    {
        map = new GameMap();
        var me = MapObject.Player("me");
        var pos:LogicalCoordinate = {x: 0, y: 0};
        map.put(me, pos);

        view = new GameView(main);
        view.init(stage);
    }

    // メインループ
    public function update():SequenceKind
    {
        view.moveBall();
        inputDirection();
        if (main.count() % 4 == 0)
        {
            moveTokin();
        }

        // キーボードの Q で終了
        if (main.isKeyPress(Keyboard.Q))
        {
            view.clearObject();
            return SequenceKind.Title;
        }

        return SequenceKind.Stay;
    }

    private function moveTokin():Void
    {
        var oldPos : LogicalCoordinate = {x: myPos.x, y: myPos.y};

        if (direction == Direction.Up &&myPos.y > 0)
        {
            myPos.y -= 1;
        }
        else if (direction == Direction.Down && myPos.y < 8)
        {
            myPos.y += 1;
        }
        else if (direction == Direction.Left && myPos.x > 0)
        {
            myPos.x -= 1;
        }
        else if (direction == Direction.Right && myPos.x < 8)
        {
            myPos.x += 1;
        }
        // 移動していたらマップを書き換える
        if (myPos != oldPos) {
            map.put(MapObject.None, oldPos);
            map.put(MapObject.Player("me"), myPos);
        }
    }

    function inputDirection():Void
    {
        if (main.isKeyPress(Keyboard.UP))
        {
            direction = Direction.Up;
        }
        else if (main.isKeyPress(Keyboard.DOWN))
        {
            direction = Direction.Down;
        }
        else if (main.isKeyPress(Keyboard.LEFT))
        {
            direction = Direction.Left;
        }
        else if (main.isKeyPress(Keyboard.RIGHT))
        {
            direction = Direction.Right;
        }
        else
        {
            direction = Direction.Stop;
        }
    }

    private function loadBitmap(path:String):Bitmap
    {
        return new Bitmap(Assets.getBitmapData(path));
    }
}