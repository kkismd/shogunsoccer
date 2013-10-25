/**
 * Created with IntelliJ IDEA.
 * User: cake
 * Date: 13/10/16
 * Time: 10:05
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.external.ExternalInterface;
import flash.text.TextField;

public class Main extends Sprite {
    private var textField:TextField;
    private var currentSequence:BaseSequence;
    [Embed(source='Untitled.png', mimeType='image/png')]
    private static const TestImage:Class;
    private var titleImage:Bitmap;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    // 初期化
    private function init(event:Event):void {
        // 画面設定
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        // 黒く塗る
        graphics.beginFill(0x0);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        graphics.endFill();

        // 文字を表示するエリアを画面に割り当てる
        textField = new TextField();
        textField.text = 'Hit any key.';
        textField.textColor = 0xffffff;
        textField.x = stage.width / 2 - textField.width / 2;
        textField.y = stage.height - 50;
        addChild(textField);

        // 画像のロード
        titleImage = new TestImage();
        titleImage.x = (stage.stageWidth - titleImage.width) / 2;
        titleImage.y = 30;
        addChild(titleImage);

        // シーケンス初期化
        currentSequence = new TitleSequence();

        // 入力イベント初期化
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    // メインループ
    private function onEnterFrame(event:Event):void {
        var ret:int = currentSequence.update();
        currentSequence = dispatch(ret)
    }

    private function dispatch(i:int):BaseSequence {
        // とりあえずなにもしない
        return currentSequence;
    }

    // キー入力(1)
    private function onKeyUp(event:KeyboardEvent):void {

    }

    // キー入力(2)
    private function onKeyDown(event:KeyboardEvent):void {

    }

    private function log(message:String):void {
        ExternalInterface.call('console.log', message);
    }
}
}
