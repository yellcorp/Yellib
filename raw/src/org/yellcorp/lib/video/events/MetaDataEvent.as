package org.yellcorp.lib.video.events
{
import flash.events.Event;


public class MetaDataEvent extends Event
{
    public static const META_DATA:String = "metaData";
    public var metaData:Object;

    public function MetaDataEvent(type:String, metaData:Object, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        this.metaData = metaData;
    }

    public override function clone():Event
    {
        return new MetaDataEvent(type, metaData, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("MetaDataEvent", "type");
    }
}
}
