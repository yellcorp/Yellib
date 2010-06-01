package org.yellcorp.display
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;


public class DisplayUtil
{
    /**
     * Convenience method for getting a DisplayObject's location as a Point.
     *
     * @param dobj The DisplayObject to query.
     * @param out An optional Point variable to store the result in. This can
     *            be used to avoid calling the Point constructor.
     */
    public static function getDisplayObjectPoint(dobj:DisplayObject, out:Point = null):Point
    {
        if (!out)
        {
            out = new Point(dobj.x, dobj.y);
        }
        else
        {
            out.x = dobj.x;
            out.y = dobj.y;
        }
        return out;
    }

    public static function convertPoint(pointInFromSpace:Point, fromSpace:DisplayObject, toSpace:DisplayObject):Point
    {
        if (fromSpace === toSpace) return pointInFromSpace.clone();
        var global:Point = fromSpace.localToGlobal(pointInFromSpace);
        return toSpace.globalToLocal(global);
    }

    public static function replaceDisplay(guide:DisplayObject, real:DisplayObject):DisplayObject
    {
        var container:DisplayObjectContainer = guide.parent;
        real.x = guide.x;
        real.y = guide.y;
        real.width = guide.width;
        real.height = guide.height;
        container.addChildAt(real, container.getChildIndex(guide));
        container.removeChild(guide);
        return real;
    }

    public static function getAllChildren(container:DisplayObjectContainer):Array
    {
        var children:Array = [ ];
        for (var i:int = 0; i < container.numChildren; i++)
        {
            children.push(container.getChildAt(i));
        }
        return children;
    }

    public static function removeAllChildren(container:DisplayObjectContainer):void
    {
        while (container.numChildren > 0)
            container.removeChildAt(0);
    }

    public static function insertTransformNode(child:DisplayObject):Sprite
    {
        var parent:DisplayObjectContainer;
        var newNode:Sprite;

        if (!child)
            throw new ArgumentError("child argument must not be null");

        parent = child.parent;

        newNode = new Sprite();
        newNode.addChild(child);
        newNode.transform.matrix = child.transform.matrix.clone();
        child.transform.matrix = new Matrix();

        if (parent)
            parent.addChild(newNode);

        return newNode;
    }

    public static function setChildAttached(child:DisplayObject, parent:DisplayObjectContainer, attach:Boolean):void
    {
        if (attach != parent.contains(child))
        {
            if (attach)
            {
                parent.addChild(child);
            }
            else
            {
                parent.removeChild(child);
            }
        }
    }

    public static function setAutoAlpha(display:DisplayObject, alpha:Number):void
    {
        display.alpha = alpha;
        display.visible = alpha > 0;
    }
}
}
