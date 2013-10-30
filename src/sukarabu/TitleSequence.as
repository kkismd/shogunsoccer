/**
 * Created with IntelliJ IDEA.
 * User: shimada
 * Date: 13/10/21
 * Time: 14:18
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Bitmap;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import mx.effects.Tween;
import mx.effects.easing.*;

public class TitleSequence implements BaseSequence{
    private var main:Main;
    private var stage:Stage;
    private var textField:TextField;
    [Embed(source='Untitled.png', mimeType='image/png')]
    private static const TestImage:Class;
    private var titleImage:Bitmap;
    private var counter:int = 0;
    private var countField:TextField;

    // パート分けの区分
    private const TITLE_PART:int = 0;
    private const LIGHT_PART:int = 1;
    private const DARK_PART:int = 2;
    private var part:int = TITLE_PART;

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
        var startY:int = 0 - titleImage.height;
        var stopY:int = (stage.stageHeight - titleImage.height) / 3;
        var startX:int = (stage.stageWidth - titleImage.width) / 2;
        titleImage.x = startX;
        titleImage.y = startY;
        main.addChild(titleImage);
        var titleTween:Tween = new Tween(titleImage, startY, stopY, 5000);
        titleTween.easingFunction = mx.effects.easing.Quadratic.easeInOut;
        titleTween.setTweenHandlers(
                function (val:int):void { titleImage.y = val; },
                function (val:int):void{ part = LIGHT_PART; }
        );
    }

    public function update():int {
        counter++;
        countField.text = counter.toString();

        switch (part) {
            case TITLE_PART:
                updateTitle();
                break;
            case LIGHT_PART:
                updateLight();
                break;
            case DARK_PART:
                updateDark();
                break;
        }

        // キー入力の処理
        if (part != TITLE_PART && main.isKeyPress(Keyboard.SPACE)) {
            dispose();
            return Main.GAME;
        }
        return Main.TITLE;
    }

    private function updateTitle():void {

    }

    private function updateLight():void {
        if (!checkInterval(3)) return;

        if (textField.alpha < 1) {
            textField.alpha += 0.1;
        } else {
            part = DARK_PART;
        }
    }

    private function updateDark():void {
        if (!checkInterval(3)) return;

        if (textField.alpha > 0) {
            textField.alpha -= 0.1;
        } else {
            part = LIGHT_PART;
        }
    }

    // 表示オブジェクトを削除する
    private function dispose():void {
        main.removeChild(titleImage);
        main.removeChild(textField);
        main.removeChild(countField);
    }

    private function checkInterval(interval:int):Boolean {
        return counter % interval == 0;
    }
}
}
