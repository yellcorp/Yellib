package org.yellcorp.lib.debug
{
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Matrix;


public class SampleSet
{
    private var samples:Array;

    private var ptr:uint;
    private var _size:uint;
    private var filled:uint = 0;

    public function SampleSet(initialSize:uint)
    {
        _size = initialSize;
        samples = new Array(_size);
        ptr = 0;
    }

    public function add(value:Number):void
    {
        samples[ptr++] = value;
        if (ptr >= _size) ptr = 0;
        if (filled < _size) filled++;
    }

    public function getLast():Number
    {
        if (filled == 0)
            return Number.NaN;
        else if (ptr == 0)
            return samples[_size-1];
        else
            return samples[ptr-1];
    }

    public function getMin():Number
    {
        var i:uint;
        var m:uint = filled;

        var val:Number = Number.POSITIVE_INFINITY;

        for (i = 0;i < m; i++)
            if (samples[i] < val) val = samples[i];

        return val;
    }

    public function getMax():Number
    {
        var i:uint;
        var m:uint = filled;

        var val:Number = Number.NEGATIVE_INFINITY;

        for (i = 0;i < m; i++)
            if (samples[i] > val) val = samples[i];

        return val;
    }

    public function getAverage():Number
    {
        var i:uint;
        var m:uint = filled;

        var val:Number = 0;

        for (i = 0;i < m; i++)
            val += samples[i];

        return val / m;
    }

    public function draw(targetBitmap:BitmapData, tempShape:Shape):void
    {
        var g:Graphics = tempShape.graphics;

        var min:Number = getMin();
        var max:Number = getMax();
        var range:Number = max - min;

        var gscale:int = 256;

        var i:uint;
        var index:uint;
        var value:Number;

        var oldestIndex:uint = filled < _size ? 0 : ptr + 1;

        var drawMatrix:Matrix = new Matrix(targetBitmap.width / _size,
                                           0,
                                           0,
                                           -targetBitmap.height / gscale,
                                           0,
                                           targetBitmap.height);

        value = samples[oldestIndex];
        g.moveTo(0, gscale * (value - min) / range);

        for (i = 1; i+1 < filled; i++)
        {
            index = (oldestIndex + i) % _size;
            value = samples[index];

            g.lineTo(i, gscale * (value - min) / range);
        }

        targetBitmap.draw(tempShape, drawMatrix);
    }
}
}
