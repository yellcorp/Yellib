package org.yellcorp.lib.splines.streams
{
public interface SplineStream
{
    function moveTo(x:Number, y:Number):void;
    function lineTo(x:Number, y:Number):void;
    function curveTo(cx:Number, cy:Number, px:Number, py:Number):void;
}
}
