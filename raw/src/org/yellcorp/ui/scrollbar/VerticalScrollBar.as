package org.yellcorp.ui.scrollbar
{
import fl.controls.ScrollBarDirection;

import flash.display.DisplayObject;
import flash.events.Event;


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

    protected override function getCoordinate(display:DisplayObject):Number
    {
        return display.y;
    }

    protected override function setCoordinate(display:DisplayObject, newPosition:Number):void
    {
        display.y = newPosition;
    }

    protected override function getSize(display:DisplayObject):Number
    {
        return display.height;
    }

    protected override function setSize(display:DisplayObject, newSize:Number):void
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

    protected override function onRender(renderEvent:Event):void
    {
        setTotalSize(height);
    }
}
}
