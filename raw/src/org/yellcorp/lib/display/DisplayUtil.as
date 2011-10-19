package org.yellcorp.lib.display
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * A collection of functions to query and manipulate DisplayObjects and
 * their display list relationships.  A number of these functions perform
 * common tasks involved in adapting library symbols for interactivity and
 * procedural animation.
 */
public class DisplayUtil
{
    /**
     * Convenience method for getting a DisplayObject's location as a Point.
     *
     * @param dobj The DisplayObject to query.
     * @param out An optional Point variable to store the result in. This
     *            can be used to avoid calling the Point constructor.
     */
    public static function getDisplayObjectLocation(
            dobj:DisplayObject, out:Point = null):Point
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

    /**
     * Convert a point in one DisplayObject's local coordinaet space to the
     * local space of another.
     *
     * @param pointInFromSpace
     * The point in the source DisplayObject's coordinate space.
     *
     * @param fromSpace
     * The source DisplayObject.
     *
     * @param toSpace
     * The target DisplayObject.
     *
     * @return The point in the target DisplayObject's local coordinate space.
     */
    public static function convertPoint(
            pointInFromSpace:Point, fromSpace:DisplayObject,
            toSpace:DisplayObject):Point
    {
        if (fromSpace === toSpace) return pointInFromSpace.clone();
        var global:Point = fromSpace.localToGlobal(pointInFromSpace);
        return toSpace.globalToLocal(global);
    }

    /**
     * Replces one DisplayObject with another, maintaining its layering,
     * position, and optionally its size.
     *
     * @param original     The DisplayObject to remove.
     * @param replacement  The DisplayObject to put in place of original.
     * @param copySize     If <code>true</code>, will set replacement's
     *                     <code>width</code> and <code>height</code>
     *                     to that of original.
     * @return  The DisplayObject passed into <code>replacement</code>.
     */
    public static function replaceDisplay(
            original:DisplayObject, replacement:DisplayObject,
            copySize:Boolean = false):DisplayObject
    {
        var container:DisplayObjectContainer = original.parent;

        replacement.x = original.x;
        replacement.y = original.y;

        original.x = 0;
        original.y = 0;

        if (copySize)
        {
            replacement.width = original.width;
            replacement.height = original.height;
        }

        container.addChildAt(replacement, container.getChildIndex(original));
        container.removeChild(original);
        return replacement;
    }

    /**
     * Returns an array of all the immediate children of a
     * DisplayObjectContainer.
     */
    public static function getAllChildren(container:DisplayObjectContainer):Array
    {
        var children:Array = [ ];
        for (var i:int = 0; i < container.numChildren; i++)
        {
            children.push(container.getChildAt(i));
        }
        return children;
    }

    /**
     * Removes all children from a DisplayObjectContainer.
     */
    public static function removeAllChildren(container:DisplayObjectContainer):void
    {
        while (container.numChildren > 0)
            container.removeChildAt(0);
    }

    /**
     * Removes a DisplayObject from its parent, if it has one.
     *
     * @param child  The DisplayObject to remove from its parent.
     * @return  <code>true</code> if successful,
     *          <code>false</code> otherwise.
     */
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

    /**
     * Concatenates the child's transform with its parent, and resets the
     * child's transform.
     */
    public static function hoistTransform(child:DisplayObject):void
    {
        if (!child)
            throw new ArgumentError("child argument must not be null");

        var parent:DisplayObjectContainer = child.parent;

        if (!parent)
            throw new ArgumentError("child has no parent");

        var parentMatrix:Matrix = parent.transform.matrix.clone();
        parentMatrix.concat(child.transform.matrix);

        parent.transform.matrix = parentMatrix;
        child.transform.matrix = new Matrix();
    }

