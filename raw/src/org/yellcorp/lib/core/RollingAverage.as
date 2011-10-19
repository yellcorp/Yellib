package org.yellcorp.lib.core
{
public class RollingAverage
{
    private var _average:Number;

    private var _size:uint;

    private var samples:Array;
    private var pointer:uint;
    private var full:Boolean;

    public function RollingAverage(size:uint)
    {
        if (size == 0) throw new ArgumentError("size must be greater than zero");
        _size = size;
        samples = new Array(_size);
        pointer = 0;
        full = false;
    }

    public function sample(value:Number):void
    {
        if (full)
        {
            value /= _size;
            _average = _average - samples[pointer] + value;
            samples[pointer] = value;
        }
        else if (pointer == 0)
        {
            samples[pointer] = value / _size;
            _average = value;
        }
        else
        {
            samples[pointer] = value / _size;
            _average = _average * (pointer / (pointer + 1)) + value / (pointer + 1);
        }
        if (++pointer == _size)
        {
            full = true;
            pointer = 0;
        }
    }

    public function get average():Number
    {
        return _average;
    }

    public function get size():uint
    {
        return _size;
    }
}
}
