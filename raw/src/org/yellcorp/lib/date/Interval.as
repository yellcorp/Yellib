package org.yellcorp.lib.date
{
public class Interval
{
    public var start:Date;
    public var end:Date;

    public function Interval(utcStart:Date, utcEnd:Date)
    {
        start = utcStart;
        end = utcEnd;
        if (start == null || end == null)
        {
            throw new ArgumentError("Null argument");
        }
        normalize();
    }

    // factory
    public static function fromDuration(utcStart:Date, numberOrDurationObj:Object, unitsIfNumber:Number = 1):Interval
    {
        var durationMilli:Number;
        var utcEnd:Date;
        if (numberOrDurationObj is Duration)
        {
            durationMilli = Duration(numberOrDurationObj).getTotalMilliseconds();
        }
        else
        {
            durationMilli = Number(numberOrDurationObj) * unitsIfNumber;
        }
        utcEnd = new Date(utcStart.time + durationMilli);
        return new Interval(utcStart, utcEnd);
    }

    public function toString():String
    {
        return "[Interval " + start.toUTCString() + " to " + end.toUTCString() + "]";
    }

    public function normalize():void
    {
        var oldend:Date;
        if (start.time > end.time)
        {
            oldend = end;
            end = start;
            start = oldend;
        }
    }

    public function get duration():Duration
    {
        normalize();
        return new Duration(end.time - start.time);
    }

    public function contains(queryDate:Date):Boolean
    {
        return queryDate.time >= start.time && queryDate.time < end.time;
    }

    public function overlaps(other:Interval):Boolean
    {
        normalize();
        other.normalize();
        return (start.time < other.end.time && end.time > other.start.time);
    }

    /**
     * Subtracts an interval from this one
     *
     * Given this = |-----------------------------|
     *  and other =           |-----------|
     *
     *  sets this = |---------|
     * and returns                        |-------|
     *
     * @param    other    The interval to subtract from this one
     * @return    The remaining other interval, if there is one
     */

    public function subtract(other:Interval):Interval
    {
        var otherResult:Interval = null;

        normalize();
        other.normalize();
        // if subtracting the specifed interval would create a hole
        // in this one, then the first piece is assigned to this object,
        // and the second piece is returned.  if the result is one contiguous
        // interval, then this object is modified and null is returned
        if (overlaps(other))
        {
            if (other.start.time > start.time && other.end.time < end.time)
            {
                otherResult = new Interval(DateUtil.clone(other.end), end);
                end = DateUtil.clone(other.start);
            }
            else
            {
                if (other.start.time < end.time)
                {
                    end = DateUtil.clone(other.start);
                }
                if (other.end.time > start.time)
                {
                    start = DateUtil.clone(other.end);
                }
                if (end.time > start.time)
                {
                    // both conditions were true, meaning other started before this
                    // and ended after it, completely nulling this interval

                    // technically start and end shouldn't have any value, but at the
                    // moment nulls would cause problems if this object was used afterward
                    // so probably just best to check if duration = 0 after each subtraction
                    end = DateUtil.clone(start);
                }
            }
        }
        return otherResult;
    }

    public function clone():Interval
    {
        return new Interval(DateUtil.clone(start), DateUtil.clone(end));
    }

    /**
     * Returns the union of two intervals
     *
     * Given this = |--------------|
     *  and other =         |--------------|
     *
     *      returns |----------------------|
     */
    public static function union(first:Interval, second:Interval):Interval
    {
        var result:Interval = null;
        first.normalize();
        second.normalize();
        result = new Interval(DateUtil.earliest(first.start, second.start), DateUtil.latest(first.end, second.end));
        return result;
    }

    /**
     * Returns the intersection of two intervals
     *
     * Given this = |--------------|
     *  and other =         |--------------|
     *
     *      returns         |------|
     *
     * Will return null if no intersection
     */
    public static function intersection(first:Interval, second:Interval):Interval
    {
        var result:Interval = null;
        if (first.overlaps(second))
        {
            result = new Interval(DateUtil.latest(first.start, second.start), DateUtil.earliest(first.end, second.end));
        }
        return result;
    }
}
}
