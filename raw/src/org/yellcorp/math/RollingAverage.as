package org.yellcorp.math
{
public class RollingAverage
{
    private var size:int;
    private var pointer:int;
    private var length:int;
    private var samples:Array;

    public function RollingAverage(windowSize:int)
    {
        size = windowSize;
        clear();
    }

    public function clear():void
    {
        samples = new Array(size);
        pointer = 0;
        length = 0;
    }

    public function sample(value:Number):void
    {
        samples[pointer] = value;
        if (length < size) length++;
        pointer = (pointer + 1) % size;
    }

    public function get average():Number
    {
        var i:int;
        var result:Number = 0;
        for (i = 0; i < length; i++)
        {
            result += samples[i];
        }
        return result / length;
    }
}
}
