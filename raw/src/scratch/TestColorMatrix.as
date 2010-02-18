package scratch
{
import org.yellcorp.color.ColorMatrix;
import org.yellcorp.color.ColorMatrixUtil;
import org.yellcorp.color.VectorRGB;
import org.yellcorp.env.ResizableStage;

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

    private var cm1:ColorMatrix;
    private var cm2:ColorMatrix;
    private var cmOut:ColorMatrix;

    private var t:Number = 0;
    private var delta:Number = 0.05;

    private var debugField:TextField;

    public function TestColorMatrix()
    {
        super();

        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, startAnimate);

        var url:URLRequest = new URLRequest("test.jpg");

        var testColour:VectorRGB = VectorRGB.fromUint24(0xCC9966);
        var testColour2:VectorRGB = VectorRGB.fromUint24(0xFF3399);

        cmFilter = new ColorMatrixFilter( );

        cm1 = ColorMatrixUtil.setMap(testColour2, testColour);
        //cm2 = ColorMatrixUtil.createLumaSRGB();
        cm2 = new ColorMatrix([  1,  0,  0, 0, 0,
                                 0,  1,  0, 0, 0,
                                 0,  0,  1, 0, 0,
                                 0,  0,  0, 1, 0 ]);

        cmOut = new ColorMatrix();

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
        //ColorMatrix.lerp(cm1, cm2, t, cmOut);
        ColorMatrixUtil.setHueSaturation(t * 2 * Math.PI, 1, cmOut);

        cmFilter.matrix = cmOut;

        debugField.text = cmOut.toString();// + "\n" + cmOut.rgbDet();

        loader.filters = [ cmFilter ];

        t += delta;
        if ((delta > 0 && t > 1) || (delta < 0 && t < 0))
        {
             delta *= -1;
        }
    }
}
}
