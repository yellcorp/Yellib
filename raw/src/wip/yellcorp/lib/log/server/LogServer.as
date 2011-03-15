package wip.yellcorp.lib.log.server
{
public interface LogServer
{
    function channelLog(message:String, level:int, className:String):void;
}
}
