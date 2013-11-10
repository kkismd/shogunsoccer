package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Bitmap;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.events.Event;
import flash.display.Sprite;
import flash.text.TextField;
import openfl.Assets;

class Main extends Sprite {
	public function new () {
        addEventListener(Event.ADDED_TO_STAGE, init);
		super ();
	}

    public function init(event:Event):Void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        graphics.beginFill(0x0);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        graphics.endFill();

        // 文字の表示
        var textField = new TextField();
        textField.defaultTextFormat = new TextFormat('', 20, 0xffffff, true);
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.text = 'ヤッホー, haxe の世界!';
        textField.x = (stage.stageWidth - textField.width) / 2;
        textField.y = (stage.stageHeight - 30);
        addChild(textField);

        // 画像の表示
        var bitmap = new Bitmap(Assets.getBitmapData('assets/title.png'));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = (stage.stageHeight - bitmap.height) / 2;
        addChild(bitmap);
    }
}
