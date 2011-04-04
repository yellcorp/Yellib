package org.yellcorp.lib.debug.watcher
{
import org.yellcorp.lib.debug.DebugUtil;

import flash.display.DisplayObject;
import flash.geom.Matrix;


public class Difference
{
    public static const NONE:String = "NONE";
    public static const ADD:String = "ADD";
    public static const REMOVE:String = "REMOVE";
    public static const REORDER:String = "REORDER";
    public static const TRANSFORM:String = "TRANSFORM";
    public static const TRANSFORM_REORDER:String = "TRANSFORM+REORDER";

    public var display:DisplayObject;
    public var oldTransform:Matrix;
    public var newTransform:Matrix;
    public var oldIndex:int;
    public var newIndex:int;

    public function Difference(display:DisplayObject,
        newTransform:Matrix = null, newIndex:int = -1,
        oldTransform:Matrix = null, oldIndex:int = -1)
    {
        this.display = display;
        this.oldTransform = oldTransform;
        this.newTransform = newTransform;
        this.oldIndex = oldIndex;
        this.newIndex = newIndex;
    }

    public function get type():String
    {
        if (oldTransform && newTransform)
        {
            if (WatcherUtil.matricesEqual(oldTransform, newTransform))
            {
                return oldIndex == newIndex ? NONE : REORDER;
            }
            else
            {
                return oldIndex == newIndex ? TRANSFORM : TRANSFORM_REORDER;
            }
        }
        else if (!oldTransform)
        {
            return ADD;
        }
        else
        {
            return REMOVE;
        }
    }

    public function toString():String
    {
        return "[WatchResult " + type + " " +
               DebugUtil.getShortClassName(display) +
               '("' + display.name + '") ' +
               matrixChangeString + " " +
               indexChangeString + "]";
    }

    public function get matrixChangeString():String
    {
        if ((oldTransform || newTransform) &&
            !WatcherUtil.matricesEqual(oldTransform, newTransform))
        {
            return (oldTransform || "nothing") + " -> " +
                   (newTransform || "nothing");
        }
        else
        {
            return "";
        }
    }

    public function get indexChangeString():String
    {
        if (oldIndex >= 0 && newIndex >= 0 && oldIndex != newIndex)
        {
            return "[" + oldIndex + "] -> [" + newIndex + "]";
        }
        else
        {
            return "";
        }
    }
}
}
