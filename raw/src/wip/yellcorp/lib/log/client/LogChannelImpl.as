package wip.yellcorp.lib.log.client
{
import wip.yellcorp.lib.log.LogChannel;


public class LogChannelImpl implements LogChannel
{
    private var client:LogClient;
    private var id:String;

    public function LogChannelImpl(logClient:LogClient, classId:String)
    {
        client = logClient;
        id = classId;
    }

    public function log(message:String, level:int = 0):void
    {
        client.channelLog(message, level, id);
    }
}
}
