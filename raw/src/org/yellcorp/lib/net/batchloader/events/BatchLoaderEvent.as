package org.yellcorp.lib.net.batchloader.events
{
import flash.events.Event;


public class BatchLoaderEvent extends Event
{
    public static const QUEUE_START:String = "queueStart";
    public static const QUEUE_COMPLETE:String = "queueComplete";

    public function BatchLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new BatchLoaderEvent(type, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("BatchLoaderEvent", "type");
    }
}
}
