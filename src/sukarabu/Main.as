/**
 * Created with IntelliJ IDEA.
 * User: cake
 * Date: 13/10/16
 * Time: 10:05
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.text.TextField;

public class Main extends Sprite {
    private var textField:TextField;
    private var currentSequence:BaseSequence;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    // 初期化
    private function init(event:Event):void {
        // 黒く塗る
        graphics.beginFill(0x0);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        graphics.endFill();

        // 数字を表示するエリアを画面に割り当てる
        textField = new TextField();
        textField.text = 'Hello! 日本語でおk';
        textField.textColor = 0xffffff;
        addChild(textField);

        // 画像のロード
        var loader:Loader = new Loader();
        loader.load(new URLRequest("assets/images/Untitled.png"));
        loader.contentLoaderInfo.addEventListener(
                Event.COMPLETE,
                function (event:Event):void { addChild(event.target.content); },
                false, 0, true);


        // シーケンス初期化
        currentSequence = new TitleSequence();

        // 入力イベント初期化
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function loaded(event:Event):void {
        addChild(event.target.content);
    }

    // メインループ
    private function onEnterFrame(event:Event):void {
        var ret:int = currentSequence.update();
        currentSequence = dispatch(ret)
    }

    private function dispatch(i:int):BaseSequence {
        var result:BaseSequence = new TitleSequence();
        return result;
    }

    private function update():void {
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
