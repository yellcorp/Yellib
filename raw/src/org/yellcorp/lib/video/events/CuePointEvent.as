package org.yellcorp.lib.video.events
{
import flash.events.Event;


public class CuePointEvent extends Event
{
    public static const CUE_POINT:String = "cuePoint";

    public var name:String;
    public var cuePointType:String;
    public var time:Number;
    public var parameters:Object;

    public function CuePointEvent(type:String, dataObj:Object, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        name = dataObj.name;
        cuePointType = dataObj.type;
        time = dataObj.time;
        parameters = copyObj(dataObj.parameters);
    }

    public override function clone():Event
    {
        var cloneData:Object = {
            name: name,
            type: cuePointType,
            time: time,
            parameters: parameters
        };
        return new CuePointEvent(type, cloneData, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("CuePointEvent", "type", "name", "cuePointType", "time");
    }

    private function copyObj(source:Object):Object
    {
        var dest:Object = { };
        var k:*;
        if (source)
        {
            for (k in source)
            {
                dest[k] = source[k];
            }
        }
        return dest;
    }
}
}
