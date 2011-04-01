package org.yellcorp.lib.debug.watcher
{
import flash.display.DisplayObject;
import flash.geom.Matrix;


public class Change extends WatchResult
{
    public function Change(display:DisplayObject, before:Matrix, after:Matrix)
    {
        super(WatchResult.CHANGE, display, before, after);
    }
}
}
