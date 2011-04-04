package org.yellcorp.lib.display.labelwatcher
{
import flash.events.Event;


public class LabelWatchEvent extends Event
{
    public static const LABEL_CHANGED:String = "labelChanged";
    public var label:String;

    public function LabelWatchEvent(type:String, label:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        this.label = label;
    }

    public override function clone():Event
    {
        return new LabelWatchEvent(type, label, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("LabelMonitorEvent", "type", "label");
    }
}
}
