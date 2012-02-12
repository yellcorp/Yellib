package org.yellcorp.lib.geom
{
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * Utility functions for manipulating rectangle-like objects, being any object
 * that has numeric x, y, width and height properties.  DisplayObjects can be
 * used, with the assumption that their registration points are in the top-left
 * corner, and their width and height values are reliable.
 */
public class RectUtil
{
    /**
     * Multiplies each coordinate in a rectangle by a scalar value.
     *
     * @param rect    The rectangle-like object to scale.
     * @param factor  The number to multiply by.
     * @param out     An optional instance to store the result in.  If not
     *                provided, a new Rectangle is created.
     *
     * @return  The object containing the multiplied rectangle.
     */
    public static function multiply(
        rect:Object, factor:Number, out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        out.x = rect.x * factor;
        out.y = rect.y * factor;
        out.width = rect.width * factor;
        out.height = rect.height * factor;
        return out;
    }


    /**
     * Applies a non-skew linear transformation to each coordinate in a
     * rectangle.  This is equivalent to transforming a rectangle by a Matrix,
     * with the restriction that its <code>b</code> and <code>c</code>
     * properties are fixed at zero.
     *
     * @param rect     The rectangle-like object to transform.
     * @param xFactor  The number to multiply the x and width by.  This is
     *                 equivalent to a Matrix's <code>a</code> property.
     * @param yFactor  The number to multiply the y and height by.  This is
     *                 equivalent to a Matrix's <code>d</code> property.
     * @param xOffset  The number to add to the resultant x.  This is
     *                 equivalent to a Matrix's <code>tx</code> property.
     * @param yOffset  The number to add to the resultant y.  This is
     *                 equivalent to a Matrix's <code>ty</code> property.
     * @param out      An optional instance to store the result in.  If not
     *                 provided, a new Rectangle is created.
     *
     * @return  The object containing the transformed rectangle.
     */
    public static function transform(
        rect:Object,
        xFactor:Number, yFactor:Number,
        xOffset:Number, yOffset:Number,
        out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        out.x = rect.x * xFactor + xOffset;
        out.y = rect.y * yFactor + yOffset;
        out.width = rect.width * xFactor;
        out.height = rect.height * yFactor;
        return out;
    }


    /**
     * Scales a source rectangle to fit or fill a target rectangle, maintaining
     * the source rectangle's aspect ratio.
     *
     * @param source   The source rectangle.
     * @param target   The rectangle to fit <code>source</code> into.
     * @param mode     Calculation mode: <code>INSIDE</code> calculating a
     *                 result that fits entirely within the target rectangle,
     *                 <code>OUTSIDE</code> calculating a result that covers
     *                 the entirety of the target rectangle.
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
     * @param out      An optional instance to store the result in.  If not
     *                 provided, a new Rectangle is created.
     *
     * @return  The object containing the result of fitting <code>source</code>
     *          to <code>target</code>.
     */
    public static function fit(source:Object, target:Object,
                                   fitMode:String,
                                   xAlign:Number = 0.5,
                                   yAlign:Number = 0.5,
                                   rounding:Boolean = false,
                                   out:Object = null):Object
    {
        // copy values to guard against aliasing
        var sw:Number = source.width, sh:Number = source.height;
        var tw:Number = target.width, th:Number = target.height;

        var scale:Number;

        if (!out) out = new Rectangle();

        if (fitMode == FitMode.OUTSIDE)
        {
            scale = Math.max(tw / sw, th / sh);
        }
        else
        {
            scale = Math.min(tw / sw, th / sh);
        }

        if (rounding)
        {
            out.width =  int(.5 + sw * scale);
            out.height = int(.5 + sh * scale);
        }
        else
        {
            out.width = sw * scale;
            out.height = sh * scale;
        }
        align(out, xAlign, yAlign, target, xAlign, yAlign, out);
        if (rounding)
        {
            out.x = int(.5 + out.x);
            out.y = int(.5 + out.y);
        }
        return out;
    }


    /**
     * Aligns one rectangle-like object to another so that a specified
     * normalised point in each coincide.
     *
     * @example
     * A rectangle-like object is one that has numeric x, y, width and height
     * properties.  A normalised point in a rectangle is one on a scale from
     * (0, 0) representing the top-left corner, to (1, 1) representing the
     * bottom-right.
     *
     * This aligns the object nextButton's left edge to the prevButton's
     * right, and centres them vertically, and places the new x, y coordinates
     * in nextButton, moving it.
     * <listing version="3.0">
     * FitUtil.align(nextButton, 0, 0.5, prevButton, 1, 0.5, nextButton);
     * </listing>
     *
     * This returns a copy of canvas's scrollRect property, aligned to the
     * bottom-right corner of canvasBounds.  Because no out variable is passed,
     * a new Rectangle is created and returned.
     * <listing version="3.0">
     * FitUtil.align(canvas.scrollRect, 1, 1, canvasBounds, 1, 1);
     * </listing>
     *
     * @param source       The rectangle-like object to place.
     * @param sourceNormX  The normalized X coordinate of the source reference
     *                     point.
     * @param sourceNormY  The normalized Y coordinate of the source reference
     *                     point.
     * @param target       The rectangle-like object to use as reference.
     * @param targetNormX  The normalized X coordinate of the source reference
     *                     point.
     * @param targetNormY  The normalized Y coordinate of the source reference
     *                     point.
     * @param out          An object in which to place source's width and
     *                     height, along with the calculated x and y.  If not
     *                     specified, a new Rectangle will be created and
     *                     returned.
     *
     * @return  The object containing the repositioned <code>source</code>
     *          rectangle.
     */
    public static function align(
        source:Object, sourceNormX:Number, sourceNormY:Number,
        target:Object, targetNormX:Number, targetNormY:Number,
        out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        out.x = target.x + targetNormX * target.width - sourceNormX * source.width;
        out.y = target.y + targetNormY * target.height - sourceNormY * source.height;
        out.width = source.width;
        out.height = source.height;
        return out;
    }


    /**
     * Returns the matrix required to transform one rectange to another.
     *
     * @param source    The source rectangle.  The returned matrix, when
     *                  applied to this rectangle, will produce a rectangle
     *                  equal to the target rectangle.
     * @param target    The target rectangle.
     * @param out       A Matrix instance in which to store the
     *                  result. If not specified, a new Matrix will be
     *                  created and returned.
     *
     * @return  The object containing the calculated Matrix.
     */
    public static function getTransform(
        source:Object, target:Object,
        out:Matrix = null):Matrix
    {
        if (source.width == 0 || source.height == 0) return null;
        if (!out) out = new Matrix();

        out.tx = target.left - source.left;
        out.ty = target.top - source.top;
        out.a = target.width / source.width;
        out.b =
        out.c = 0;
        out.d = target.height / source.height;

        return out;
    }


    /**
     * Rounds each coordinate of a rectangle to the next integer away from its
     * center.  The result is the smallest rectangle with integral coordinates
     * that can entirely contain the input rectangle.
     *
     * @param rect    The rectangle-like object to round.
     * @param out     An optional instance to store the result in.  If not
     *                provided, a new Rectangle is created.
     *
     * @return  The object containing the rectangle with integral coordinates.
     */
    public static function roundOut(
        rect:Object, out:Object = null):Object
    {
        if (!out) out = new Rectangle();

        var r:Number = rect.x + rect.width;
        var b:Number = rect.y + rect.height;

        out.x = Math.floor(rect.x);
        out.y = Math.floor(rect.y);
        out.width = Math.ceil(r) - out.x;
        out.height = Math.ceil(b) - out.y;
        return out;
    }


    /**
     * Rounds each coordinate of a rectangle to the next integer toward its
     * center.  The result is the largest rectangle with integral coordinates
     * that can fit entirely within the input rectangle.
     *
     * @param rect    The rectangle-like object to round.
     * @param out     An optional instance to store the result in.  If not
     *                provided, a new Rectangle is created.
     *
     * @return  The object containing the rectangle with integral coordinates.
     */
    public static function roundIn(
        rect:Object, out:Object = null):Object
    {
        if (!out) out = new Rectangle();

        var r:Number = rect.x + rect.width;
        var b:Number = rect.y + rect.height;

        out.x = Math.ceil(rect.x);
        out.y = Math.ceil(rect.y);
        out.width = Math.floor(r) - out.x;
        out.height = Math.floor(b) - out.y;
        return out;
    }


    /**
     * Maps a point from one rectangle space to another.
     *
     * @param point   The input point.
     * @param source  The source rectangle space.
     * @param target  The target rectangle space.
     * @param out     An optional instance to store the result in.  If not
     *                provided, a new Point is created.
     *
     * @return  The object containing the mapped point.
     */
    public static function mapPoint(point:Object,
        source:Object, target:Object, out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        out.x = target.x + target.width * (point.x - source.x) / source.width;
        out.y = target.y + target.height * (point.y - source.y) / source.height;
        return out;
    }


    /**
     * Maps a rectangle from one rectangle space to another.
     *
     * @param rect    The input rectangle.
     * @param source  The source rectangle space.
     * @param target  The target rectangle space.
     * @param out     An optional instance to store the result in.  If not
     *                provided, a new Rectangle is created.
     *
     * @return  The object containing the mapped rectangle.
     */
    public static function mapRect(
        rect:Object, source:Object, target:Object, out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        out.x = target.x + target.width * (rect.x - source.x) / source.width;
        out.y = target.y + target.height * (rect.y - source.y) / source.height;
        out.width = target.width * (rect.x + rect.width - source.x) / source.width;
        out.height = target.height * (rect.y + rect.height - source.y) / source.height;
        return out;
    }


    /**
     * Restricts the range of a point's x and y coordinates so the point falls
     * with a given rectangle.
     *
     * @param point  The point to limit.
     * @param rect   The rectangular limit.
     * @param out    An optional instance to store the result in.  If not
     *               provided, a new Point is created.
     *
     * @return  The object containing the clamped point.
     */
    public static function clampPoint(
        point:Object, rect:Object, out:Object = null):Object
    {
        if (!out) out = new Point();

        if (point.x < rect.x)  {  out.x = rect.x;  }
        else if (point.x > rect.x + rect.width)  {  out.x = rect.x + rect.width;  }
        else  {  out.x = point.x;  }

        if (point.y < rect.top)  {  out.y = rect.top;  }
        else if (point.y > rect.y + rect.height)  {  out.y = rect.y + rect.height;  }
        else  {  out.y = point.y;  }

        return out;
    }


    /**
     * Returns a point in a rectangle, given an x and y coordinate in the range
     * (0, 0) representing the rectangle's top-left corner, to (1, 1)
     * representing the bottom-right.
     *
     * @param rect   The input rectangle.
     * @param xParam The X parameter, with 0 representing the rectangle's left,
     *               1 the right.
     * @param yParam The Y parameter, with 0 representing the rectangle's top,
     *               1 the bottom.
     * @param out    An optional instance to store the result in.  If not
     *               provided, a new Point is created.
     *
     * @return  The object containing the point.
     */
    public static function getNormalizedPoint(
        rect:Object, xParam:Number, yParam:Number, out:Object = null):Object
    {
        if (!out) out = new Point();
        out.x = rect.x + xParam * rect.width;
        out.y = rect.y + yParam * rect.height;
        return out;
    }


    /**
     * Scales a rectangle to have a specified area, maintaining its aspect
     * ratio.
     *
     * @param rect  The rectangle to scale.
     * @param area  The desired area.
     * @param out   An optional instance to store the result in.  If not
     *              provided, a new Rectangle is created.
     *
     * @return  The object containing the rectangle with the desired area.
     */
    public static function scaleToArea(
        rect:Object, area:Number, out:Object = null):Object
    {
        if (!out) out = new Rectangle();
        var areaRatio:Number = Math.sqrt(area / (rect.width * rect.height));
        out.x = rect.x;
        out.y = rect.y;
        out.width = rect.width * areaRatio;
        out.height = rect.height * areaRatio;
        return out;
    }
}
}
