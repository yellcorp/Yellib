package org.yellcorp.bitmap.loader
{
import flash.geom.Matrix;
import flash.geom.Point;


internal interface Resizer
{
    function isOversize(width:int, height:int):Boolean;

    function fitCrop(inWidth:int, inHeight:int,
            outSize:Point):void;

    function fitScale(inWidth:int, inHeight:int,
            outSize:Point, outMatrix:Matrix):void;
}
}
