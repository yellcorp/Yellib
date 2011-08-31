package org.yellcorp.lib.bitmap.pool
{
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


/**
 * Debugging subclass of <code>BitmapDataPool</code>.  Draws over returned
 * images with a pattern to detect when they aren't being cleared.
 */
public class DebugBitmapDataPool extends BitmapDataPool
{
    private static var _debugPattern:BitmapData;

    public function DebugBitmapDataPool()
    {
        super();
    }

    /**
     * @private
     */
    internal override function recycle(bmp:BitmapDataPoolMember):void
    {
        stamp(bmp);
        super.recycle(bmp);
    }

    private static function stamp(bmp:BitmapData):void
    {
        var s:Shape;
        var g:Graphics;

        s = new Shape();
        g = s.graphics;
        g.beginBitmapFill(getDebugPattern());
        g.drawRect(0, 0, bmp.width, bmp.height);
        g.endFill();

        bmp.draw(s);
    }

    private static function getDebugPattern():BitmapData
    {
        if (!_debugPattern)
        {
            _debugPattern = makeDebugPattern();
        }
        return _debugPattern;
    }

    private static function makeDebugPattern():BitmapData
    {
        var tf:TextField;
        var bmp:BitmapData;

        tf = makeDebugTextField();
        tf.text = "REUSED";

        bmp = new BitmapData(Math.ceil(tf.width), Math.ceil(tf.height), false, 0x00FF00);
        bmp.draw(tf);

        return bmp;
    }

    private static function makeDebugTextField():TextField
    {
        var tf:TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.defaultTextFormat = makeDebugTextFormat();
        tf.multiline = false;
        tf.wordWrap = false;
        return tf;
    }

    private static function makeDebugTextFormat():TextFormat
    {
        return new TextFormat("_sans", 24, 0xFF00FF, true);
    }
}
}
