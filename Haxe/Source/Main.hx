package;

import BaseSequence.SequenceKind;
import flash.events.KeyboardEvent;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.display.Sprite;

class Main extends Sprite {
    private var currentSequence:BaseSequence;
    private var keyState:Array<Bool>;
    private var frameCount:Int = 0;
    private static inline var MAXCOUNT = 2^32;

	public function new () {
        addEventListener(Event.ADDED_TO_STAGE, init);
		super ();
	}

    public function init(event:Event):Void {
        initEvent();
        initSequence();
        initDisplay();
    }

    // イベント登録
    private function initEvent():Void {
        keyState = new Array();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(Event.DEACTIVATE, onDeactive);
    }

    // シーケンス初期化
    private function initSequence():Void {
        currentSequence = new TitleSequence(this, stage);
        currentSequence.start();
    }

    // 画面初期化
    private function initDisplay():Void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        graphics.beginFill(0x0);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        graphics.endFill();
    }

    // 毎フレームに呼び出される処理とシーケンスの遷移
    private function onEnterFrame(event:Event):Void {
        frameCount++;
        if (frameCount >= MAXCOUNT) { frameCount = 0; }

        var nextSequence = currentSequence.update();
        switch nextSequence {
            case SequenceKind.Stay:
                // 同じシーケンスを続ける
            case SequenceKind.Title:
                currentSequence = new TitleSequence(this, stage);
                currentSequence.start();
            case SequenceKind.Game:
                currentSequence = new GameSequence(this, stage);
                currentSequence.start();
        }
    }

    public function count():Int {
        return frameCount;
    }

    public function isKeyPress(keyCode:UInt):Bool {
        return keyState[keyCode];
    }

    private function onKeyDown(event:KeyboardEvent) {
        keyState[event.keyCode] = true;
    }
    private function onKeyUp(event:KeyboardEvent) {
        keyState[event.keyCode] = false;
    }
    private function onDeactive(event:Event) {
        keyState = new Array();
    }
}
