package;
import GameSequence.Direction;
import flash.display.Sprite;
import openfl.Assets;
import flash.display.Bitmap;

class GameView
{
    private var main:Main;
    private var board:Bitmap;
    private var ballBase:Sprite;
    private var ball:Bitmap;
    private var direction:Direction;
    private var ballMoveX = 3.0;
    private var ballMoveY = 4.0;

    public function new(main:Main)
    {
        this.main = main;
    }

    public function init():Bitmap
    {
        initBoard();
        initBall();
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
        return ballBase.x - ball.width / 2;
    }

    private function bottom_bound():Float
    {
        return board.y + board.height - ball.height / 2;
    }

    private function top_bound():Float
    {
        return ballBase.y - ball.height / 2;
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
            if (left_bound() > board.x)
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
            if (top_bound() > board.y)
                ballBase.y += ballMoveY; // 上向きではみ出していない 上に動く
            else
                ballMoveY = -ballMoveY; // 上向きではみ出している 反転させる
        }
    }
}