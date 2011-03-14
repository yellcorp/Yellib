package scratch.duration
{
import org.yellcorp.lib.date.XSDDuration;

import flash.display.Sprite;


public class TestXSDDuration extends Sprite
{
    public function TestXSDDuration()
    {
        var msec:XSDDuration = XSDDuration.parse("PT.5S");
        trace(msec);
        trace(msec.wholeSeconds);
        trace(msec.milliseconds);
        trace(msec.getTotalMilliseconds(new Date()));
    }
}
}
