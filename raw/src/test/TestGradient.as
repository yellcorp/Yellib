package test
{
import org.yellcorp.color.Gradient;
import org.yellcorp.color.VectorRGB;
import org.yellcorp.env.ResizableStage;

import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;


public class TestGradient extends ResizableStage
{
    private var t:Number = 0;
    private var dt:Number = 1;
    private var col:VectorRGB;

    private var debugField:TextField;
    private var grad:Gradient;
    private var rect:Rectangle;
    private var box:Matrix;

    public function TestGradient()
    {
        super();

        addChild(debugField = new TextField());
        debugField.width = 600;

        rect = new Rectangle(50, 50, 250, 250);
        box = new Matrix();


        grad = new Gradient([0, 0xFF00FF, 0x00FFFF, 0xFFFF00]);
        //grad.setRGBAtIndex(1, new VectorRGB(255, 0, 0));
        //grad.insert(64, new VectorRGB(255, 0, 0));

        box.createGradientBox(rect.width, rect.height, 0, rect.x, rect.y);

        /*
        grad.beginGradientFillOn(graphics, GradientType.LINEAR, box);
        graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
        */

        col = new VectorRGB();

        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onFrame(e:Event):void
    {
        var ucol:uint;

        grad.getRGB(t, col);

        ucol = col.getUint24();

        debugField.text = col.toString() + " " + ucol.toString(16);

        graphics.clear();
        graphics.beginFill(ucol, 1);
        graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
        graphics.endFill();

        t += dt;
        if (t > 255 && dt > 0)
        {
            dt = -dt;
            t = 255;
        }
        else if (t < 0 && dt < 0)
        {
            dt = -dt;
            t = 0;
        }
    }
}
}
