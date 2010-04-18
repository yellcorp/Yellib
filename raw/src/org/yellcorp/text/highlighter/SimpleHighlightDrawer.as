package org.yellcorp.text.highlighter
{
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Rectangle;


public class SimpleHighlightDrawer implements HighlightDrawer
{
    public var highlightColor:uint;

    private var canvas:Shape;
    private var clipRect:Rectangle;

    public function SimpleHighlightDrawer(canvas:Shape, highlightColor:uint)
    {
        this.highlightColor = highlightColor;
        this.canvas = canvas;
        clipRect = new Rectangle();
    }

    public function setScrollRect(x:int, y:int, width:Number, height:Number):void
    {
        clipRect.x = x;
        clipRect.y = y;
        clipRect.width = width;
        clipRect.height = height;
        canvas.scrollRect = clipRect;
    }

    public function clearTextRuns():void
    {
        canvas.graphics.clear();
    }

    public function drawTextRun(shape:TextRunShape):void
    {
        var g:Graphics = canvas.graphics;
        var rect:Rectangle;

        for each (rect in shape.getRectangleList())
        {
            g.beginFill(highlightColor);
            g.drawRect(rect.x, rect.y, rect.width, rect.height);
            g.endFill();
        }
    }
}
}
