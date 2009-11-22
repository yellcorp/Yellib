package org.yellcorp.display
{
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;


public class TiledBitmap extends Shape
{
    private var bitmap:BitmapData;
    private var _width:Number;
    private var _height:Number;
    private var _fillTransform:Matrix;

    public function TiledBitmap(fillPattern:BitmapData, initialTransform:Matrix = null)
    {
        bitmap = fillPattern;
        _width = fillPattern.width;
        _height = fillPattern.height;
        _fillTransform = initialTransform || new Matrix();
        draw();
    }

    private function draw():void
    {
        graphics.clear();
        graphics.beginBitmapFill(bitmap, _fillTransform);
        graphics.drawRect(0, 0, _width, _height);
        graphics.endFill();
    }

    public override function get width():Number
    {
        return _width;
    }

    public override function set width(width:Number):void
    {
        _width = width;
        draw();
    }

    public override function get height():Number
    {
        return _height;
    }

    public override function set height(height:Number):void
    {
        _height = height;
        draw();
    }

    public function get fillTransform():Matrix
    {
        return _fillTransform;
    }

    public function set fillTransform(fillTransform:Matrix):void
    {
        _fillTransform = fillTransform || new Matrix();
        draw();
    }
}
}
