package org.yellcorp.lib.geom
{
import flash.geom.Matrix;
import flash.geom.Rectangle;


/**
 * Utility functions for scaling one rectangle up or down until one of its
 * axes match the target rectangle.  Which axis matches depends on whether
 * the mode is <code>MODE_FIT</code> or <code>MODE_FILL</code>.
 */
public class FitUtil
{
    /**
     * Calculations should scale the source rectangle until both
     * its height and width fit entirely within the target rectangle.
     * May introduce letter- or pillar-boxing.
     */
    public static const MODE_FIT:String = "fit";

    /**
     * Calculations should scale the source rectangle either its
     * height or width match the target rectangle.  Horizontal or
     * vertical edges may be cropped.
     */
    public static const MODE_FILL:String = "fill";

    /**
     * Modifies one rectangle to fit or fill another rectangle.
     *
     * @param source   The source rectangle. The aspect ratio is preserved,
     *                 and <code>x</code>, <code>y</code>, <code>width</code>
     *                 and <code>height</code> are modified.  To keep
     *                 a copy of the source rectangle, the caller should
     *                 clone it themselves.
     * @param target   The rectangle to fit <code>source</code> into.
     * @param mode     Calculation mode: <code>MODE_FIT</code> or
     *                 <code>MODE_FILL</code>
     * @param xAlign   X alignment. A number from 0 to 1.
     *                 0 = align left edges
     *                 1 = align right edges
     *                 0.5 = centre horizontally
     *                 Other values interpolate between these values.
     * @param yAlign   Y alignment. A number from 0 to 1.
     *                 0 = align top edges
     *                 1 = align bottom edges
     *                 0.5 = centre vertically
     *                 Other values interpolate between these values.
     * @param rounding Round the new values of <code>source</code>
     *                 <code>x</code>, <code>y</code>, <code>width</code>
     *                 and <code>height</code> to the nearest whole number.
     * @return         Nothing. The <code>Rectangle</code> passed into the
     *                 source argument is modified.
     */
    public static function fitRect(source:Rectangle, target:Rectangle,
                                   mode:String = "fit",
                                   xAlign:Number = 0.5,
                                   yAlign:Number = 0.5,
                                   rounding:Boolean = false):void
    {
        var scale:Number;

        if (mode == MODE_FILL)
        {
            scale = Math.max(target.width / source.width,
                             target.height / source.height);
        }
        else
        {
            scale = Math.min(target.width / source.width,
                             target.height / source.height);
        }

        if (rounding)
        {
            source.width =  int(.5 + source.width * scale);
            source.height = int(.5 + source.height * scale);
        }
        else
        {
            source.height *= scale;
            source.width *= scale;
        }
        alignRects(source, target, xAlign, yAlign);
        if (rounding)
        {
            source.x = int(.5 + source.x);
            source.y = int(.5 + source.y);
        }
    }

    /**
     * Aligns one rectangle's edges relative to another rectangle's.
     *
     * @param source   The source rectangle. Its <code>x</code> and
     *                 <code>y</code> properties are modified.
     *                 To keep a copy of the source rectangle,
     *                 the caller should clone it themselves.
     * @param target   The rectangle to align <code>source</code> to.
     * @param xAlign   X alignment. A number from 0 to 1.
     *                 0 = align left edges
     *                 1 = align right edges
     *                 0.5 = centre horizontally
     *                 Other values interpolate between these values.
     * @param yAlign   Y alignment. A number from 0 to 1.
     *                 0 = align top edges
     *                 1 = align bottom edges
     *                 0.5 = centre vertically
     *                 Other values interpolate between these values.
     * @return         Nothing. The <code>Rectangle</code> passed into the
     *                 <code>source</code> argument is modified.
     */
    public static function alignRects(source:Rectangle, target:Rectangle, xAlign:Number, yAlign:Number):void
    {
        source.x = target.x + xAlign * (target.width - source.width);
        source.y = target.y + yAlign * (target.height - source.height);
    }

    /**
     * Returns the matrix required to transform one rectange to another.
     *
     * @param source    The source rectangle.  The returned matrix, when
     *                  applied to this rectangle, will produce a rectangle
     *                  equal to the target rectangle.
     * @param target    The target rectangle.
     * @param outMatrix An existing <code>Matrix</code> to store the result
     *                  in. If none provided, will create a new
     *                  <code>Matrix</code> object.
     * @return The result stored in <code>outMatrix</code> if it exists, or
     *         a new <code>Matrix</code> object otherwise.
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
