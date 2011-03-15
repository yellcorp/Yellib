package wip.yellcorp.lib.log.server
{
public class SimpleTrace implements LogServer
{
    public function channelLog(message:String, level:int, className:String):void
    {
        trace(className + ", " + level + ", " + message);
    }
}
}
