package org.yellcorp.lib.debug.watcher
{
import org.yellcorp.lib.debug.DebugUtil;

import flash.display.DisplayObject;
import flash.geom.Matrix;


public class WatchResult
{
    public static const CHANGE:String = "change";
    public static const ADD:String = "ADD";
    public static const REMOVE:String = "REMOVE";

    public var type:String;
    public var display:DisplayObject;
    public var before:Matrix;
    public var after:Matrix;

    public function WatchResult(type:String, display:DisplayObject, before:Matrix, after:Matrix)
    {
        this.type = type;
        this.display = display;
        this.before = before;
        this.after = after;
    }

    public function toString():String
    {
        return "[WatchResult " + type + " " +
               DebugUtil.getShortClassName(display) +
               '("' + display.name + '") ' +
               (before || "nothing") +
               " -> " +
               (after || "nothing") +
               "]";
    }
}
}
