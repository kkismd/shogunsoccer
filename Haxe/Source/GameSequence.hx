package;

import flash.display.Sprite;
import openfl.Assets;
import flash.display.Bitmap;
import BaseSequence.SequenceKind;
import flash.display.Stage;
import flash.ui.Keyboard;

enum Direction {
    Stop;
    Up;
    Down;
    Left;
    Right;
}

class GameSequence implements BaseSequence {
    private var main:Main;
    private var stage:Stage;
    private var tokin:Bitmap;
    private var board:Bitmap;
    private var ballBase:Sprite;
    private var ball:Bitmap;
    private var delta:Float;
    private var direction:Direction;
    private var ballMoveX = 3.0;
    private var ballMoveY = 4.0;

    public function new(main:Main, stage:Stage) {
        this.main = main;
        this.stage = stage;
    }

    // 初期化
    public function start():Void {
        direction = Direction.Stop;

        board = loadBitmap('assets/japanese-chess-bds.jpg');
        board.x = 50;
        board.y = 50;
        board.scaleX = 1.5;
        board.scaleY = 1.5;
        main.addChild(board);

        ballBase = new Sprite();
        ballBase.x = 60;
        ballBase.y = 50;
        main.addChild(ballBase);

        ball = loadBitmap('assets/ball.png');
        ball.x = 0 - ball.width / 2;
        ball.y = 0 - ball.height / 2;
        ballBase.addChild(ball);

        tokin = loadBitmap('assets/sgs18.png');
        tokin.x = (stage.stageWidth - tokin.width) / 2;
        tokin.y = (stage.stageHeight - tokin.height) / 2;
        main.addChild(tokin);

        delta = tokin.height / 4;
    }

    // メインループ
    public function update():SequenceKind {
        if (main.count() % 4 == 0) {
            inputDirection();
        }
        ballBase.rotation += 2;
        moveBall();

        // キーボードの Q で終了
        if (main.isKeyPress(Keyboard.Q)) {
            clearObjects();
            return SequenceKind.Title;
        }

        if (direction == Direction.Up &&tokin.y > 0) {
            tokin.y -= delta;
        } else if (direction == Direction.Down && tokin.y + tokin.height < stage.stageHeight) {
            tokin.y += delta;
        } else if (direction == Direction.Left && tokin.x > 0) {
            tokin.x -= delta;
        } else if (direction == Direction.Right && tokin.x + tokin.width < stage.stageWidth) {
            tokin.x += delta;
        }
        return SequenceKind.Stay;
    }

    private function moveBall():Void {
        // ボールが右向きではみ出していないなら
        if (ballMoveX > 0 && ballBase.x < board.x + board.width - ball.width / 2) {
            // 右に動く
            ballBase.x += ballMoveX;
        }
        // ボールが右向きではみだしているなら
        else if (ballMoveX > 0 && ballBase.x >= board.x + board.width - ball.width/ 2) {
            // 反転させる
            ballMoveX = -ballMoveX;
        }
        // ボールが左向きではみ出していない
        else if (ballMoveX < 0 && ballBase.x - ball.width / 2 > board.x) {
            // 左に動く
            ballBase.x += ballMoveX;
        }
        // ボールが左向きではみ出している
        else if (ballMoveX < 0 && ballBase.x - ball.width / 2 <= board.x) {
            // 反転させる
            ballMoveX = -ballMoveX;
        }

        // ボールが下向きではみだしていない
        if (ballMoveY > 0 && ballBase.y < board.y + board.height - ball.height / 2) {
            // 下に動く
            ballBase.y += ballMoveY;
        }
        // 下向きではみ出している
        else if (ballMoveY > 0 && ballBase.y >= board.y + board.height - ball.height / 2) {
            ballMoveY = -ballMoveY;
        }
        // 上向きではみ出していない
        else if (ballMoveY < 0 && ballBase.y - ball.height / 2 > board.y) {
            ballBase.y += ballMoveY;
        }
        // 上向きではみ出している
        else if (ballMoveY < 0 && ballBase.y - ball.height / 2 <= board.y) {
            // 反転させる
            ballMoveY = -ballMoveY;
        }
    }

    function inputDirection() {
        if (main.isKeyPress(Keyboard.UP)) {
            direction = Direction.Up;
        } else if (main.isKeyPress(Keyboard.DOWN)) {
            direction = Direction.Down;
        } else if (main.isKeyPress(Keyboard.LEFT)) {
            direction = Direction.Left;
        } else if (main.isKeyPress(Keyboard.RIGHT)) {
            direction = Direction.Right;
        } else {
            direction = Direction.Stop;
        }
    }

    private function clearObjects():Void {
        main.removeChild(tokin);
        main.removeChild(board);
        main.removeChild(ballBase);
    }

    private function loadBitmap(path:String):Bitmap {
        return new Bitmap(Assets.getBitmapData(path));
    }
}