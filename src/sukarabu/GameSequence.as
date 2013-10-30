/**
 * Created with IntelliJ IDEA.
 * User: shimada
 * Date: 13/10/30
 * Time: 15:01
 * To change this template use File | Settings | File Templates.
 */
package sukarabu {
import flash.display.Bitmap;
import flash.display.Stage;
import flash.text.engine.Kerning;
import flash.ui.Keyboard;

public class GameSequence implements BaseSequence {
    [Embed(source='../../assets/images/to.png', mimeType='image/png')]
    private static const TokinImage:Class;
    private var tokin:Bitmap;
    private var main:Main;
    private var stage:Stage;

    public function GameSequence(main:Main) {
        this.main = main;
        this.stage = main.getStage();
    }

    // 初期化
    public function start():void {
        tokin = new TokinImage();
        tokin.x = (stage.stageWidth - tokin.width) / 2;
        tokin.y = (stage.stageHeight - tokin.height ) / 2;
        main.addChild(tokin);
    }

    public function update():int {
        if (main.isKeyPress(Keyboard.UP)) {
            tokin.y--;
        } else if (main.isKeyPress(Keyboard.DOWN)) {
            tokin.y++;
        } else if (main.isKeyPress(Keyboard.LEFT)) {
            tokin.x--;
        } else if (main.isKeyPress(Keyboard.RIGHT)) {
            tokin.x++;
        }
        return 0;
    }
}
}
