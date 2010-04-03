package org.yellcorp.net.multiloader.events
{
import org.yellcorp.net.multiloader.core.MultiLoaderItem;

import flash.events.ErrorEvent;
import flash.events.Event;


public class MultiLoaderErrorEvent extends ErrorEvent
{
    public static const MULTILOADER_ERROR:String = "multiloaderError";
    private var _id:String;
    private var _item:MultiLoaderItem;
    private var _cause:ErrorEvent;

    public function MultiLoaderErrorEvent(
        type:String,
        id:String,
        item:MultiLoaderItem,
        cause:ErrorEvent,
        text:String = null,
        bubbles:Boolean = false,
        cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable, text === null ? cause.text : text);
        _id = id;
        _item = item;
        _cause = ErrorEvent(cause.clone());
    }

    public override function clone():Event
    {
        return new MultiLoaderErrorEvent(type, id, item, cause, text, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("MultiLoaderErrorEvent", "type", "id", "text", "cause");
    }

    public function get id():String
    {
        return _id;
    }

    public function get item():MultiLoaderItem
    {
        return _item;
    }

    public function get cause():ErrorEvent
    {
        return _cause;
    }
}
}
