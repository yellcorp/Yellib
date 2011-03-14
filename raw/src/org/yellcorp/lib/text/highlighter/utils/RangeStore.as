package org.yellcorp.lib.text.highlighter.utils
{
import flash.utils.Dictionary;


public class RangeStore
{
    private var lengthsStart:Dictionary;
    private var lengthsEnd:Dictionary;

    public function RangeStore()
    {
        clear();
    }

    public function clear():void
    {
        lengthsStart = new Dictionary();
        lengthsEnd = new Dictionary();
    }

    public function hasRange(start:int):Boolean
    {
        return lengthsStart.hasOwnProperty(start);
    }

    public function deleteRange(start:int):Boolean
    {
        var end:int;
        if (hasRange(start))
        {
            end = start + getLength(start);

            return delete lengthsStart[start] &&
                   delete lengthsEnd[end];
            return true;
        }
        else
        {
            return delete lengthsStart[start];
        }
    }

    public function getLength(start:int):int
    {
        if (hasRange(start))
        {
            return lengthsStart[start];
        }
        else
        {
            return 0;
        }
    }

    public function setLength(start:int, length:int):void
    {
        lengthsStart[start] = length;
        lengthsEnd[start + length] = length;
    }

    public function getAllRanges():Array
    {
        var k:*;
        var result:Array = [ ];

        for (k in lengthsStart)
        {
            result.push({start: k, length: lengthsStart[k]});
        }
        return result;
    }

    public function getRangesInRange(low:int, high:int):Array
    {
        var result:Array = [ ];

        pushStartsInRange(low, high, result);
        pushEndsInRange(low, high, result);

        return result;
    }

    private function pushStartsInRange(low:int, high:int, out:Array):void
    {
        var k:*;
        for (k in lengthsStart)
        {
            if (k >= low && k < high)
            {
                out.push({start: k, length: lengthsStart[k]});
            }
        }
    }

    private function pushEndsInRange(low:int, high:int, out:Array):void
    {
        var k:*;
        var length:int;
        var start:int;
        for (k in lengthsEnd)
        {
            if (k >= low && k < high)
            {
                length = lengthsEnd[k];
                start = k - length;
                if (start < low)
                {
                    out.push({start: start, length: length});
                }
            }
        }
    }
}
}
