package wip.yellcorp.lib.log.client
{
import wip.yellcorp.lib.log.LogChannel;
import wip.yellcorp.lib.log.server.LogServer;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;


public class LogClient
{
    private var server:LogServer;
    private var channelForInstance:Dictionary;

    public function LogClient(logServer:LogServer)
    {
        channelForInstance = new Dictionary(true);

        server = logServer;
    }

    public function getChannel(callingInstance:Object):LogChannel
    {
        var channel:LogChannelImpl;
        var classId:String;

        channel = channelForInstance[callingInstance];

        if (!channel)
        {
            classId = getQualifiedClassName(callingInstance);

            channel = channelForInstance[callingInstance] =
                new LogChannelImpl(this, classId);
        }

        return channel;
    }

    internal function channelLog(message:String, level:int, classId:String):void
    {
        server.channelLog(message, level, classId);
    }
}
}
