package org.yellcorp.ui.scrollbar
{
import fl.controls.ScrollBarDirection;

import flash.display.DisplayObject;


public class VerticalScrollBar extends BaseScrollBar
{
    public function VerticalScrollBar(initSkin:ScrollBarSkin, useIntegerScrollValues:Boolean = true)
    {
        super(initSkin, useIntegerScrollValues);
    }

    protected override function getOrientation():String
    {
        return ScrollBarDirection.VERTICAL;
    }

    protected override function getAxisCoord(display:DisplayObject):Number
    {
        return display.y;
    }

    protected override function setAxisCoord(display:DisplayObject, newPosition:Number):void
    {
        display.y = newPosition;
    }

    protected override function getAxisSize(display:DisplayObject):Number
    {
        return display.height;
    }

    protected override function setAxisSize(display:DisplayObject, newSize:Number):void
    {
        display.height = newSize;
    }

    protected override function getTotalSize():Number
    {
        return height;
    }

    protected override function getMouseCoordinate():Number
    {
        return mouseY;
    }

    protected override function draw():void
    {
        if (invalidSize)
        {
            setTotalSize(height);
            invalidSize = false;
        }
    }
}
}
