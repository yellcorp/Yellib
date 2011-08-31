package org.yellcorp.lib.net.batchloader.events
{
import flash.events.Event;


public class BatchItemEvent extends Event
{
    public static const ITEM_LOAD_START:String = "itemLoadStart";
    public static const ITEM_COMPLETE:String = "itemComplete";

    private var _id:String;

    public function BatchItemEvent(type:String, id:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _id = id;
    }

    public override function clone():Event
    {
        return new BatchItemEvent(type, _id, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("BatchItemEvent", "type", "id");
    }

    public function get id():String
    {
        return _id;
    }
}
}
