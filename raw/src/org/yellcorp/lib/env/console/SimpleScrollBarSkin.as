package org.yellcorp.lib.env.console
{
import org.yellcorp.lib.ui.scrollbar.ScrollBarSkin;

import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Sprite;


public class SimpleScrollBarSkin implements ScrollBarSkin
{
    public var baseSize:Number = 16;
    public var trackColor:uint = 0xDDDDDD;
    public var cursorColor:uint = 0x999999;
    public var buttonFaceColor:uint = 0xBBBBBB;
    public var buttonIconColor:uint = 0xFFFFFF;

    public function createTrack():InteractiveObject
    {
        return makeBox(trackColor);
    }

    public function createCursor():InteractiveObject
    {
        return makeBox(cursorColor);
    }

    public function createDecrementButton():InteractiveObject
    {
        var btn:Sprite = makeBox(buttonFaceColor);
        drawTriangle(btn.graphics, buttonIconColor, true);
        return btn;
    }

    public function createIncrementButton():InteractiveObject
    {
        var btn:Sprite = makeBox(buttonFaceColor);
        drawTriangle(btn.graphics, buttonIconColor, false);
        return btn;
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
