package org.yellcorp.date
{
public class XSDDuration
{
    public var years:int;
    public var months:int;
    public var days:int;
    public var hours:int;
    public var minutes:int;
    public var seconds:Number;

    public var positive:Boolean;

    public static const UNKNOWN:int = 0;
    public static const EQUAL:int = 1;
    public static const LESS:int = 2;
    public static const GREATER:int = 4;

    public static const LESS_OR_EQUAL:int = 3;
    public static const GREATER_OR_EQUAL:int = 5;

    private static var ref1:Date = new Date(Date.UTC(1696, 8, 1));
    private static var ref2:Date = new Date(Date.UTC(1697, 1, 1));
    private static var ref3:Date = new Date(Date.UTC(1903, 2, 1));
    private static var ref4:Date = new Date(Date.UTC(1903, 6, 1));

    private static var indCmp:Date = new Date(0);

    private static const PARSE_PATTERN:RegExp =
        /([+-])?P((\d+)Y)?((\d+)M)?((\d+)D)?(T((\d+)H)?((\d+)M)?((\d+)?(\.\d+)?S)?)?/i ;
    /*   |       ||       ||       ||       | ||       ||       ||     |
     *   1: Sign |3: Year ||       |7: Day  | ||       ||       ||     15: Fractional seconds
     *           |        ||       |        | ||       ||       |14: Whole seconds
     *           |        ||       |        | ||       ||       13: Seconds unit
     *           |        ||       |        | ||       |12: Minutes
     *           |        ||       |        | ||       11: Minutes unit
     *           |        ||       |        | |10: Hours
     *           |        ||       |        | 9: Hours unit
     *           |        ||       |        8: Sub-day units
     *           |        ||       6: Day unit
     *           |        |5: Month
     *           |        4: Month unit
     *           2: Year unit
     */

    public function XSDDuration(
        years:int = 0,
        months:int = 0,
        days:int = 0,
        hours:int = 0,
        minutes:int = 0,
        seconds:Number = 0,
        positive:Boolean = true)
    {
        this.years = years;
        this.months = months;
        this.days = days;
        this.hours = hours;
        this.minutes = minutes;
        this.seconds = seconds;

        this.positive = positive;
    }

    public function get isDeterminate():Boolean
    {
        return years == 0 && months == 0;
    }

    public function makeDeterminate():void
    {
        hours += years * 8766;
        minutes += months * 43830;
        years = 0;
        months = 0;
    }

    public function get wholeSeconds():int
    {
        return Math.floor(seconds);
    }

    public function get milliseconds():int
    {
        return Math.round(seconds * 1000) % 1000;
    }

    public function getTotalMilliseconds(referenceDate:Date):Number
    {
        return addToDateEpoch(referenceDate) - referenceDate.time;
    }

    public function addToDate(date:Date, outDate:Date = null):Date
    {
        return _addToDate(this, date, outDate, true);
    }

    public function addToDateEpoch(date:Date):Number
    {
        return _addToDateEpoch(this, date, true);
    }

    public function subtractFromDate(date:Date, outDate:Date = null):Date
    {
        return _addToDate(this, date, outDate, false);
    }

    public function subtractFromDateEpoch(date:Date):Number
    {
        return _addToDateEpoch(this, date, false);
    }

    public function equals(other:XSDDuration):Boolean
    {
        return isEqual(this, other);
    }

    public function isGreater(other:XSDDuration):Boolean
    {
        return (compare(this, other) & GREATER) != 0;
    }

    public function isGreaterOrEqual(other:XSDDuration):Boolean
    {
        return (compare(this, other) & GREATER_OR_EQUAL) != 0;
    }

    public function isLess(other:XSDDuration):Boolean
    {
        return (compare(this, other) & LESS) != 0;
    }

    public function isLessOrEqual(other:XSDDuration):Boolean
    {
        return (compare(this, other) & LESS_OR_EQUAL) != 0;
    }

    public function toString():String
    {
        var outStr:String = positive ? "P" : "-P";
        if (years) outStr += years + "Y";
        if (months) outStr += months + "M";
        if (days) outStr += days + "D";
        if (hours || minutes || seconds)
        {
            outStr += "T";
            if (hours) outStr += hours + "H";
            if (minutes) outStr += minutes + "M";
            if (seconds) outStr += seconds + "S";
        }
        return outStr;
    }

    internal function get determinateMsec():Number
    {
        var absSeconds:Number = seconds * 1000 + minutes * 60000 + hours * 3600000 + days * 86400000;
        return positive ? absSeconds : -absSeconds;
    }

    public static function isEqual(left:XSDDuration, right:XSDDuration):Boolean
    {
        if (!left && !right)
        {
            return true;
        }
        else if (!left || !right)
        {
            return false;
        }
        else
        {
            return compare(left, right) == EQUAL;
        }
    }

    public static function sort(a:XSDDuration, b:XSDDuration):int
    {
        var result:int = compare(a, b);
        if (result == GREATER)
        {
            return 1;
        }
        else if (result == LESS)
        {
            return -1;
        }
        else
        {
            // sort EQUAL and UNKNOWN the same
            return 0;
        }
    }

    public static function compare(left:XSDDuration, right:XSDDuration):int
    {
        if (!left && !right)
        {
            return EQUAL;
        }
        else if (!left || !right)
        {
            return UNKNOWN;
        }
        else if (left.isDeterminate && right.isDeterminate)
        {
            return compareDeterminate(left, right);
        }
        else
        {
            return compareIndeterminate(left, right);
        }
    }

    public static function parse(str:String):XSDDuration
    {
        var result:XSDDuration;
        var match:Object;

        match = PARSE_PATTERN.exec(str);

        if (!match) throw new ArgumentError("Not a valid xsd:duration string");

        result = new XSDDuration();
        if (match[1] == "-") result.positive = false;
        if (match[2]) result.years = parseInt(match[3]);
        if (match[4]) result.months = parseInt(match[5]);
        if (match[6]) result.days = parseInt(match[7]);
        if (match[8])
        {
            if (match[9]) result.hours = parseInt(match[10]);
            if (match[11]) result.minutes = parseInt(match[12]);
            if (match[13])
            {
                if (match[14]) result.seconds += parseInt(match[14]);
                if (match[15]) result.seconds += parseFloat(match[15]);
            }
        }

        return result;
    }

    private static function compareDeterminate(left:XSDDuration, right:XSDDuration):int
    {
        return compareQuantity(left.determinateMsec, right.determinateMsec);
    }

    private static function compareIndeterminate(left:XSDDuration, right:XSDDuration):int
    {
        var comp1:int = compareRef(left, right, ref1);
        var comp2:int = compareRef(left, right, ref2);
        var comp3:int = compareRef(left, right, ref3);
        var comp4:int = compareRef(left, right, ref4);

        if (comp1 == comp2 && comp2 == comp3 && comp3 == comp4)
        {
            return comp1;
        }
        else
        {
            return UNKNOWN;
        }
    }

    private static function compareRef(left:XSDDuration, right:XSDDuration, ref:Date):int
    {
        var leftTotal:Number = left.addToDate(ref, indCmp).time;
        var rightTotal:Number = right.addToDate(ref, indCmp).time;
        return compareQuantity(leftTotal, rightTotal);
    }

    private static function compareQuantity(left:Number, right:Number):int
    {
        if (isNaN(left) || isNaN(right))
        {
            return UNKNOWN;
        }
        else if (left > right)
        {
            return GREATER;
        }
        else if (left < right)
        {
            return LESS;
        }
        else
        {
            return EQUAL;
        }
    }

    private static function _addToDate(duration:XSDDuration, date:Date, outDate:Date, doAddition:Boolean):Date
    {
        if (!outDate) outDate = new Date(0);
        outDate.time = _addToDateEpoch(duration, date, doAddition);
        return outDate;
    }

    private static function _addToDateEpoch(duration:XSDDuration, date:Date, doAddition:Boolean):Number
    {
        if (doAddition == duration.positive)
        {
            return Date.UTC(
                date.fullYearUTC + duration.years,
                date.monthUTC + duration.months,
                date.dateUTC + duration.days,
                date.hoursUTC + duration.hours,
                date.minutesUTC + duration.minutes,
                date.secondsUTC + duration.wholeSeconds,
                date.millisecondsUTC + duration.milliseconds
            );
        }
        else
        {
            return Date.UTC(
                date.fullYearUTC - duration.years,
                date.monthUTC - duration.months,
                date.dateUTC - duration.days,
                date.hoursUTC - duration.hours,
                date.minutesUTC - duration.minutes,
                date.secondsUTC - duration.wholeSeconds,
                date.millisecondsUTC - duration.milliseconds
            );
        }
    }
}
}
