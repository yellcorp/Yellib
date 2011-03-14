package org.yellcorp.lib.video.cue
{
import org.yellcorp.lib.core.MapUtil;


public class CuePoint
{
    public var parameters:Object;
    public var name:String;
    public var type:String;
    public var time:Number;

    public function CuePoint(cuePointObject:Object = null)
    {
        if (cuePointObject)
        {
            setFromMetaData(cuePointObject);
        }
        else
        {
            clear();
        }
    }

    public function clear():void
    {
        name = "";
        type = CuePointType.EVENT;
        time = 0;
        parameters = { };
    }

    public function clone():CuePoint
    {
        var c:CuePoint = new CuePoint();
        c.name = name;
        c.type = type;
        c.time = time;
        MapUtil.merge(parameters, c.parameters);
        return c;
    }

    public function setFromMetaData(cuePointObject:Object):void
    {
        name = cuePointObject['name'];
        type = cuePointObject['type'];
        time = cuePointObject['time'];
        parameters = { };
        if (cuePointObject.hasOwnProperty('parameters'))
            MapUtil.merge(cuePointObject['parameters'], parameters);
    }

    public function toString():String
    {
        return "[CuePoint name=" + name + " type=" + type + " time=" + time + "]";
    }

    public function toObject():Object
    {
        var oParams:Object;
        var obj:Object = {
            name: name,
            type: type,
            time: time
        };

        if (!MapUtil.isEmpty(parameters))
        {
            oParams = obj['parameters'] = { };
            MapUtil.merge(parameters, oParams);
        }

        return obj;
    }
}
}
