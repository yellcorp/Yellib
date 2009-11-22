package org.yellcorp.color
{
import org.yellcorp.color.VectorRGB;

import flash.errors.IllegalOperationError;


public class Gradient extends BaseGradient
{
    private var _colors:Array;
    private var _colorsUint:Array;
    private var _alphas:Array;
    private var _ratios:Array;

    private var _length:int;

    private var colorsValid:Boolean = false;
    private var ratiosValid:Boolean = false;

    public function Gradient(colors:Array, alphas:Array = null, ratios:Array = null)
    {
        _length = colors.length;

        _setColors(colors);
        _setAlphas(alphas);
        _setRatios(ratios);
    }

    protected override function putRGB(point:Number, out:VectorRGB):void
    {
        var fracIndex:Number = findIndex(point);
        var intIndex:int = int(fracIndex);
        fracIndex -= intIndex;

        _putRGBAtIndex(intIndex, fracIndex, out);
    }

    public override function getAlpha(point:Number):Number
    {
        var fracIndex:Number = findIndex(point);
        var intIndex:int = int(fracIndex);
        fracIndex -= intIndex;

        return _getAlphaAtIndex(intIndex, fracIndex);
    }

    public override function getColorArray():Array
    {
        if (!ratiosValid) sort();
        if (!colorsValid) recalcColors();
        return _colorsUint.slice();
    }

    public override function getAlphaArray():Array
    {
        if (!ratiosValid) sort();
        return _alphas.slice();
    }

    public override function getRatioArray():Array
    {
        if (!ratiosValid) sort();
        return _ratios.slice();
    }

    // CLASS-SPECIFIC
    public function getRGBAtIndex(index:Number, out:VectorRGB = null):VectorRGB
    {
        if (!ratiosValid) sort();

        var fracIndex:Number = index;
        var intIndex:int = int(index);
        fracIndex -= intIndex;

        if (!out) out = new VectorRGB();
        _putRGBAtIndex(intIndex, fracIndex, out);
        return out;
    }

    public function getAlphaAtIndex(index:Number):Number
    {
        if (!ratiosValid) sort();

        var fracIndex:Number = index;
        var intIndex:int = int(fracIndex);
        fracIndex -= intIndex;

        return _getAlphaAtIndex(fracIndex, intIndex);
    }

    public function getRatioAtIndex(index:int):Number
    {
        if (!ratiosValid) sort();

        return _ratios[index];
    }

    public function setRGBAtIndex(index:int, value:VectorRGB):void
    {
        if (!ratiosValid) sort();

        VectorRGB(_colors[index]).copy(value);
        colorsValid = false;
    }

    public function setAlphaAtIndex(index:int, value:Number):void
    {
        if (!ratiosValid) sort();
        _alphas[index] = value;
    }

    public function setRatioAtIndex(index:int, value:Number):void
    {
        if (!ratiosValid) sort();

        if ((index > 0 && value < _ratios[index - 1]) ||
            (index < _length-1 && value > _ratios[index +1]))
        {
            ratiosValid = false;
        }

        _ratios[index] = value;
    }

    public function remove(index:int):void
    {
        if (!ratiosValid) sort();

        _colors.splice(index, 1);
        _alphas.splice(index, 1);
        _ratios.splice(index, 1);

        _length--;

        colorsValid = false;
    }

    public function insert(point:Number, color:VectorRGB = null, alpha:Number = Number.NaN):void
    {
        if (point < 0 || point > 255)
            throw new ArgumentError("point must be in the range 0-255");

        if (!ratiosValid) sort();

        var fracIndex:Number = findIndex(point);
        var intIndex:int = int(fracIndex);
        fracIndex -= intIndex;

        if (!color)
        {
            color = new VectorRGB();
            _putRGBAtIndex(intIndex, fracIndex, color);
        }

        if (isNaN(alpha))
        {
            alpha = _getAlphaAtIndex(intIndex, fracIndex);
        }

        _colors.splice(intIndex+1, 0, color);
        _alphas.splice(intIndex+1, 0, alpha);
        _ratios.splice(intIndex+1, 0, point);
        _length++;

        colorsValid = false;
    }

    private function _putRGBAtIndex(intIndex:int, fracIndex:Number, out:VectorRGB):void
    {
        if (!ratiosValid) sort();

        if (fracIndex == 0)
        {
            out.copy(_colors[intIndex]);
        }
        else
        {
            VectorRGB.lerp(_colors[intIndex], _colors[intIndex + 1], fracIndex, out);
        }
    }

    private function _getAlphaAtIndex(intIndex:int, fracIndex:Number):Number
    {
        var a1:Number;
        var a2:Number;

        if (!ratiosValid) sort();

        a1 = _alphas[intIndex];
        a2 = _alphas[intIndex + 1];

        return a1 + fracIndex * (a2 - a1);
    }

    private function findIndex(point:Number):Number
    {
        var iLow:int = 0;
        var iHi:int = _length - 1;
        var iPivot:Number;

        var vLow:Number;
        var vHi:Number;
        var vPivot:Number;

        var maxIter:int = _length;

        if (maxIter == 0)
            throw new IllegalOperationError("Empty gradient");

        if (maxIter == 1)
            return 0;

        if (point <= _ratios[iLow]) return iLow;
        if (point >= _ratios[iHi]) return iHi;

        while (maxIter-- > 0)
        {
            if (iHi - iLow <= 1)
            {
                vLow = _ratios[iLow];
                vHi = _ratios[iHi];
                if (vHi == vLow)
                    return iLow;
                else
                    return iLow + (point - vLow) / (vHi - vLow);
            }

            iPivot = (iLow + iHi) >> 1;    // floor average
            vPivot = _ratios[iPivot];

            if (point == vPivot) return iPivot;

            if (point < vPivot)
                iHi = iPivot;
            else
                iLow = iPivot;
        }

        throw new Error("Internal error: Exhausted search");

        return null;
    }

    private function sort():void
    {
        var order:Array = _ratios.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
        _colors = reorderArray(_colors, order);
        _alphas = reorderArray(_alphas, order);
        _ratios = reorderArray(_ratios, order);

        ratiosValid = true;
        colorsValid = false;
    }

    private function recalcColors():void
    {
        var i:int;
        var cv:VectorRGB;

        _colorsUint = new Array(_length);

        for (i = 0; i < _length; i++)
        {
            cv = _colors[i];
            _colorsUint[i] = cv.getUint24();
        }
        colorsValid = true;
    }

    private function _setColors(colors:Array):void
    {
        var i:int;
        var uintCount:uint = 0;

        if (!colors)
            throw new ArgumentError("Colors array must be non-null");
        else if (colors.length == 0)
            throw new ArgumentError("Colors array must be non-empty");
        else if (colors.length != _length)
            throw new ArgumentError("New colors array must be equal length to old colors array");

        colorsValid = false;
        _colors = new Array(_length);
        _colorsUint = new Array(_length);

        for (i = 0; i < _length; i++)
        {
            if (colors[i] is VectorRGB)
            {
                _colors[i] = colors[i];
            }
            else if (colors[i] is uint)
            {
                uintCount++;
                _colorsUint[i] = colors[i];
                _colors[i] = VectorRGB.fromUint24(colors[i]);
            }
            else
            {
                throw new ArgumentError("Unexpected type in colors array: Expecting either uint or VectorRGB. Got " + colors[i].toString() + " at index " + i);
            }
        }

        if (uintCount == _length)
            colorsValid = true;
    }

    private function _setAlphas(alphas:Array):void
    {
        var i:int;
        if (alphas != null)
        {
            if (_alphas.length != _length)
                throw new ArgumentError("Number of alphas must match number of colors");
            _alphas = alphas.slice();
        }
        else
        {
            _alphas = new Array(_length);
            for (i = 0; i < _length; i++)
                _alphas[i] = 1;
        }
    }

    private function _setRatios(ratios:Array):void
    {
        var i:int;
        var thisRatio:Number;
        var lastRatio:Number;
        var step:Number;

        ratiosValid = true;
        _ratios = new Array(_length);

        if (ratios != null)
        {
            if (_ratios.length != _length)
                throw new ArgumentError("Number of ratios must match number of colors");

            for (i = 0; i < _length; i++)
            {
                thisRatio = ratios[i];
                if (i > 0 && thisRatio < lastRatio)
                    ratiosValid = false;

                lastRatio = _ratios[i] = thisRatio;
            }
        }
        else
        {
            step = 255 / (_length - 1);
            for (i = 0; i < _length; i++)
            {
                _ratios[i] = i * step;
            }
        }
    }

    private static function reorderArray(input:Array, indices:Array):Array
    {
        var i:int;
        var output:Array = new Array(indices.length);

        for (i = 0; i < indices.length; i++)
            output[i] = input[indices[i]];

        return output;
    }
}
}
