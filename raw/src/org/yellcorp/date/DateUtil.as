package org.yellcorp.date
{

public class DateUtil
{
    public static function clone(original:Date):Date
    {
        return new Date(original.time);
    }

    public static function add(dateObj:Date,
                               days:Number = 0,
                               hours:Number = 0,
                               minutes:Number = 0,
                               seconds:Number = 0):Date
    {
        dateObj.time += days * TimeUnits.DAY +
                        hours * TimeUnits.HOUR +
                        minutes * TimeUnits.MINUTE +
                        seconds * TimeUnits.SECOND;

        return dateObj;
    }

    public static function addClone(dateObj:Date,
                                    days:Number = 0,
                                    hours:Number = 0,
                                    minutes:Number = 0,
                                    seconds:Number = 0):Date
    {
        var clone:Date = new Date(dateObj.time);

        clone.time += days * TimeUnits.DAY +
                      hours * TimeUnits.HOUR +
                      minutes * TimeUnits.MINUTE +
                      seconds * TimeUnits.SECOND;

        return clone;
    }

    /**
     * @desc Rounds the provided date to the nearest provided unit.
     *
     * For example, call DateUtil.round(yourDate, TimeUnits.HOUR) to round to
     * the nearest hour.  To use your own units, pass in the unit size
     * in milliseconds.  For example, to round to the nearest half hour
     * call DateUtil.round(yourDate, TimeUnits.HOUR/2)
     */
    public static function round(dateObj:Date, resolution:Number):Date
    {
        dateObj.time = Math.round(dateObj.time / resolution) * resolution;
        return dateObj;
    }

    public static function roundClone(dateObj:Date, resolution:Number):Date
    {
        var clone:Date = new Date(dateObj.time);

        clone.time = Math.round(clone.time / resolution) * resolution;
        return clone;
    }

    public static function floor(dateObj:Date, resolution:Number):Date
    {
        dateObj.time = Math.floor(dateObj.time / resolution) * resolution;
        return dateObj;
    }

    public static function floorClone(dateObj:Date, resolution:Number):Date
    {
        var clone:Date = new Date(dateObj.time);

        dateObj.time = Math.floor(clone.time / resolution) * resolution;
        return clone;
    }

    public static function ceil(dateObj:Date, resolution:Number):Date
    {
        dateObj.time = Math.ceil(dateObj.time / resolution) * resolution;
        return dateObj;
    }

    public static function ceilClone(dateObj:Date, resolution:Number):Date
    {
        var clone:Date = new Date(dateObj.time);

        dateObj.time = Math.ceil(clone.time / resolution) * resolution;
        return clone;
    }

    public static function earliest(a:Date, b:Date):Date
    {
        return (a.time < b.time) ? a : b;
    }

    public static function earliestClone(a:Date, b:Date):Date
    {
        return new Date((a.time < b.time) ? a.time : b.time);
    }

    public static function latest(a:Date, b:Date):Date
    {
        return (a.time > b.time) ? a : b;
    }

    public static function latestClone(a:Date, b:Date):Date
    {
        return new Date((a.time > b.time) ? a.time : b.time);
    }

    public static function clamp(queryDate:Date, earliest:Date, latest:Date):Date
    {
        if (earliest !== null && queryDate.time < earliest.time)
        {
            return earliest;
        }
        else if (latest !== null && queryDate.time > latest.time)
        {
            return latest;
        }
        else
        {
            return queryDate;
        }
    }

    public static function clampClone(queryDate:Date, earliest:Date, latest:Date):Date
    {
        if (earliest !== null && queryDate.time < earliest.time)
        {
            return new Date(earliest.time);
        }
        else if (latest !== null && queryDate.time > latest.time)
        {
            return new Date(latest.time);
        }
        else
        {
            return new Date(queryDate.time);
        }
    }

    public static function cmp(a:Date, b:Date):int
    {
        if (a.time > b.time)
        {
            return -1;
        }
        else if (a.time < b.time)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    public static function lerpDate(date1:Date, date2:Date, t:Number):Date
    {
        var epoch:Number = Math.round((1 - t) * date1.time + t * date2.time);
        return new Date(epoch);
    }
}
}
