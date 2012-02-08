package org.yellcorp.lib.net.batchloader.events
{
import org.yellcorp.lib.error.chain.IndirectErrorEvent;
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;

import flash.events.Event;


public class BatchItemErrorEvent extends IndirectErrorEvent
{
    public static const ITEM_ERROR:String = "itemError";

    private var _id:String;
    private var _item:BatchLoaderItem;

    public function BatchItemErrorEvent(type:String, cause:*,
        id:String = null, item:BatchLoaderItem = null,
        bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
    {
        super(type, cause, bubbles, cancelable, text);
        _id = id;
        _item = item;
    }

    public override function clone():Event
    {
        return new BatchItemErrorEvent(type, _cause, _id, _item, bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return formatToString("BatchItemErrorEvent", "type", "cause", "id");
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
