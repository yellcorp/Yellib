package org.yellcorp.lib.splines
{
import org.yellcorp.lib.splines.streams.CurveStream;


public class BezierFlatten
{
    public static function flattenQuad(spline:QuadBezier, threshold:Number, out:CurveStream):void
    {
        var root:TreeNode = new TreeNode();
        root.content = spline;
        out.moveTo(spline.p0.x, spline.p0.y);
        flattenQuadRecurse(root, threshold * threshold, out);
    }

    private static function flattenQuadRecurse(node:TreeNode, threshold:Number, out:CurveStream):void
    {
        var spline:QuadBezier = node.content;
        if (spline.flatnessSquared > threshold)
        {
            node.left = new TreeNode();
            node.left.content = QuadBezier.create();
            node.right = new TreeNode();
            node.right.content = QuadBezier.create();
            spline.split(0.5, node.left.content, node.right.content);
            flattenQuadRecurse(node.left, threshold, out);
            flattenQuadRecurse(node.right, threshold, out);
        }
        else
        {
            out.lineTo(spline.p2.x, spline.p2.y);
        }
    }
}
}


class TreeNode
{
    public var content:*;
    public var left:TreeNode;
    public var right:TreeNode;
}
