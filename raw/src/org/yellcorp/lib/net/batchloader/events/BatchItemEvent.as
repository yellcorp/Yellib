package org.yellcorp.lib.net.batchloader.events
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;

import flash.events.Event;


public class BatchItemEvent extends Event
{
    public static const ITEM_LOAD_START:String = "itemLoadStart";
    public static const ITEM_COMPLETE:String = "itemComplete";

    private var _id:String;
    private var _item:BatchLoaderItem;

    public function BatchItemEvent(type:String,
        id:String = null, item:BatchLoaderItem = null,
        bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _id = id;
        _item = item;
    }

    public override function clone():Event
    {
        return new BatchItemEvent(type, _id, _item, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("BatchItemEvent", "type", "id");
    }

    public function get id():String
    {
        return _id;
    }

    public function get item():BatchLoaderItem
    {
        return _item;
    }
}
}