    /**
     * Inserts a new DisplayObjectContainer between an existing
     * DisplayObject and its parent.  The DisplayObject is made a child
     * of the new parent, and the new parent is made a child of the old
     * parent.
     */
    public static function insertParent(
            child:DisplayObject,
            newParent:DisplayObjectContainer = null):DisplayObjectContainer
    {
        if (!child)
            throw new ArgumentError("child argument must not be null");

        var oldParent:DisplayObjectContainer = child.parent;

        if (!newParent)
        {
            newParent = new Sprite();
        }

        if (oldParent)
        {
            var oldIndex:int = oldParent.getChildIndex(child);
            oldParent.addChildAt(newParent, oldIndex);
        }
        newParent.addChild(child);
        return newParent;
    }

    /**
     * Makes the specified DisplayObjects a child of a new Sprite.  If they have
     * parent DisplayObjectContainers, the newly created Sprite is inserted at
     * the lowest index among the DisplayObjects.  For this to occur, all the
     * DisplayObjects must have the same parent.
     *
     * @param displayObjects  A for each...in iterable collection of
     *                        DisplayObjects
     *
     * @return                The new Sprite that becomes the parent of the
     *                        DisplayObjects
     *
     * @throws ArgumentError if the DisplayObjects do not share a common parent,
     * or if the DisplayObjects do not all have null parents.
     */
    public static function group(displayObjects:*):DisplayObjectContainer
    {
        var oldParent:DisplayObjectContainer;
        var newParent:DisplayObjectContainer = new Sprite();
        var taggedDisplayObjects:Array;

        for each (var currentDisplay:DisplayObject in displayObjects)
        {
            if (!taggedDisplayObjects)
            {
                taggedDisplayObjects = [ ];
                oldParent = currentDisplay.parent;
            }
            else
            {
                if (currentDisplay.parent != oldParent)
                {
                    throw new ArgumentError("All DisplayObjects must have " +
                        "the same value for their parent property");
                }
            }

            taggedDisplayObjects.push({
                d: currentDisplay,
                i: oldParent ? oldParent.getChildIndex(currentDisplay) : 0
            });
        }

        if (oldParent)
        {
            taggedDisplayObjects.sortOn("i", Array.NUMERIC);
        }
        for each (var tag:Object in taggedDisplayObjects)
        {
            newParent.addChild(tag.d);
        }
        if (oldParent)
        {
            oldParent.addChildAt(newParent, taggedDisplayObjects[0].i);
        }
        return newParent;
    }

    /**
     * Sets whether a DisplayObject is a child of a DisplayObjectContainer
     * based on a Boolean argument.
     */
    public static function setChildAttached(
            child:DisplayObject, parent:DisplayObjectContainer, attach:Boolean):void
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

    /**
     * Sets the <code>alpha</code> property of a DisplayObject, and if its
     * <code>alpha</code> is <code>0</code>, sets its <code>visible</code>
     * to <code>false</code>.  Otherwise, sets its <code>visible</code> to
     * <code>true</code>.
     */
    public static function setAutoAlpha(display:DisplayObject, alpha:Number):void
    {
        display.alpha = alpha;
        display.visible = alpha > 0;
    }

    /**
     * Detatches a DisplayObject from its parent and returns its
     * <code>x</code>, <code>y</code>, <code>width</code> and
     * <code>height</code> as a Rectangle.
     */
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

    /**
     * Detatches a DisplayObject from its parent and returns its
     * <code>x</code> and <code>y</code> as a Point.
     */
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

    /**
     * Queries whether a DisplayObjectContainer is equal to, or contains,
     * the object with keyboard focus.
     *
     * @param query  The DisplayObjectContainer to query.
     * @return <code>true</code> if <code>query</code> is the
     * currently-focused object, or contains it as a descendant. Otherwise
     * returns <code>false</code>. Also returns <code>false</code> if the
     * query object is not on stage, or if there is no focused object.
     */
    public static function enclosesFocusedObject(query:DisplayObjectContainer):Boolean
    {
        return query && query.stage && query.stage.focus &&
                (query == query.stage.focus ||
                 query.contains(query.stage.focus));
    }
}
}
