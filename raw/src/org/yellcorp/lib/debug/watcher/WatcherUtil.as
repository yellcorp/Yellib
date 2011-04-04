package org.yellcorp.lib.debug.watcher
{
import flash.geom.Matrix;


public class WatcherUtil
{
    public static function matricesEqual(m:Matrix, n:Matrix):Boolean
    {
        if (!m || !n)
        {
            return false;
        }
        else
        {
            return m.a  == n.a  &&
                   m.b  == n.b  &&
                   m.c  == n.c  &&
                   m.d  == n.d  &&
                   m.tx == n.tx &&
                   m.ty == n.ty;
        }
    }
}
}
