package org.yellcorp.net.multiloader.events
{
import org.yellcorp.net.multiloader.core.MultiLoaderItem;

import flash.events.Event;


public class MultiLoaderItemEvent extends Event
{
    public static const ITEM_COMPLETE:String = "itemComplete";
    private var _id:String;
    private var _item:MultiLoaderItem;

    public function MultiLoaderItemEvent(type:String, id:String, item:MultiLoaderItem, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        _item = item;
        _id = id;
        super(type, bubbles, cancelable);
    }

    public override function clone():Event
    {
        return new MultiLoaderItemEvent(type, id, item, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("MultiLoaderItemEvent", "type", "id");
    }

    public function get id():String
    {
        return _id;
    }

    public function get item():MultiLoaderItem
    {
        return _item;
    }
}
}
