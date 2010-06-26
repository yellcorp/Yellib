package org.yellcorp.math
{
public class Range
{
    private var _min:Number;
    private var _max:Number;
    private var _minInclusive:Boolean = true;
    private var _maxInclusive:Boolean = true;

    private var containFunc:Function;

    public function Range(min:Number, max:Number, minInclusive:Boolean = true, maxInclusive:Boolean = true)
    {
        this.min = min;
        this.max = max;
        this.minInclusive = minInclusive;
        this.maxInclusive = maxInclusive;
    }

    public function clone():Range
    {
        return new Range(_min, _max, _minInclusive, _maxInclusive);
    }

    public function get min():Number
    {
        return _min;
    }

    public function set min(new_min:Number):void
    {
        if (new_min > _max)
        {
            _min = _max;
            _max = new_min;
        }
        else
        {
            _min = new_min;
        }
    }

    public function get max():Number
    {
        return _max;
    }

    public function set max(new_max:Number):void
    {
        if (new_max < _min)
        {
            _max = _min;
            _min = new_max;
        }
        else
        {
            _max = new_max;
        }
    }

    public function get minInclusive():Boolean
    {
        return _minInclusive;
    }

    public function set minInclusive(new_minInclusive:Boolean):void
    {
        _minInclusive = new_minInclusive;
        setWithinFunc();
    }

    public function get maxInclusive():Boolean
    {
        return _maxInclusive;
    }

    public function set maxInclusive(new_maxInclusive:Boolean):void
    {
        _maxInclusive = new_maxInclusive;
        setWithinFunc();
    }

    public function get difference():Number
    {
        return _max - _min;
    }

    public function param(t:Number):Number
    {
        return _min + t * (_max - _min);
    }

    public function toString():String
    {
        return ( _minInclusive ? "[" : "(" ) +
               _min + ", " + _max +
               ( _maxInclusive ? "]" : ")" );
    }

    public function grow(numToInclude:Number):void
    {
        if (numToInclude > _max)
        {
            max = numToInclude;
            if (!_maxInclusive) maxInclusive = true;
        }
        if (numToInclude < _min)
        {
            min = numToInclude;
            if (!_minInclusive) minInclusive = true;
        }
    }

    public function contains(query:Number):Boolean
    {
        return containFunc(query);
    }

    private function setWithinFunc():void
    {
        if (_minInclusive)
        {
            containFunc = _maxInclusive ? containsIncInc : containsIncExc;
        }
        else
        {
            containFunc = _maxInclusive ? containsExcInc : containsExcExc;
        }
    }

    private function containsIncInc(query:Number):Boolean
    {
        return (isNaN(_min) || query >= _min) &&
               (isNaN(_max) || query <= _max);
    }

    private function containsIncExc(query:Number):Boolean
    {
        return (isNaN(_min) || query >= _min) &&
               (isNaN(_max) || query < _max);
    }

    private function containsExcInc(query:Number):Boolean
    {
        return (isNaN(_min) || query > _min) &&
               (isNaN(_max) || query <= _max);
    }

    private function containsExcExc(query:Number):Boolean
    {
        return (isNaN(_min) || query > _min) &&
               (isNaN(_max) || query < _max);
    }
}
}
