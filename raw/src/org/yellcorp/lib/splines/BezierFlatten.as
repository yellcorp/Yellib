package org.yellcorp.lib.splines
{
import org.yellcorp.lib.splines.streams.SplineStream;


public class BezierFlatten
{
    public static function flattenQuad(spline:QuadBezier, threshold:Number, out:SplineStream):void
    {
        var root:TreeNode = new TreeNode();
        root.content = spline;
        out.moveTo(spline.p0.x, spline.p0.y);
        flattenQuadRecurse(root, threshold * threshold, out);
    }

    private static function flattenQuadRecurse(node:TreeNode, sqThreshold:Number, out:SplineStream):void
    {
        var spline:QuadBezier = node.content;
        if (spline.flatnessSquared > sqThreshold)
        {
            node.left = new TreeNode();
            node.left.content = QuadBezier.create();
            node.right = new TreeNode();
            node.right.content = QuadBezier.create();
            spline.split(0.5, node.left.content, node.right.content);
            flattenQuadRecurse(node.left, sqThreshold, out);
            flattenQuadRecurse(node.right, sqThreshold, out);
        }
        else
        {
            out.lineTo(spline.p2.x, spline.p2.y);
        }
    }

    public static function cubicToPolyQuad(spline:CubicBezier, threshold:Number, out:SplineStream):void
    {
        var root:TreeNode = new TreeNode();
        root.content = spline;
        out.moveTo(spline.p0.x, spline.p0.y);
        cubicToPolyQuadRecurse(root, threshold * threshold, out);
    }

    private static function cubicToPolyQuadRecurse(node:TreeNode, sqThreshold:Number, out:SplineStream):void
    {
        var spline:CubicBezier = node.content;
        var qx:Number, qy:Number;

        if (cubicToQuadSquareError(spline) > sqThreshold)
        {
            node.left = new TreeNode();
            node.left.content = CubicBezier.create();
            node.right = new TreeNode();
            node.right.content = CubicBezier.create();
            spline.split(0.5, node.left.content, node.right.content);
            cubicToPolyQuadRecurse(node.left, sqThreshold, out);
            cubicToPolyQuadRecurse(node.right, sqThreshold, out);
        }
        else
        {
            qx = averageQuadScaledInfluencePoints(spline.p0.x, spline.p1.x, spline.p2.x, spline.p3.x);
            qy = averageQuadScaledInfluencePoints(spline.p0.y, spline.p1.y, spline.p2.y, spline.p3.y);
            out.curveTo(qx, qy, spline.p3.x, spline.p3.y);
        }
    }

    /**
     * Calculates a quadratic approximation of a cubic bezier.  This is done
     * by calculating the average of two quadratic beziers: One with the cubic
     * coefficient set to 0, and its reverse, also with the cubic coefficient
     * set to 0.
     *
     * An alternate way of visualizing it is to create a quadratic by copying
     * the anchor points, and scaling the distance between each cubic influence
     * point and its adjacent anchor point by 1.5, then setting the quadratic
     * influence point to the average of the scaled influence points.
     *
     * A cubic bezier whose influence points coincide after scaling by 1.5
     * effectively has no cubic coefficient and can be expressed as a quadratic.
     *
     * This corresponds to the 'mid-point approximation' mentioned here:
     * http://www.caffeineowl.com/graphics/2d/vectorial/cubic2quad01.html
     */
    public static function cubicToApproxQuad(cubic:CubicBezier, out:QuadBezier):QuadBezier
    {
        out.p0.x = cubic.p0.x;
        out.p0.y = cubic.p0.y;

        out.p2.x = cubic.p3.x;
        out.p2.y = cubic.p3.y;

        out.p1.x = averageQuadScaledInfluencePoints(cubic.p0.x, cubic.p1.x, cubic.p2.x, cubic.p3.x);
        out.p1.y = averageQuadScaledInfluencePoints(cubic.p0.y, cubic.p1.y, cubic.p2.y, cubic.p3.y);

        return out;
    }

    /**
     * Calculates the maximum error between a cubic and its quadratic
     * approximation.  The number returned is the maximum square distance
     * between corresponding points on the cubic and its quad. approx.
     *
     * Mathematically, the process is:
     * Assume a cubic bezier C(t) = CubicBezier(Ca, Cb, Cc, Cd, t)
     *
     * Define its 'mid-point approximation' quadratic bezier.
     * Q(C)(t) = QuadraticBezier(Ca, -Ca + 3Cb + 3Cc - Cd, Cd, t)
     *
     * Define an error function as the difference between C and Q(C)
     * E(C)(t) = Q(C)(t) - C(t)
     *
     * Which is:
     * (1 / 2) * (Ca - 3Cb + 3Cc - Cd) * (t - 3t^2 + 2t^3)
     *
     * Find the extrema for t by solving d/dt E(C)(t) where t = 0
     * Which are at t = { (3 - sqrt(3)) / 6 , (3 + sqrt(3)) / 6 }
     * These values for t are constant, so the code begins at this point.
     *
     * Evaluate E(C)(t) for each solution.  This will result in a pair of
     * 2-vectors.
     *
     * Return the maximum absolute value (pythagorean distance) of the pair.
     */
    public static function cubicToQuadSquareError(cubic:CubicBezier):Number
    {
        var ax:Number = cubic.p0.x;
        var bx:Number = cubic.p1.x;
        var cx:Number = cubic.p2.x;
        var dx:Number = cubic.p3.x;

        var ay:Number = cubic.p0.x;
        var by:Number = cubic.p1.x;
        var cy:Number = cubic.p2.x;
        var dy:Number = cubic.p3.x;

        // these values should really be divided by 12*sqrt(3)
        var r0x:Number = (ax + 3 * (cx - bx) - dx);
        var r0y:Number = (ay + 3 * (cy - by) - dy);

        var r1x:Number = (dy + 3 * (bx - cx) - ax);
        var r1y:Number = (dy + 3 * (by - cy) - ay);

        var sqDist0:Number = r0x * r0x + r0y * r0y;
        var sqDist1:Number = r1x * r1x + r1y * r1y;

        // but if you factor that constant out and apply it here, you can
        // just divide by (12*sqrt(3))^2, which is 432
        return (sqDist0 > sqDist1 ? sqDist0 : sqDist1) / 432.0;
    }

    private static function averageQuadScaledInfluencePoints(a:Number, b:Number, c:Number, d:Number):Number
    {
        return (3 * (b + c) - a - d) * 0.25;
    }
}
}


class TreeNode
{
    public var content:*;
    public var left:TreeNode;
    public var right:TreeNode;
}
