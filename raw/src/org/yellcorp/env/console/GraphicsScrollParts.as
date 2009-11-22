package org.yellcorp.env.console
{
import org.yellcorp.env.console.IScrollParts;

import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Sprite;


public class GraphicsScrollParts implements IScrollParts
{
    public var baseSize:Number = 16;

    public function makeUpButton():InteractiveObject
    {
        var btn:Sprite = makeBox(0);
        drawTriangle(btn.graphics, 0xffffff, true);
        return btn;
    }

    public function makeDownButton():InteractiveObject
    {
        var btn:Sprite = makeBox(0);
        drawTriangle(btn.graphics, 0xffffff, false);
        return btn;
    }

    public function makeCursor():InteractiveObject
    {
        return makeBox(0xffffff);
    }

    public function makeRange():InteractiveObject
    {
        return makeBox(0);
    }

    private function makeBox(col:uint):Sprite
    {
        var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
        g.beginFill(col);
        g.drawRect(0, 0, baseSize, baseSize);
        g.endFill();
        return sprite;
    }

    private function drawTriangle(g:Graphics, col:uint, pointUp:Boolean):void
    {
        var midx:Number = baseSize / 2;
        var leftx:Number = baseSize / 4;
        var rightx:Number = leftx * 3;

        var basey:Number = (baseSize / 4) * (pointUp ? 3 : 1);
        var pointy:Number = (baseSize / 4) * (pointUp ? 1 : 3);

        g.beginFill(col);
        g.moveTo(leftx, basey);
        g.lineTo(midx, pointy);
        g.lineTo(rightx, basey);
    }
}
}
