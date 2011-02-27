package profile
{
import org.yellcorp.format.template.Template;

import flash.display.Sprite;
import flash.events.Event;


public class Profiler extends Sprite
{
    private static const ITER_PER_FRAME:int = 500;
    private var j:int = 0;

    public function Profiler()
    {
        super();
        addEventListener(Event.ENTER_FRAME, run);
    }

    private function run(event:Event):void
    {
        var i:int = ITER_PER_FRAME;
        while (--i)
        {
            Template.format("{0} Testing \\{escaped} {1} {2} {3}", [ 0, 1, 2, 3 ]);
        }
        ++j;
    }
}
}
