package scratch
{
import org.yellcorp.lib.color.vector.VectorColorUtil;
import org.yellcorp.lib.env.ResizableStage;
import org.yellcorp.lib.geom.Vector3;

import flash.events.Event;
import flash.text.TextField;


public class TestHSV extends ResizableStage
{
    private var rgb:Vector3;
    private var hsv:Vector3;
    private var t:TextField;
    private var so:Number;
    private var vo:Number;

    public function TestHSV()
    {
        rgb = new Vector3();
        hsv = new Vector3(0, 1, 1);

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
        var baseCol:Vector3 = VectorColorUtil.uintToVector(0x11BDD3);
        var baseHue:Vector3 = new Vector3();

        var targetCol:Vector3 = VectorColorUtil.uintToVector(0xFFFF00);
        var targetHue:Vector3 = new Vector3();

        VectorColorUtil.convertRGBtoHSV(baseCol, baseHue);
        VectorColorUtil.convertRGBtoHSV(targetCol, targetHue);

        trace(baseHue.x - targetHue.x);
    }

    private function frame(e:Event):void
    {
        hsv.y = Math.sin(so) / 2 + .5;
        hsv.z = Math.cos(vo) / 2 + .5;

        VectorColorUtil.convertHSVtoRGB(hsv, rgb);

        graphics.clear();
        graphics.beginFill(VectorColorUtil.vectorToUint(rgb));
        graphics.drawRoundRect(20, 20, 100, 100, 12, 12);
        graphics.endFill();

        t.text = hsv.toString();

        hsv.x += 1 / 60;
        so += 0.05;
        vo += 0.03;
    }
}
}
