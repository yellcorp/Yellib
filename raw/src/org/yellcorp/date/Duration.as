package org.yellcorp.date
{
public class Duration
{
    private var _totalMilliseconds:Number;

    private var _milliseconds:Number = 0;
    private var _seconds:Number = 0;
    private var _minutes:Number = 0;
    private var _hours:Number = 0;
    private var _days:Number = 0;

    private var inUnitsMode:Boolean;

    public function Duration(value:Number = 0, units:Number = 1)
    {
        inUnitsMode = false;
        setTotalMilliseconds(value * units);
    }

    public function getTotalMilliseconds():Number
    {
        sumMode();
        return _totalMilliseconds;
    }

    public function setTotalMilliseconds(value:Number):void
    {
        sumMode();
        _totalMilliseconds = value;
    }

    public function getTotalSeconds():Number
    {
        return getTotalMilliseconds() / TimeUnits.SECOND;
    }

    public function setTotalSeconds(value:Number):void
    {
        setTotalMilliseconds(value * TimeUnits.SECOND);
    }

    public function getTotalMinutes():Number
    {
        return getTotalMilliseconds() / TimeUnits.MINUTE;
    }

    public function setTotalMinutes(value:Number):void
    {
        setTotalMilliseconds(value * TimeUnits.MINUTE);
    }

    public function getTotalHours():Number
    {
        return getTotalMilliseconds() / TimeUnits.HOUR;
    }

    public function setTotalHours(value:Number):void
    {
        setTotalMilliseconds(value * TimeUnits.HOUR);
    }

    public function getTotalDays():Number
    {
        return getTotalMilliseconds() / TimeUnits.DAY;
    }

    public function setTotalDays(value:Number):void
    {
        setTotalMilliseconds(value * TimeUnits.DAY);
    }

    ////// MILLISECONDS //////
    public function getMilliseconds():Number
    {
        unitsMode();
        return _milliseconds;
    }

    public function setMilliseconds(value:Number):void
    {
        unitsMode();
        _milliseconds = value;
        if (_milliseconds < 0 || _milliseconds >= 1000)
        {
            sumMode();
        }
    }

    ////// SECONDS //////
    public function getSeconds():Number
    {
        unitsMode();
        return _seconds;
    }

    public function setSeconds(value:Number):void
    {
        unitsMode();
        _seconds = value;
        if (_seconds < 0 || _seconds >= 60)
        {
            sumMode();
        }
    }

    ////// MINUTES //////
    public function getMinutes():Number
    {
        unitsMode();
        return _minutes;
    }

    public function setMinutes(value:Number):void
    {
        unitsMode();
        _minutes = value;
        if (_minutes < 0 || _minutes >= 60)
        {
            sumMode();
        }
    }

    ////// HOURS //////
    public function getHours():Number
    {
        unitsMode();
        return _hours;
    }

    public function setHours(value:Number):void
    {
        unitsMode();
        _hours = value;
        if (_hours < 0 || _hours >= 24)
        {
            sumMode();
        }
    }

    ////// DAYS //////
    public function getDays():Number
    {
        unitsMode();
        return _days;
    }

    public function setDays(value:Number):void
    {
        unitsMode();
        _days = value;
    }

    public function valueOf():Number
    {
        return getTotalMilliseconds();
    }

    public function toString():String
    {
        return "[Duration " + getDays() + "d " + getHours() + "h " + getMinutes() + "m " + (getSeconds() + getMilliseconds() / 1000) + "s]";
    }

    public static function between(date1:Date, date2:Date):Duration
    {
        return new Duration(date2.time - date1.time, 1);
    }

    private function sumMode():void
    {
        if (inUnitsMode)
        {
            recalculateSum();
            inUnitsMode = false;
        }
    }

    private function unitsMode():void
    {
        if (!inUnitsMode)
        {
            recalculateUnits();
            inUnitsMode = true;
        }
    }

    private function recalculateSum():void
    {
        _totalMilliseconds = _milliseconds + _seconds * TimeUnits.SECOND + _minutes * TimeUnits.MINUTE + _hours * TimeUnits.HOUR + _days * TimeUnits.DAY;
    }

    private function recalculateUnits():void
    {
        var acc:Number = _totalMilliseconds;

        _milliseconds = acc % 1000;
        acc = Math.floor(acc / 1000);
        _seconds = acc % 60;
        acc = Math.floor(acc / 60);
        _minutes = acc % 60;
        acc = Math.floor(acc / 60);
        _hours = acc % 24;

        _days = Math.floor(acc / 24);
    }
}
}
