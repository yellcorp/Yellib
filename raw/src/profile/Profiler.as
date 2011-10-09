package profile
{
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.format.geo.GeoFormat;

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;


public class Profiler extends Sprite
{
    private static const ITER_PER_FRAME:int = 30;
    private static const STRING_REPEAT:int = 30;
    private var j:int = 0;
    private var deg1_1_1_75:Number;
    private var torture:String;

    public function Profiler()
    {
        super();
        deg1_1_1_75 = 1 + 1 / 60 + 1.75 / 3600;
        torture = StringUtil.repeat("%d%* %m%' %.5s%'' %a ", STRING_REPEAT);
        trace(torture);
        addEventListener(Event.ENTER_FRAME, run);
    }

    private function run(event:Event):void
    {
        var i:int = ITER_PER_FRAME;
        var start:int = getTimer();
        while (--i)
        {
            GeoFormat.clearCache();
            GeoFormat.format(torture, deg1_1_1_75);
        }
        var time:int = getTimer() - start;
        trace(time / (ITER_PER_FRAME * STRING_REPEAT));
        ++j;
    }
}
}
