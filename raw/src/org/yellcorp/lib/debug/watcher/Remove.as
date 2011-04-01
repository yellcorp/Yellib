package org.yellcorp.lib.debug.watcher
{
import flash.display.DisplayObject;
import flash.geom.Matrix;


public class Remove extends WatchResult
{
    public function Remove(display:DisplayObject, before:Matrix)
    {
        super(WatchResult.REMOVE, display, before, null);
    }
}
}
