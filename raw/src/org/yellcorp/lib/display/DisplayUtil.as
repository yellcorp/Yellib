package org.yellcorp.lib.display
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;


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

    public static function removeFromParent(child:DisplayObject):Boolean
    {
        if (child.parent)
        {
            child.parent.removeChild(child);
            return true;
        }
        else
        {
            return false;
        }
    }

    public static function insertTransformNode(child:DisplayObject, regPointX:Number = 0, regPointY:Number = 0):Sprite
    {
        var parent:DisplayObjectContainer;
        var newNode:Sprite;
        var offsetX:int;
        var offsetY:Number;

        if (!child)
            throw new ArgumentError("child argument must not be null");

        offsetX = int(child.width * regPointX);
        offsetY = int(child.height * regPointY);

        parent = child.parent;

        newNode = new Sprite();
        newNode.x = child.x + offsetX;
        newNode.y = child.y + offsetY;

        newNode.addChild(child);
        child.x = -offsetX;
        child.y = -offsetY;

        if (parent)
            parent.addChild(newNode);

        return newNode;
    }

    public static function setChildAttached(child:DisplayObject, parent:DisplayObjectContainer, attach:Boolean):void
    {
        if (attach != (parent == child.parent))
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

    public static function getGuideRect(guide:DisplayObject, out:Rectangle = null):Rectangle
    {
        if (out)
        {
            out.x = guide.x;
            out.y = guide.y;
            out.width = guide.width;
            out.height = guide.height;
        }
        else
        {
            out = new Rectangle(guide.x, guide.y, guide.width, guide.height);
        }
        removeFromParent(guide);
        return out;
    }

    public static function getGuidePoint(guide:DisplayObject, out:Point = null):Point
    {
        if (out)
        {
            out.x = guide.x;
            out.y = guide.y;
        }
        else
        {
            out = new Point(guide.x, guide.y);
        }
        removeFromParent(guide);
        return out;
    }
}
}
