package;

import motion.Actuate;
import flash.geom.Point;
import flash.display.Sprite;
import openfl.Assets;
import flash.display.Bitmap;
import BaseSequence.SequenceKind;
import flash.display.Stage;
import flash.ui.Keyboard;

// 移動キー入力の方向
enum Direction {
    Stop;
    Up;
    Down;
    Left;
    Right;
}

// マップに置かれているオブジェクトの種類
enum GameMap {
    None;
    Player(id : String);
}

class GameSequence implements BaseSequence {
    private var main:Main;
    private var stage:Stage;
    private var tokin:Bitmap;
    private var board:Bitmap;
    private var ballBase:Sprite;
    private var ball:Bitmap;
    private var direction:Direction;
    private var ballMoveX = 3.0;
    private var ballMoveY = 4.0;
    private var myPos:Point;
    private var map:Array<GameMap>;

    public function new(main:Main, stage:Stage) {
        this.main = main;
        this.stage = stage;
    }

    // 初期化
    public function start():Void {
        initMyUnit();
        initBoard();
        initBall();
        initUnit();
    }

    private function initMyUnit():Void {
        direction = Direction.Stop;
        myPos = new Point(0, 0);
    }

    private function initBoard():Void {
        map = new Array<GameMap>();
        for (i in 0...81) {
            map.push(GameMap.None);
        }
        map[0] = GameMap.Player('me');

        board = loadBitmap('assets/japanese-chess-bds.jpg');
        board.x = 50;
        board.y = 50;
        board.scaleX = 1.5;
        board.scaleY = 1.5;
        main.addChild(board);
    }

    private function initBall():Void {
        ballBase = new Sprite();
        ballBase.x = 60;
        ballBase.y = 50;
        main.addChild(ballBase);

        ball = loadBitmap('assets/ball.png');
        ball.x = 0 - ball.width / 2;
        ball.y = 0 - ball.height / 2;
        ballBase.addChild(ball);
    }

    private function initUnit():Void {
        tokin = loadBitmap('assets/sgs18.png');
        tokin.x = (stage.stageWidth - tokin.width) / 2;
        tokin.y = (stage.stageHeight - tokin.height) / 2;
        tokin.scaleX = 1.5;
        tokin.scaleY = 1.5;
        main.addChild(tokin);
    }

    // メインループ
    public function update():SequenceKind {
        ballBase.rotation += 2;
        moveBall();
        inputDirection();
        if (main.count() % 4 == 0) {
            moveTokin();
        }

        // キーボードの Q で終了
        if (main.isKeyPress(Keyboard.Q)) {
            clearObjects();
            return SequenceKind.Title;
        }

        return SequenceKind.Stay;
    }

    private function moveTokin():Void {
        var oldPos:Point = myPos;

        if (direction == Direction.Up &&myPos.y > 0) {
            myPos.y -= 1;
        } else if (direction == Direction.Down && myPos.y < 8) {
            myPos.y += 1;
        } else if (direction == Direction.Left && myPos.x > 0) {
            myPos.x -= 1;
        } else if (direction == Direction.Right && myPos.x < 8) {
            myPos.x += 1;
        }
        // 移動していたらマップを書き換える
        if (myPos != oldPos) {
            map[pointToMapAddress(oldPos)] = GameMap.None;
            map[pointToMapAddress(myPos)] = GameMap.Player("me");
        }
        animateTokin(myPos);
    }

    private function animateTokin(pos:Point):Void {
        var newPos = getUnitPos(myPos);
        Actuate.tween(tokin, 1, {x: newPos.x, y: newPos.y});
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

    private function getUnitPos(pos:Point):Point {
        var posX = (pos.x * 30 + 15) * 1.5 + board.x;
        var posY = (pos.y * 32 + 15) * 1.5 + board.y;
        return new Point(posX, posY);
    }

    private function pointToMapAddress(point:Point):Int {
        return Std.int(point.x + point.y * 9);
    }
}