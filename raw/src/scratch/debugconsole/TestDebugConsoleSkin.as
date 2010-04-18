package scratch.debugconsole
{
import org.yellcorp.debug.console.DebugConsoleSkin;
import org.yellcorp.env.console.SimpleScrollBarSkin;
import org.yellcorp.ui.scrollbar.VerticalScrollBar;

import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;


public class TestDebugConsoleSkin implements DebugConsoleSkin
{

    public function createBackground():InteractiveObject
    {
        return createSpriteBox(0xEEEEEE, 100, 100);
    }

    public function createSizeHandle():InteractiveObject
    {
        return createSpriteBox(0xFF00FF, 20, 20);
    }

    public function createOutputField():TextField
    {
        return createTextField();
    }

    public function createOutputScrollBar():VerticalScrollBar
    {
        return new VerticalScrollBar(new SimpleScrollBarSkin());
    }

    public function createInputField():TextField
    {
        var tf:TextField = createTextField();
        tf.height = 20;
        return tf;
    }

    public function get windowGutter():Number
    {
        return 8;
    }

    public function get controlGutter():Number
    {
        return 4;
    }

    private static function createSpriteBox(fill:uint, width:Number, height:Number):InteractiveObject
    {
        var s:Sprite = new Sprite();
        var g:Graphics = s.graphics;
        g.beginFill(fill);
        g.drawRect(0, 0, width, height);
        g.endFill();
        return s;
    }

    private function createTextField():TextField
    {
        var tf:TextField = new TextField();
        tf.defaultTextFormat = new TextFormat("_sans", 11, 0);
        tf.border = true;
        tf.borderColor = 0x888888;
        return tf;
    }
}
}
