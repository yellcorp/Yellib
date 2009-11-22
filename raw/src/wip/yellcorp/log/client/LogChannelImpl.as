package wip.yellcorp.log.client
{
import wip.yellcorp.log.LogChannel;


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
