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
     * @param rect
     * The rectangle-like object to scale.
     *
     * @param factor
     * The factor to scale by.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the scaled rectangle.
     */
    public static function multiply(
        rect:*, factor:Number, outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();
        outRect.x = rect.x * factor;
        outRect.y = rect.y * factor;
        outRect.width = rect.width * factor;
        outRect.height = rect.height * factor;
        return outRect;
    }


    /**
     * Applies a non-skew linear transformation to each coordinate in a
     * rectangle.  This is equivalent to transforming a rectangle by a Matrix,
     * with the restriction that its <code>b</code> and <code>c</code>
     * properties are fixed at zero.
     *
     * @param rect
     * The rectangle-like object to transform.
     *
     * @param xFactor
     * The number to multiply the x and width by.  This is equivalent to a
     * Matrix's <code>a</code> property.
     *
     * @param yFactor
     * The number to multiply the y and height by.  This is equivalent to a
     * Matrix's <code>d</code> property.
     *
     * @param xOffset
     * The number to add to the resultant x.  This is equivalent to a Matrix's
     * <code>tx</code> property.
     *
     * @param yOffset
     * The number to add to the resultant y.  This is equivalent to a Matrix's
     * <code>ty</code> property.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the transformed rectangle.
     */
    public static function transform(
        rect:*,
        xFactor:Number, yFactor:Number,
        xOffset:Number, yOffset:Number,
        outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();
        outRect.x = rect.x * xFactor + xOffset;
        outRect.y = rect.y * yFactor + yOffset;
        outRect.width = rect.width * xFactor;
        outRect.height = rect.height * yFactor;
        return outRect;
    }


    /**
     * Scales a source rectangle to fit or fill a target rectangle, maintaining
     * the source rectangle's aspect ratio.
     *
     * @param sourceRect
     * The source rectangle.
     *
     * @param targetRect
     * The rectangle to fit <code>sourceRect</code> into.
     *
     * @param mode
     * Fit mode. <code>FitMode.INSIDE</code> returns a rectangle that
     * fits entirely within the target rectangle, <code>FitMode.OUTSIDE</code>
     * returns a rectangle that covers the entirety of the target rectangle.
     *
     * @param xAlign
     * X alignment. A number from 0 to 1. 0 aligns left edges, 1 aligns right
     * edges, and 0.5 centres horizontally. Other values interpolate between
     * these values.
     *
     * @param yAlign
     * Y alignment. A number from 0 to 1. 0 aligns top edges, 1 aligns bottom
     * edges, and 0.5 centres vertically. Other values interpolate between
     * these values.
     *
     * @param rounding
     * Rounds the calculated values of <code>x</code>, <code>y</code>,
     * <code>width</code> and <code>height</code> to the nearest whole number.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the result of fitting <code>sourceRect</code> to
     * <code>targetRect</code>.
     */
    public static function fit(
        sourceRect:*, targetRect:*,
        fitMode:String,
        xAlign:Number = 0.5, yAlign:Number = 0.5,
        rounding:Boolean = false,
        outRect:* = null):*
    {
        // copy values to guard against aliasing
        var sw:Number = sourceRect.width, sh:Number = sourceRect.height;
        var tw:Number = targetRect.width, th:Number = targetRect.height;

        var scale:Number;

        if (!outRect) outRect = new Rectangle();

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
            outRect.width =  int(.5 + sw * scale);
            outRect.height = int(.5 + sh * scale);
        }
        else
        {
            outRect.width = sw * scale;
            outRect.height = sh * scale;
        }
        align(outRect, xAlign, yAlign, targetRect, xAlign, yAlign, outRect);
        if (rounding)
        {
            outRect.x = int(.5 + outRect.x);
            outRect.y = int(.5 + outRect.y);
        }
        return outRect;
    }


    /**
     * Aligns one rectangle-like object to another so that a specified
     * normalised point in each coincide.  A normalised point in a rectangle is
     * one on a scale from (0, 0) representing the top-left corner, to (1, 1)
     * representing the bottom-right.
     *
     * @example
     * This calculates the x and y coordinates necessary to align nextButton's
     * left edge to the prevButton's right, and centre them vertically. Because
     * nextButton is also specified as the outRect parameter, the result is
     * placed in its x and y properties, effectively moving it to its new
     * position.
     * <listing version="3.0">
     * FitUtil.align(nextButton, 0, 0.5, prevButton, 1, 0.5, nextButton);
     * </listing>
     *
     * This returns a copy of canvas's scrollRect property, aligned to the
     * bottom-right corner of canvasBounds.  Because no outRect variable is
     * passed, a new Rectangle is created and returned.
     * <listing version="3.0">
     * var bottomRight:Rectangle = FitUtil.align(canvas.scrollRect, 1, 1, canvasBounds, 1, 1);
     * </listing>
     *
     * This does the same, but places the result into a new dynamic Object.
     * <listing version="3.0">
     * var bottomRight:Object = FitUtil.align(canvas.scrollRect, 1, 1, canvasBounds, 1, 1, { });
     * </listing>
     *
     * @param sourceRect
     * The rectangle-like object to place.
     *
     * @param sourceNormX
     * The normalized X coordinate of the source reference point.
     *
     * @param sourceNormY
     * The normalized Y coordinate of the source reference point.
     *
     * @param targetRect
     * The rectangle-like object to use as reference.
     *
     * @param targetNormX
     * The normalized X coordinate of the source reference point.
     *
     * @param targetNormY
     * The normalized Y coordinate of the source reference point.
     *
     * @param outRect
     * An object in which to place source's width and height, along with the
     * calculated x and y.  If not specified, a new Rectangle will be created
     * and returned.
     *
     * @return
     * The object containing the repositioned <code>sourceRect</code> rectangle.
     */
    public static function align(
        sourceRect:*, sourceNormX:Number, sourceNormY:Number,
        targetRect:*, targetNormX:Number, targetNormY:Number,
        outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();
        outRect.x = targetRect.x + targetNormX * targetRect.width - sourceNormX * sourceRect.width;
        outRect.y = targetRect.y + targetNormY * targetRect.height - sourceNormY * sourceRect.height;
        outRect.width = sourceRect.width;
        outRect.height = sourceRect.height;
        return outRect;
    }


    /**
     * Returns the matrix required to transform one rectange to another.
     *
     * @param sourceRect
     * The source rectangle.  The returned matrix, when applied to this
     * rectangle, will produce a rectangle equal to the target rectangle.
     *
     * @param target
     * The target rectangle.
     *
     * @param out
     * A Matrix instance in which to store the result. If not specified, a new
     * Matrix will be created and returned.
     *
     * @return
     * The object containing the calculated Matrix.
     */
    public static function getTransform(
        sourceRect:*, targetRect:*, outMatrix:Matrix = null):Matrix
    {
        if (sourceRect.width == 0 || sourceRect.height == 0) return null;
        if (!outMatrix) outMatrix = new Matrix();

        outMatrix.tx = targetRect.x - sourceRect.x;
        outMatrix.ty = targetRect.y - sourceRect.y;
        outMatrix.a = targetRect.width / sourceRect.width;
        outMatrix.b =
        outMatrix.c = 0;
        outMatrix.d = targetRect.height / sourceRect.height;

        return outMatrix;
    }


    /**
     * Rounds each coordinate of a rectangle to the next integer away from its
     * center.  The result is the smallest rectangle with integral coordinates
     * that can entirely contain the input rectangle.
     *
     * @param rect
     * The rectangle-like object to round.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the rectangle with integral coordinates.
     */
    public static function roundOut(
        rect:*, outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();

        var r:Number = rect.x + rect.width;
        var b:Number = rect.y + rect.height;

        outRect.x = Math.floor(rect.x);
        outRect.y = Math.floor(rect.y);
        outRect.width = Math.ceil(r) - outRect.x;
        outRect.height = Math.ceil(b) - outRect.y;
        return outRect;
    }


    /**
     * Rounds each coordinate of a rectangle to the next integer toward its
     * center.  The result is the largest rectangle with integral coordinates
     * that can fit entirely within the input rectangle.
     *
     * @param rect
     * The rectangle-like object to round.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the rectangle with integral coordinates.
     */
    public static function roundIn(
        rect:*, outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();

        var r:Number = rect.x + rect.width;
        var b:Number = rect.y + rect.height;

        outRect.x = Math.ceil(rect.x);
        outRect.y = Math.ceil(rect.y);
        outRect.width = Math.floor(r) - outRect.x;
        outRect.height = Math.floor(b) - outRect.y;
        return outRect;
    }


    /**
     * Maps a point from one rectangle space to another.
     *
     * @param point
     * The input point.
     *
     * @param sourceRect
     * The source rectangle space.
     *
     * @param targetRect
     * The target rectangle space.
     *
     * @param outPoint
     * An optional instance to store the result in.  If not provided, a new
     * Point is created.
     *
     * @return
     * The object containing the mapped point.
     */
    public static function mapPoint(
        point:*, sourceRect:*, targetRect:*, outPoint:* = null):*
    {
        if (!outPoint) outPoint = new Rectangle();
        outPoint.x = targetRect.x + targetRect.width * (point.x - sourceRect.x) / sourceRect.width;
        outPoint.y = targetRect.y + targetRect.height * (point.y - sourceRect.y) / sourceRect.height;
        return outPoint;
    }


    /**
     * Maps a rectangle from one rectangle space to another.
     *
     * @param rect
     * The input rectangle.
     *
     * @param sourceRect
     * The source rectangle space.
     *
     * @param targetRect
     * The target rectangle space.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return  The object containing the mapped rectangle.
     */
    public static function mapRect(
        rect:*, sourceRect:*, targetRect:*, outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();
        outRect.x = targetRect.x + targetRect.width * (rect.x - sourceRect.x) / sourceRect.width;
        outRect.y = targetRect.y + targetRect.height * (rect.y - sourceRect.y) / sourceRect.height;
        outRect.width = targetRect.width * (rect.x + rect.width - sourceRect.x) / sourceRect.width;
        outRect.height = targetRect.height * (rect.y + rect.height - sourceRect.y) / sourceRect.height;
        return outRect;
    }


    /**
     * Returns a point that is repositioned, if necessary, so that its location
     * is contained within a rectangle.
     *
     * @param point
     * The point to limit.
     *
     * @param rect
     * The rectangular limit.
     *
     * @param outPoint
     * An optional instance to store the result in.  If not provided, a new
     * Point is created.
     *
     * @return
     * The object containing the clamped point.
     */
    public static function clampPoint(
        point:*, rect:*, outPoint:* = null):*
    {
        if (!outPoint) outPoint = new Point();

        if (point.x < rect.x)  {  outPoint.x = rect.x;  }
        else if (point.x > rect.x + rect.width)  {  outPoint.x = rect.x + rect.width;  }
        else  {  outPoint.x = point.x;  }

        if (point.y < rect.y)  {  outPoint.y = rect.y;  }
        else if (point.y > rect.y + rect.height)  {  outPoint.y = rect.y + rect.height;  }
        else  {  outPoint.y = point.y;  }

        return outPoint;
    }


    /**
     * Returns a point in a rectangle, given an x and y coordinate in the range
     * (0, 0) representing the rectangle's top-left corner, to (1, 1)
     * representing the bottom-right.
     *
     * @param rect
     * The input rectangle.
     *
     * @param xParam
     * The X parameter, with 0 representing the rectangle's left, 1 the right.
     *
     * @param yParam
     * The Y parameter, with 0 representing the rectangle's top, 1 the bottom.
     *
     * @param outPoint
     * An optional instance to store the result in.  If not provided, a new
     * Point is created.
     *
     * @return
     * The object containing the point.
     */
    public static function getNormalizedPoint(
        rect:*, xParam:Number, yParam:Number, outPoint:* = null):*
    {
        if (!outPoint) outPoint = new Point();
        outPoint.x = rect.x + xParam * rect.width;
        outPoint.y = rect.y + yParam * rect.height;
        return outPoint;
    }


    /**
     * Scales a rectangle to have a specified area, maintaining its aspect
     * ratio.
     *
     * @param rect
     * The rectangle to scale.
     *
     * @param area
     * The desired area.
     *
     * @param outRect
     * An optional instance to store the result in.  If not provided, a new
     * Rectangle is created.
     *
     * @return
     * The object containing the rectangle with the desired area.
     */
    public static function scaleToArea(
        rect:*, area:Number, outRect:* = null):*
    {
        if (!outRect) outRect = new Rectangle();
        var areaRatio:Number = Math.sqrt(area / (rect.width * rect.height));
        outRect.x = rect.x;
        outRect.y = rect.y;
        outRect.width = rect.width * areaRatio;
        outRect.height = rect.height * areaRatio;
        return outRect;
    }
}
}
