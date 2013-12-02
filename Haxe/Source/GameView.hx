package;
import flash.display.Stage;
import GameMap.GraphicalCoordinate;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import motion.Actuate;

interface IObserver
{
    function update():Void;
}

class GameView implements IObserver
{
    private var main:Main;
    private var gameMap:GameMap;
    private var board:Bitmap;
    private var ballBase:Sprite;
    private var ball:Bitmap;
    private var ballMoveX = 3.0;
    private var ballMoveY = 4.0;
    private var tokin:Bitmap;

    public function new(main:Main, gameMap:GameMap)
    {
        this.main = main;
        this.gameMap = gameMap;
    }

    public function init(stage:Stage):Void
    {
        initBoard();
        initBall();
        initUnit(stage);
        gameMap.attatch(this);
    }

    public function clearObject():Void
    {
        main.removeChild(ballBase);
        main.removeChild(tokin);
    }

    public function boardOffset():GraphicalCoordinate
    {
        return { x: board.x, y: board.y };
    }

    public function update():Void
    {
        var pos:LogicalCoordinate = gameMap.find("me");
        animateTokin(pos);
    }

    private function animateTokin(pos:LogicalCoordinate):Void
    {
        var newPos = getUnitPos(pos);
        Actuate.tween(tokin, 1, {x: newPos.x, y: newPos.y});
    }

    private function getUnitPos(pos:LogicalCoordinate):GraphicalCoordinate
    {
        var posX = (pos.x * 30 + 15) * 1.5 + board.x;
        var posY = (pos.y * 32 + 15) * 1.5 + board.y;
        return {x: posX, y: posY};
    }


    private function initBoard():Void
    {
        board = loadBitmap('assets/japanese-chess-bds.jpg');
        board.x = 50;
        board.y = 50;
        board.scaleX = 1.5;
        board.scaleY = 1.5;
        main.addChild(board);
    }

    private function initBall():Void
    {
        ballBase = new Sprite();
        ballBase.x = 60;
        ballBase.y = 50;
        main.addChild(ballBase);

        ball = loadBitmap('assets/ball.png');
        ball.x = 0 - ball.width / 2;
        ball.y = 0 - ball.height / 2;
        ballBase.addChild(ball);
    }

    private function initUnit(stage:Stage):Void
    {
        tokin = loadBitmap('assets/sgs18.png');
        tokin.x = (stage.stageWidth - tokin.width) / 2;
        tokin.y = (stage.stageHeight - tokin.height) / 2;
        tokin.scaleX = 1.5;
        tokin.scaleY = 1.5;
        main.addChild(tokin);
    }

    private function loadBitmap(path:String):Bitmap
    {
        return new Bitmap(Assets.getBitmapData(path));
    }

    private function right_bound():Float
    {
        return board.x + board.width - ball.width / 2;
    }

    private function left_bound():Float
    {
        return board.x + ball.width / 2;
    }

    private function bottom_bound():Float
    {
        return board.y + board.height - ball.height / 2;
    }

    private function top_bound():Float
    {
        return board.y + ball.height / 2;
    }

    public function moveBall():Void
    {
        // ボールの外見を回転させる
        ballBase.rotation += 3;

        // 左右の動き
        if (ballMoveX > 0)
        {
            if (ballBase.x < right_bound())
                ballBase.x += ballMoveX; // はみ出していないなら右に動く
            else
                ballMoveX = -ballMoveX; // はみだしているなら反転させる
        }
        else
        {
            if (ballBase.x > left_bound())
                ballBase.x += ballMoveX; // はみ出していないなら左に動く
            else
                ballMoveX = -ballMoveX; // ボールが左向きではみ出しているなら反転させる
        }

        // 上下の動き
        if (ballMoveY > 0)
        {
            if (ballBase.y < bottom_bound())
                ballBase.y += ballMoveY; // ボールが下向きではみだしていない 下に動く
            else
                ballMoveY = -ballMoveY; // 下向きではみ出している 反転
        }
        else
        {
            if (ballBase.y > top_bound())
                ballBase.y += ballMoveY; // 上向きではみ出していない 上に動く
            else
                ballMoveY = -ballMoveY; // 上向きではみ出している 反転させる
        }
    }
}