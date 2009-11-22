package org.yellcorp.display
{
import flash.display.Sprite;
import flash.events.Event;


public class Resizer extends Sprite
{
    protected var nominalWidth:Number;
    protected var nominalHeight:Number;

    public function Resizer()
    {
        /*
         * Note thing with RENDER event: A call to stage.invalidate()
         * will trigger this event just before the next rendering
         * opportunity, but calling stage.invalidate() _again_ in response
         * to a RENDER event (say for nested sub-components) will not
         * re-trigger the event.
         *
         * People on the web say this is a hopeless bug - whether it's
         * a bug or not is prob. opinion, but it can be worked around if
         * you're careful with the order the RENDER listeners are added,
         * or use priorities.  The top-most containers should add their
         * RENDER listeners before their children do, or have a higher
         * priority
         */
        addEventListener(Event.RENDER, onRender);
        super();
        nominalWidth = super.width;
        nominalHeight = super.height;
    }

    public function destroy():void
    {
        removeEventListener(Event.RENDER, onRender);
    }

    public override function get width():Number
    {
        return nominalWidth;
    }

    public override function set width(w:Number):void
    {
        nominalWidth = w;
        if (stage) stage.invalidate();
    }

    public override function get height():Number
    {
        return nominalHeight;
    }

    public override function set height(h:Number):void
    {
        nominalHeight = h;
        if (stage) stage.invalidate();
    }

    protected function onResize():void
    {
        super.width = nominalWidth;
        super.height = nominalHeight;
    }

    private function onRender(e:Event):void
    {
        onResize();
    }
}
}
