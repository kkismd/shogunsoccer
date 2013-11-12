package;

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
    private var delta:Float;
    private var direction:Direction;

    public function new(main:Main, stage:Stage) {
        this.main = main;
        this.stage = stage;
    }

    public function start():Void {
        direction = Direction.Stop;

        tokin = new Bitmap(Assets.getBitmapData('assets/to.png'));
        tokin.x = (stage.stageWidth - tokin.width) / 2;
        tokin.y = (stage.stageHeight - tokin.height) / 2;
        main.addChild(tokin);

        delta = tokin.height;
    }

    public function update():SequenceKind {
        if (main.count() % 4 == 0) {
            inputDirection();
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
}