/**
 * Created with IntelliJ IDEA.
 * User: cake
 * Date: 13/10/16
 * Time: 10:05
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.external.ExternalInterface;

[SWF(width='640', height='480')]
public class Main extends Sprite {
    private var currentSequence:BaseSequence;
    private var keyState:Array/* of Boolean */ = new Array();
    public static const TITLE:int = 0;
    public static const GAME:int = 1;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    // 初期化
    private function init(event:Event):void {
        // 画面設定
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        clearScreen();

        // 入力イベント初期化
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        stage.addEventListener(Event.DEACTIVATE, onDeactivate);

        // シーケンス初期化
        currentSequence = new TitleSequence(this);
        currentSequence.start();
    }

    // 黒く塗る
    private function clearScreen():void {
        graphics.beginFill(0x0);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        graphics.endFill();
    }

    // getter
    public function getStage():Stage {
        return stage;
    }

    // メインループ
    private function onEnterFrame(event:Event):void {
        var ret:int = currentSequence.update();
        dispatch(ret)
    }

    private function dispatch(ret:int):void {
        if (ret == GAME) {
            clearScreen();
            currentSequence = new GameSequence(this);
            currentSequence.start();
        }
    }

    // キー入力(1)
    private function onKeyUp(event:KeyboardEvent):void {
        keyState[event.keyCode] = true;
    }

    // キー入力(2)
    private function onKeyDown(event:KeyboardEvent):void {
        keyState[event.keyCode] = false;
    }

    private function onDeactivate(event:Event):void {
        keyState = new Array();
    }

    public function isKeyPress(keyCode:uint):Boolean {
        return keyState[keyCode];
    }

    public static function log(message:String):void {
        ExternalInterface.call('console.log', message);
    }
}
}
