package org.yellcorp.lib.debug.watcher
{
import flash.display.DisplayObject;
import flash.geom.Matrix;


public class Add extends WatchResult
{
    public function Add(display:DisplayObject, after:Matrix)
    {
        super(WatchResult.ADD, display, null, after);
    }
}
}
