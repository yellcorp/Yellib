package scratch.simplelog
{
import wip.yellcorp.lib.simplelog.SimpleLog;

import flash.display.Sprite;


public class TestSimpleLog extends Sprite
{
    private var log:SimpleLog;

    public function TestSimpleLog()
    {
        addChild(log = new SimpleLog());

        log.log(this, "", "Here's a log from me to you\n");
        log.log(this, "warning", "Testing templates {0} {1}\n", "zero one".split(" "));
    }
}
}
