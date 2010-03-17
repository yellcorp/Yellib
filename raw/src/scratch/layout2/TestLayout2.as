package scratch.layout2
{
import wip.yellcorp.layout2.ConstraintType;
import wip.yellcorp.layout2.Layout;
import wip.yellcorp.layout2.LayoutAxis;
import wip.yellcorp.layout2.LayoutProperty;

import flash.display.Sprite;
import flash.events.Event;


public class TestLayout2 extends Sprite
{
    public function TestLayout2()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    private function onStage(event:Event):void
    {
        var l:Layout = new Layout();
        l.addConstraint(LayoutAxis.X, this, LayoutProperty.MAX, stage, LayoutProperty.SIZE, ConstraintType.FACTOR);
        l.optimize();
    }
}
}
