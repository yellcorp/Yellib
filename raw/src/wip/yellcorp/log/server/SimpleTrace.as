package wip.yellcorp.log.server
{

public class SimpleTrace implements LogServer
{
    public function channelLog(message:String, level:int, className:String):void
    {
        trace(className + ", " + level + ", " + message);
    }
}
}
