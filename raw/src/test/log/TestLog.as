package test.log
{
import org.yellcorp.env.ResizableStage;

import wip.yellcorp.log.LogChannel;
import wip.yellcorp.log.client.LogClient;
import wip.yellcorp.log.server.SimpleTrace;


public class TestLog extends ResizableStage
{
    public function TestLog()
    {
        super();

        var client:LogClient = new LogClient(new SimpleTrace());
        var logger:LogChannel = client.getChannel(this);

        logger.log("Here's my test", 1);
    }
}
}
