package org.yellcorp.lib.net.batchloader.events
{
import org.yellcorp.lib.net.batchloader.adapters.BatchLoaderItem;

import flash.events.ErrorEvent;
import flash.events.Event;


public class BatchItemErrorEvent extends ErrorEvent
{
    public static const ITEM_ERROR:String = "itemError";

    private var _error:*;
    private var _id:String;
    private var _item:BatchLoaderItem;

    public function BatchItemErrorEvent(type:String, error:*,
        id:String = null, item:BatchLoaderItem = null,
        bubbles:Boolean = false, cancelable:Boolean = false, text:String = "")
    {
        super(type, bubbles, cancelable, text);
        _error = error;
        _id = id;
        _item = item;
    }

    public override function clone():Event
    {
        return new BatchItemErrorEvent(type, _error, _id, _item, bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return formatToString("BatchItemErrorEvent", "type", "error", "id");
    }

    public function get error():*
    {
        return _error;
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
