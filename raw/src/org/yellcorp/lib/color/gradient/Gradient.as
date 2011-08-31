package org.yellcorp.lib.color.gradient
{
import org.yellcorp.lib.error.AssertError;


public class Gradient implements GraphicsGradient
{
    public var useAlpha:Boolean;

    internal var stale:Boolean;

    private var vertices:Array;
    private var spans:Array;

    public function Gradient(useAlpha:Boolean,
        colors:Array = null, alphas:Array = null, ratios:Array = null)
    {
        this.useAlpha = useAlpha;

        if (colors)
        {
            setFromGraphicsArrays(colors, alphas, ratios);
        }
        else
        {
            clear();
        }
    }

    public function clear():void
    {
        if (vertices)
        {
            for each (var v:GradientVertex in vertices)
            {
                v.owner = null;
            }
        }
        vertices = [ ];
        spans = [ ];
        stale = false;
    }

    public function get vertexCount():uint
    {
        return vertices.length;
    }

    public function addVertex(newVertex:GradientVertex):void
    {
        if (newVertex.owner)
        {
            newVertex = newVertex.clone();
        }
        newVertex.owner = this;
        vertices.push(newVertex);
        stale = true;
    }

    public function getVertexAtIndex(index:int):GradientVertex
    {
        if (stale) recalculate();
        return vertices[index];
    }

    public function removeVertexAtIndex(index:int):GradientVertex
    {
        var vertex:GradientVertex;

        if (stale) recalculate();

        vertex = vertices[index];

        if (vertex)
        {
            vertices.splice(index, 1);
            vertex.owner = null;
            stale = true;
        }

        return vertices[index];
    }

    public function getNearestIndexBefore(param:Number):int
    {
        if (stale) recalculate();

        var lowIndex:int;
        var highIndex:int;
        var pivotIndex:int;

        var pivotVertex:GradientVertex;

        // imposes a maximum limit on loop. if this reaches zero, error!
        var i:int = vertices.length;

        if (i == 0)
        {
            return -1;
        }
        else if (i == 1)
        {
            return 0;
        }
        else
        {
            lowIndex = 0;
            highIndex = i - 1;

            if (param < vertices[0]._param)
            {
                return -1;
            }
            else if (param > vertices[highIndex]._param)
            {
                return highIndex;
            }

            while (i-- >= 0)
            {
                if (highIndex - lowIndex <= 1)
                {
                    return lowIndex;
                }

                pivotIndex = (lowIndex + highIndex) * .5;
                pivotVertex = vertices[pivotIndex];

                if (param == pivotVertex._param)
                {
                    return pivotIndex;
                }
                else if (param < pivotVertex._param)
                {
                    highIndex = pivotIndex;
                }
                else
                {
                    lowIndex = pivotIndex;
                }
            }
            AssertError.assert(false, "Too many iterations in binary search");
            return -1;
        }
    }

    public function getParamARGB(param:Number):uint
    {
        var index:int = getNearestIndexBefore(param);
        var maxIndex:int = vertices.length - 1;
        var result:uint;

        if (index < 0)
        {
            if (maxIndex < 0)
            {
                result = 0;
            }
            else
            {
                result =  vertices[0].value;
            }
        }
        else if (index == maxIndex)
        {
            result =  vertices[maxIndex].value;
        }
        else
        {
            result =  interpolateSpan(spans[index], param, useAlpha);
        }
        return useAlpha ? result : result | 0xFF000000;
    }

    public function getParamRGB(param:Number):uint
    {
        return getParamARGB(param) & 0xFFFFFF;
    }

    public function getParamAlpha(param:Number):Number
    {
        return useAlpha ? (getParamARGB(param) >>> 24) * 0.00392156862745098
                        : 1;
    }

    public function getColorArray():Array
    {
        var colors:Array;

        if (vertices.length == 0)
        {
            return [ 0, 0 ];
        }
        else
        {
            if (stale) recalculate();
            colors = vertices.map(vertexToRGB);
            if (colors.length == 1)
            {
                colors.push(colors[0]);
            }
            return colors;
        }
    }

    private static function
    vertexToRGB(vertex:GradientVertex, a:*, i:*):Number
    {
        return vertex._value & 0xFFFFFF;
    }

    public function getAlphaArray():Array
    {
        var alphas:Array;

        if (vertices.length == 0)
        {
            return [ 1, 1 ];
        }
        else if (useAlpha)
        {
            if (stale) recalculate();
            alphas = vertices.map(vertexToAlpha);
            if (alphas.length == 1)
            {
                alphas.push(alphas[0]);
            }
            return alphas;
        }
        else
        {
            return repeat(1, Math.max(2, vertices.length));
        }
    }

    private static function
    vertexToAlpha(vertex:GradientVertex, a:*, i:*):Number
    {
        return (vertex._value >>> 24) * 0.00392156862745098;
    }

    public function getRatioArray():Array
    {
        if (vertices.length <= 1)
        {
            return [ 0, 255 ];
        }
        else
        {
            if (stale) recalculate();
            return vertices.map(vertexToRatio);
        }
    }

    private static function
    vertexToRatio(vertex:GradientVertex, a:*, i:*):Number
    {
        return vertex._param;
    }

    public function setFromGraphicsArrays(
        colors:Array, alphas:Array = null, ratios:Array = null):void
    {
        var i:int;

        clear();

        if (!colors)
        {
            colors = [ ];
        }

        if (alphas)
        {
            if (alphas.length != colors.length)
            {
                throw ArgumentError("If specified, alphas must be the same length as colors");
            }
        }
        else
        {
            alphas = repeat(1, colors.length);
        }

        if (ratios)
        {
            if (ratios.length != colors.length)
            {
                throw ArgumentError("If specified, ratios must be the same length as colors");
            }
        }
        else
        {
            ratios = distribute(0, 255, colors.length);
        }

        for (i = 0; i < colors.length; i++)
        {
            addVertex(new GradientVertex(ratios[i], uint(alphas[i] * 0xFF) << 24 | colors[i]));
        }
    }

    private function recalculate():void
    {
        var i:int;
        var length:int;

        var span:Span;

        var thisVertex:GradientVertex;
        var nextVertex:GradientVertex;

        vertices.sortOn("param", Array.NUMERIC);

        length =
        spans.length = vertices.length;

        for (i = 0; i < length; i++)
        {
            thisVertex = vertices[i];
            nextVertex = vertices[i + 1];

            span = spans[i];
            if (!span)
            {
                spans[i] = span = new Span();
            }

            calculateSpan(thisVertex, nextVertex, span);
        }
        stale = false;
    }

    private static function
    calculateSpan(v:GradientVertex, w:GradientVertex, span:Span):void
    {
        var invFactor:Number;

        // first vertex channels
        var va:uint, vr:uint, vg:uint, vb:uint;

        // second vertex channels
        var wa:uint, wr:uint, wg:uint, wb:uint;

        // channel interpolation factors
        // (i.e. (w.value - v.value) / (w.time - v.time)
        var ia:Number, ir:Number, ig:Number, ib:Number;

        span.param = v._param;

        va = (v._value & 0xFF000000) >>> 24;
        vr = (v._value & 0x00FF0000) >>> 16;
        vg = (v._value & 0x0000FF00) >>>  8;
        vb = (v._value & 0x000000FF);

        if (w)
        {
            invFactor = 1 / (w._param - v._param);

            wa = (w._value & 0xFF000000) >>> 24;
            wr = (w._value & 0x00FF0000) >>> 16;
            wg = (w._value & 0x0000FF00) >>>  8;
            wb = (w._value & 0x000000FF);

            ia = (wa - va) * invFactor;
            ir = (wr - vr) * invFactor;
            ig = (wg - vg) * invFactor;
            ib = (wb - vb) * invFactor;
        }
        else
        {
            ia = ir = ig = ib = 0;
        }

        span.va = va;
        span.vr = vr;
        span.vg = vg;
        span.vb = vb;

        span.ia = ia;
        span.ir = ir;
        span.ig = ig;
        span.ib = ib;
    }

    private static function
    interpolateSpan(span:Span, param:Number, withAlpha:Boolean):uint
    {
        var t:Number;
        var a:int, r:int, g:int, b:int;

        t = param - span.param;

        if (withAlpha)
        {
            a = span.va + t * span.ia;
        }

        r = span.vr + t * span.ir;
        g = span.vg + t * span.ig;
        b = span.vb + t * span.ib;

        if (withAlpha)
        {
            return (a << 24) | (r << 16) | (g << 8) | b;
        }
        else
        {
            return (r << 16) | (g << 8) | b;
        }
    }

    private static function repeat(element:int, length:uint):Array
    {
        var array:Array = new Array(length);

        for (var i:int = length - 1; i >= 0; i--)
        {
            array[i] = element;
        }
        return array;
    }

    private static function distribute(start:Number, end:Number, length:uint):Array
    {
        var array:Array = new Array(length);
        var step:Number = (end - start) / (length - 1);

        array[0] = start;
        array[length - 1] = end;

        for (var i:int = length - 2; i >= 1; i--)
        {
            array[i] = start + step * i;
        }
        return array;
    }
}
}
