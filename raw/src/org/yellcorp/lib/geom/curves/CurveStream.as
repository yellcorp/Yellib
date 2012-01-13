package org.yellcorp.lib.geom.curves
{


public interface CurveStream
{
    function moveTo(x:Number, y:Number):void;
    function lineTo(x:Number, y:Number):void;
    function curveTo(cx:Number, cy:Number, px:Number, py:Number):void;
}
}
