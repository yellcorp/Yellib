package scratch.log
{
import org.yellcorp.lib.env.ResizableStage;

import wip.yellcorp.lib.log.LogChannel;
import wip.yellcorp.lib.log.client.LogClient;
import wip.yellcorp.lib.log.server.SimpleTrace;


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
