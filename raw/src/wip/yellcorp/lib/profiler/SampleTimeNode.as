package wip.yellcorp.lib.profiler
{
import flash.utils.Dictionary;


public class SampleTimeNode
{
    private var _totalCumulativeTime:Number;
    private var _totalLocalTime:Number;
    private var _subUnits:Dictionary;
    private var _parent:SampleTimeNode;

    public function SampleTimeNode(parentNode:SampleTimeNode)
    {
        _parent = parentNode;
        clear();
    }

    public function clear():void
    {
        _totalLocalTime = 0;
        _totalCumulativeTime = 0;
        _subUnits = new Dictionary();
    }

    public function addTime(usec:Number, idArray:Array, trueForLocal:Boolean):void
    {
        var childNode:SampleTimeNode;
        var childId:*;

        if (trueForLocal)
        {
            _totalLocalTime += usec;
        }
        else
        {
            _totalCumulativeTime += usec;
        }

        if (idArray && idArray.length > 0)
        {
            childId = idArray.shift();

            if (childId == null) return;

            childNode = _subUnits[childId];
            if (!childNode)
            {
                childNode = _subUnits[childId] = new SampleTimeNode(this);
            }
            childNode.addTime(usec, idArray, trueForLocal);
        }
    }

    public function get totalCumulativeTime():Number
    {
        return _totalCumulativeTime;
    }

    public function get totalLocalTime():Number
    {
        return _totalLocalTime;
    }

    public function get childIDs():Array
    {
        var key:*;
        var ids:Array = [ ];

        for (key in _subUnits)
        {
            ids.push(key);
        }
        return ids;
    }

    public function getChildTime(id:*):SampleTimeNode
    {
        return _subUnits[id];
    }
}
}
