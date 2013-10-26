/**
 * Created with IntelliJ IDEA.
 * User: shimada
 * Date: 13/10/21
 * Time: 14:18
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.display.Bitmap;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.engine.Kerning;
import flash.ui.Keyboard;

public class TitleSequence implements BaseSequence{
    private var main:Main;
    private var stage:Stage;
    private var textField:TextField;
    [Embed(source='Untitled.png', mimeType='image/png')]
    private static const TestImage:Class;
    private var titleImage:Bitmap;
    private var counter:int = 0;
    private var countField:TextField;
    private const LIGHT:int = 1;
    private const DARK:int = 0;
    private var direction:int = LIGHT;

    public function TitleSequence(main:Main) {
        this.main = main;
        stage = main.getStage();
    }

    public function start():void {

        // 文字を表示するエリアを画面に割り当てる
        textField = new TextField();
        textField.defaultTextFormat = new TextFormat('', 20, 0xffffff, true);
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.text = 'Hit SPACE key';
        textField.x = stage.width / 2 - textField.width / 2;
        textField.y = stage.height - 50;
        textField.alpha = 0;
        main.addChild(textField);

        countField = new TextField();
        countField.text = '00000';
        countField.textColor = 0xffffff;
        countField.x = 10;
        countField.y = 10;
        main.addChild(countField);

        // タイトル画像のロード
        titleImage = new TestImage();
        titleImage.x = (stage.stageWidth - titleImage.width) / 2;
        titleImage.y = 0 - titleImage.height;
        main.addChild(titleImage);
    }

    public function update():int {
        counter++;
        countField.text = counter.toString();

        if (titlePositionOK()) {
            titleImage.y += 2;
        }
        if (!titlePositionOK() && checkInterval(3)) {
            if (direction == LIGHT) {
                if (textField.alpha < 1) {
                    textField.alpha += 0.1;
                } else {
                    direction = DARK;
                }
            } else {
                if (textField.alpha > 0) {
                    textField.alpha -= 0.1;
                } else {
                    direction = LIGHT;
                }
            }
        }
        // キー入力の処理
        if (main.isKeyHit()) {
            if (titlePositionOK()) {
                // タイトル移動中なら、入力をクリアする
                main.getKey();
                return Main.TITLE;
            }
            var keyEvent:KeyboardEvent = main.getKey();
            Main.log(keyEvent.keyCode.toString());
            if (keyEvent.keyCode == Keyboard.SPACE) {
                dispose();
                return Main.START;
            }
        }
        return Main.TITLE;
    }

    // 表示オブジェクトを削除する
    private function dispose():void {
        main.removeChild(titleImage);
        main.removeChild(textField);
        main.removeChild(countField);
    }

    // タイトルがまだ動いていい位置にいるか
    private function titlePositionOK():Boolean {
        return (stage.stageHeight / 2) > (titleImage.y + (titleImage.height / 2)) + 40;
    }

    private function checkInterval(interval:int):Boolean {
        return counter % interval == 0;
    }
}
}
