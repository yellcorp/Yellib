package scratch
{
import org.yellcorp.color.HSV;
import org.yellcorp.color.VectorRGB;
import org.yellcorp.env.ResizableStage;

import flash.events.Event;
import flash.text.TextField;


public class TestHSV extends ResizableStage
{
    private var rgb:VectorRGB;
    private var hsv:HSV;
    private var t:TextField;
    private var so:Number;
    private var vo:Number;

    public function TestHSV()
    {
        rgb = new VectorRGB();
        hsv = new HSV(0, 1, 1);

        so = 0;
        vo = 0;

        t = new TextField();
        t.width = 400;
        addChild(t);

        addEventListener(Event.ENTER_FRAME, frame);

        traceStuff();
    }

    private function traceStuff():void
    {
        var baseCol:VectorRGB = VectorRGB.fromUint24(0x11BDD3);
        var baseHue:HSV = new HSV();

        var targetCol:VectorRGB = VectorRGB.fromUint24(0xFFFF00);
        var targetHue:HSV = new HSV();

        baseHue.convertFromRGB(baseCol);
        targetHue.convertFromRGB(targetCol);

        trace(baseHue.h - targetHue.h);
    }

    private function frame(e:Event):void
    {
        hsv.h++;

        so += 0.05;
        vo += 0.03;

        hsv.s = Math.sin(so) / 2 + .5;
        hsv.v = Math.cos(vo) / 2 + .5;

        hsv.convertToRGB(rgb);

        graphics.clear();
        graphics.beginFill(rgb.getUint24());
        graphics.drawRoundRect(20, 20, 100, 100, 12, 12);
        graphics.endFill();

        t.text = hsv.toString();
    }
}
}
