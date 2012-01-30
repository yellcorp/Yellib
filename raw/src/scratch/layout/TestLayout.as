package scratch.layout
{
import org.yellcorp.lib.layout.ConstraintType;
import org.yellcorp.lib.layout.Layout;

import flash.display.StageAlign;
import flash.display.StageScaleMode;


import org.yellcorp.lib.layout.properties.*;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;


[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="480")]
public class TestLayout extends Sprite
{
    private var a:Sprite;
    private var b:Sprite;
    private var layout:Layout;

    public function TestLayout()
    {
        super();
        addChild(a = makeBox( 50, 50, 100, 100, 0x993333));
        addChild(b = makeBox(170, 50, 100, 100, 0x333399));
        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    private function makeBox(x:Number, y:Number, w:Number, h:Number, fill:uint):Sprite
    {
        var s:Sprite = new Sprite();
        var g:Graphics = s.graphics;

        g.beginFill(fill);
        g.drawRect(0, 0, w, h);
        g.endFill();

        s.x = x;
        s.y = y;

        return s;
    }

    private function onStage(event:Event):void
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        layout = new Layout(true);
        layout.constrain(a, RIGHT, b, LEFT, ConstraintType.OFFSET);
        layout.constrain(a, HEIGHT, b, TOP, ConstraintType.OFFSET);
        layout.constrain(a, LEFT, stage, WIDTH, ConstraintType.PROPORTIONAL);
        layout.measure();
        layout.optimize();
        trace(layout.dumpPrograms());
        addEventListener(Event.ENTER_FRAME, onFrame);
    }

    private function onFrame(event:Event):void
    {
        b.x = mouseX;
        b.y = mouseY;
        layout.update();
    }
}
}
