package org.yellcorp.video.cue
{
import org.yellcorp.array.ArrayUtil;


public class CuePointCollection
{
    private var cuePoints:Array;

    public function CuePointCollection(arrayOfObjects:Array = null)
    {
        if (arrayOfObjects)
        {
            setFromMetaData(arrayOfObjects);
        }
        else
        {
            clear();
        }
    }

    public function clear():void
    {
        cuePoints = [ ];
    }

    public function clone():CuePointCollection
    {
        return new CuePointCollection(cuePoints);
    }

    public function get length():int
    {
        return cuePoints.length;
    }

    public function pushCuePoint(newCuePoint:CuePoint):void
    {
        cuePoints.push(newCuePoint);
    }

    public function getCuePointAt(i:int):CuePoint
    {
        return cuePoints[i];
    }

    public function getNearestIndexBefore(time:Number):int
    {
        var i:int;
        var iCue:CuePoint;
        var iDiff:Number;
        var minIndex:Number = -1;
        var minDiff:Number = Number.POSITIVE_INFINITY;

        for (i = 0; i < cuePoints.length; i++)
        {
            iCue = cuePoints[i];
            if (iCue.time <= time)
            {
                iDiff = time - iCue.time;
                if (iDiff < minDiff)
                {
                    minDiff = iDiff;
                    minIndex = i;
                }
            }
        }
        return minIndex;
    }

    public function getNearestIndexAfter(time:Number):int
    {
        var i:int;
        var iCue:CuePoint;
        var iDiff:Number;
        var minIndex:Number = -1;
        var minDiff:Number = Number.POSITIVE_INFINITY;

        for (i = 0; i < cuePoints.length; i++)
        {
            iCue = cuePoints[i];
            if (iCue.time > time)
            {
                iDiff = time - iCue.time;
                if (iDiff < minDiff)
                {
                    minDiff = iDiff;
                    minIndex = i;
                }
            }
        }
        return minIndex;
    }

    public function removeCuePointAt(i:int):CuePoint
    {
        if (i >= 0 && i < cuePoints.length)
        {
            return cuePoints.splice(i, 1)[0];
        }
        else
        {
            return null;
        }
    }

    public function filterByName(name:String):CuePointCollection
    {
        return filterByField("name", name);
    }

    public function filterByType(type:String):CuePointCollection
    {
        return filterByField("type", type);
    }

    private function filterByField(field:String, value:*):CuePointCollection
    {
        return new CuePointCollection(
            cuePoints.filter(
                function (c:CuePoint, ... ignore):Boolean
                {
                    return c[field] == value;
                }
            ));
    }

    public function indexOf(query:CuePoint):int
    {
        return ArrayUtil.getFirst(cuePoints,
            function (compare:CuePoint):Boolean
            {
                return compare.name == query.name &&
                       compare.type == query.type &&
                       compare.time == query.time;
        });
    }

    public function setFromMetaData(arrayOfObjects:Array):void
    {
        cuePoints = arrayOfObjects.map(
            function (obj:*, ... ignored):CuePoint
            {
                return new CuePoint(obj);
            }
        );
    }

    public function sortByTime():void
    {
        cuePoints.sortOn("time", Array.NUMERIC);
    }
}
}
