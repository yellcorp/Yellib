package scratch.colormatrix
{
import org.yellcorp.lib.color.matrix.ColorMatrixFactory;
import org.yellcorp.lib.color.matrix.ColorMatrixUtil;
import org.yellcorp.lib.env.ResizableStage;

import flash.display.Loader;
import flash.events.Event;
import flash.filters.ColorMatrixFilter;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;


public class TestColorMatrix extends ResizableStage
{
    private var loader:Loader;
    private var cmFilter:ColorMatrixFilter;

    private var cm1:Array;
    private var cm2:Array;
    private var cmOut:Array;

    private var t:Number = 0;
    private var delta:Number = 0.05;

    private var debugField:TextField;

    public function TestColorMatrix()
    {
        super();

        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, startAnimate);

        var url:URLRequest = new URLRequest("test.jpg");

        cmFilter = new ColorMatrixFilter( );

        cm1 = ColorMatrixFactory.makeDuotone(0xFF0000, 0x00ffff);
        cm2 = ColorMatrixUtil.makeIdentity();
        cmOut = ColorMatrixUtil.makeIdentity();

        addChild(loader);
        loader.load(url);

        addChild(debugField = getDebugField());
    }

    private function getDebugField():TextField
    {
        var tf:TextField = new TextField();

        tf.width = 256;
        tf.height = 64;
        tf.multiline = true;
        tf.background = true;
        tf.backgroundColor = 0xFFFFFF;
        tf.wordWrap = true;

        tf.defaultTextFormat = new TextFormat("_sans", 8, 0);

        return tf;
    }

    private function startAnimate(e:Event):void
    {
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onFrame(e:Event):void
    {
        ColorMatrixUtil.lerp(cm1, cm2, t, cmOut);
        // ColorMatrixFactory.makeHueSaturation(t * 2 * Math.PI, 1, cmOut);

        cmFilter.matrix = cmOut;

        debugField.text = ColorMatrixUtil.toString(cmOut); // + "\n" + cmOut.rgbDet();

        loader.filters = [ cmFilter ];

        t += delta;
        if ((delta > 0 && t > 1) || (delta < 0 && t < 0))
        {
            delta *= -1;
        }
    }
}
}
