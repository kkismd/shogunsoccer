package;

import flash.ui.Keyboard;
import BaseSequence.SequenceKind;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.display.Bitmap;
import flash.display.Stage;
import openfl.Assets;

class TitleSequence implements BaseSequence {
    private var main:Main;
    private var stage:Stage;
    private var textField:TextField;
    private var bitmap:Bitmap;

    public function new(main:Main, stage:Stage) {
        this.main = main;
        this.stage = stage;
    }

    public function start():Void {
        // 文字の表示
        textField = new TextField();
        textField.defaultTextFormat = new TextFormat('', 20, 0xffffff, true);
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.text = 'Hit SPACE key';
        textField.x = (stage.stageWidth - textField.width) / 2;
        textField.y = (stage.stageHeight - 50);
        main.addChild(textField);

        // 画像の表示
        bitmap = new Bitmap(Assets.getBitmapData('assets/title.png'));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = (stage.stageHeight - bitmap.height) / 2;
        main.addChild(bitmap);
    }

    public function update(): SequenceKind {
        if (main.isKeyPress(Keyboard.SPACE)) {
            clearObjects();
            return SequenceKind.Game;
        } else {
            return SequenceKind.Stay;
        }
    }

    private function clearObjects():Void {
        main.removeChild(textField);
        main.removeChild(bitmap);
    }
}