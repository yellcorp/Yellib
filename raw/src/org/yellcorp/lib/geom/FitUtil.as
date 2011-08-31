package org.yellcorp.lib.geom
{
import flash.geom.Matrix;
import flash.geom.Rectangle;


/**
 * Utility functions for scaling a source rectangular area to fit inside a
 * target area, while maintaining the aspect ratio of the source.
 * <code>INSIDE</code> calculates a rectangle that is equal to or smaller
 * than the target.  <code>OUTSIDE</code> is always equal or larger.
 */
public class FitUtil
{
    /**
     * Constant value that directs the <code>fitRect</code> function to
     * calculate a result that is always smaller or equal to the target
     * area. One of the axes of the result may not fully span the target.
     */
    public static const INSIDE:String = "fit";

    /**
     * Constant value that directs the <code>fitRect</code> function to
     * calculate a result that is always larget or equal to the target
     * area. One of the axes of the result may exceed the target area.
     */
    public static const OUTSIDE:String = "fill";

    /**
     * Scales one rectangle to fit or fill another rectangle.
     *
     * @param source   The source rectangle.
     * @param target   The rectangle to fit <code>source</code> into.
     * @param mode     Calculation mode: <code>INSIDE</code> or
     *                 <code>OUTSIDE</code>
     * @param xAlign   X alignment. A number from 0 to 1. 0 aligns left
     *                 edges, 1 aligns right edges, and 0.5 centres
     *                 horizontally. Other values interpolate between these
     *                 values.
     * @param yAlign   Y alignment. A number from 0 to 1. 0 aligns top
     *                 edges, 1 aligns bottom edges, and 0.5 centres
     *                 vertically. Other values interpolate between these
     *                 values.
     * @param rounding Rounds the calculated values of <code>x</code>,
     *                 <code>y</code>, <code>width</code> and
     *                 <code>height</code> to the nearest whole number.
     * @param output   A reference to a Rectangle in which to store the
     *                 result. If this is null, a new Rectangle will be
     *                 constructed and returned.
     * @return         The Rectangle passed into <code>output</code>, or a
     *                 new Rectangle, with the calculated result.
     */
    public static function fitRect(source:Rectangle, target:Rectangle,
                                   mode:String,
                                   xAlign:Number = 0.5,
                                   yAlign:Number = 0.5,
                                   rounding:Boolean = false,
                                   output:Rectangle = null):Rectangle
    {
        // copy values to guard against aliasing
        var sw:Number = source.width, sh:Number = source.height;
        var tw:Number = target.width, th:Number = target.height;

        var scale:Number;

        if (!output)
        {
            output = new Rectangle();
        }

        if (mode == OUTSIDE)
        {
            scale = Math.max(tw / sw, th / sh);
        }
        else
        {
            scale = Math.min(tw / sw, th / sh);
        }

        if (rounding)
        {
            output.width =  int(.5 + sw * scale);
            output.height = int(.5 + sh * scale);
        }
        else
        {
            output.width = sw * scale;
            output.height = sh * scale;
        }
        alignRects(output, target, xAlign, yAlign, output);
        if (rounding)
        {
            output.x = int(.5 + output.x);
            output.y = int(.5 + output.y);
        }
        return output;
    }

    /**
     * Aligns one rectangle's edges relative to another rectangle's.
     *
     * @param source   The source rectangle.
     * @param target   The rectangle to align <code>source</code> to.
     * @param xAlign   X alignment. A number from 0 to 1. 0 aligns left
     *                 edges, 1 aligns right edges, and 0.5 centres
     *                 horizontally. Other values interpolate between these
     *                 values.
     * @param yAlign   Y alignment. A number from 0 to 1. 0 aligns top
     *                 edges, 1 aligns bottom edges, and 0.5 centres
     *                 vertically. Other values interpolate between these
     *                 values.
     *                 Other values interpolate between these values.
     * @param output   A reference to a Rectangle in which to store the
     *                 result. If this is null, a new Rectangle will be
     *                 constructed and returned.
     * @return         The Rectangle passed into <code>output</code>, or a
     *                 new Rectangle, with the calculated result.
     */
    public static function alignRects(
        source:Rectangle, target:Rectangle,
        xAlign:Number, yAlign:Number,
        output:Rectangle = null):Rectangle
    {
        if (!output) output = new Rectangle();
        output.x = target.x + xAlign * (target.width - source.width);
        output.y = target.y + yAlign * (target.height - source.height);
        output.width = source.width;
        output.height = source.height;
        return output;
    }

    /**
     * Returns the matrix required to transform one rectange to another.
     *
     * @param source    The source rectangle.  The returned matrix, when
     *                  applied to this rectangle, will produce a rectangle
     *                  equal to the target rectangle.
     * @param target    The target rectangle.
     * @param output    A reference to a Matrix in which to store the
     *                  result. If this is null, a new Matrix will be
     *                  constructed and returned.
     * @return          The Matrix passed into <code>output</code>, or a
     *                  new Matrix, with the calculated result. If source
     *                  has a width or height of zero, returns
     *                  <code>null</code>.
     */
    public static function getRectTransform(source:Rectangle, target:Rectangle, outMatrix:Matrix = null):Matrix
    {
        if (source.width == 0 || source.height == 0) return null;
        if (!outMatrix) outMatrix = new Matrix();

        outMatrix.tx = target.left - source.left;
        outMatrix.ty = target.top - source.top;
        outMatrix.a = target.width / source.width;
        outMatrix.b =
        outMatrix.c = 0;
        outMatrix.d = target.height / source.height;

        return outMatrix;
    }
}
}
