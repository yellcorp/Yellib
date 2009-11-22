package org.yellcorp.env.console
{
import org.yellcorp.display.Resizer;
import org.yellcorp.env.console.IScrollParts;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;


public class Scrollbar extends Resizer
{
    public var arrowStep:Number = 0;

    private var _value:Number = 0;
    private var _minValue:Number = 0;
    private var _maxValue:Number = 0;

    private var _cursorSpan:Number = 0;
    private var _minCursorScale:Number = 0;

    private var maxCursorY:Number = 0;
    private var baseCursorHeight:Number = 0;
    private var workPoint:Point;

    private var btnUp:InteractiveObject;
    private var btnDown:InteractiveObject;
    private var cursor:InteractiveObject;
    private var range:InteractiveObject;

    public function Scrollbar(parts:IScrollParts)
    {
        super();

        workPoint = new Point();

        addChild(btnUp = parts.makeUpButton());
        addChild(btnDown = parts.makeDownButton());
        addChild(range = parts.makeRange());
        addChild(cursor = parts.makeCursor());

        baseCursorHeight = cursor.height;

        btnUp.addEventListener(MouseEvent.MOUSE_DOWN, onUpPress, false, 0, true);
        btnDown.addEventListener(MouseEvent.MOUSE_DOWN, onDownPress, false, 0, true);
        cursor.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragCursor, false, 0, true);
        range.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragCursor, false, 0, true);

        initLayout();
        updateLayout();
    }

    public function get value():Number
    {
        return _value;
    }

    public function set value(v:Number):void
    {
        _value = v;
        clampValue();
        updatePosition();
    }

    public function get minValue():Number
    {
        return _minValue;
    }

    public function set minValue(v:Number):void
    {
        _minValue = v;
        clampValue();
        updatePosition();
    }

    public function get maxValue():Number
    {
        return _maxValue;
    }

    public function set maxValue(v:Number):void
    {
        _maxValue = v;
        clampValue();
        updatePosition();
    }

    public function get cursorSpan():Number
    {
        return _cursorSpan;
    }

    public function set cursorSpan(v:Number):void
    {
        _cursorSpan = v;
        updatePosition();
    }

    public function get minCursorSize():Number
    {
        return _minCursorScale;
    }

    public function set minCursorSize(v:Number):void
    {
        _minCursorScale = v / baseCursorHeight;
        if (_minCursorScale > cursor.scaleY);
        updatePosition();
    }

    protected override function onResize():void
    {
        updateLayout();
    }

    private function onUpPress(event:MouseEvent):void
    {
        arrowScroll(-1);
        stage.addEventListener(MouseEvent.MOUSE_UP, onArrowRelease, false, 0, true);
    }

    private function onDownPress(event:MouseEvent):void
    {
        arrowScroll(1);
        stage.addEventListener(MouseEvent.MOUSE_UP, onArrowRelease, false, 0, true);
    }

    private function onArrowRelease(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onArrowRelease, false);
    }

    private function onStartDragCursor(event:MouseEvent):void
    {
        onDragMove(event);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragMove, false, 0, true);
        stage.addEventListener(MouseEvent.MOUSE_UP, onDragRelease, false, 0, true);
    }

    private function onDragMove(event:MouseEvent):void
    {
        var oldValue:Number = _value;

        workPoint.x = event.stageX;
        workPoint.y = event.stageY;

        workPoint = globalToLocal(workPoint);

        cursor.y = workPoint.y - cursor.height / 2;
        clampCursor();
        updateFromCursor();

        dispatchChange(oldValue, _value);
    }

    private function onDragRelease(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMove, false);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onDragRelease, false);
    }

    private function arrowScroll(factor:Number):void
    {
        var oldValue:Number = value;

        if (arrowStep > 0)
        {
            value += arrowStep * factor;
        }
        else
        {
            cursor.y += factor;
            clampCursor();
            updateFromCursor();
        }

        dispatchChange(oldValue, value);
    }

    private function updateFromCursor():void
    {
        _value = _minValue + (_maxValue - _minValue) * ((cursor.y - range.y) / maxCursorY);
    }

    private function clampValue():void
    {
        if (_value < _minValue) _value = _minValue;
        else if (_value > _maxValue) _value = _maxValue;
    }

    private function clampCursor():void
    {
        if (cursor.y < range.y) cursor.y = range.y;
        else if (cursor.y - range.y > maxCursorY) cursor.y = maxCursorY + range.y;
    }

    private function dispatchChange(oldValue:Number, newValue:Number):void
    {
        var delta:Number = newValue - oldValue;

        trace(newValue);

        if (delta != 0)
            dispatchEvent(new Event(Event.SCROLL, false, false));
    }

    private function initLayout():void
    {
        // set up values that won't change
        btnUp.x = btnDown.x = cursor.x = range.x = 0;
        btnUp.y = 0;

        nominalWidth = range.width;
    }

    private function updateLayout():void
    {
        btnUp.width = btnDown.width = cursor.width = range.width = nominalWidth;

        if (nominalHeight <= (btnUp.height / btnUp.scaleY) + (btnDown.height / btnDown.scaleY))
        {
            range.visible = false;
            // FIXME: assumes btnUp and btnDown are same proportions
            btnUp.height = btnDown.height = btnDown.y = nominalHeight/2;
        }
        else
        {
            range.visible = true;
            btnUp.scaleY = btnDown.scaleY = 1;
            range.y = btnUp.y + btnUp.height;
            range.height = nominalHeight - btnDown.height - range.y;
            btnDown.y = range.y + range.height;
        }
        updatePosition();
    }

    private function updatePosition():void
    {
        var fractionalValue:Number;
        var spanScale:Number;

        if (!range.visible && cursor.visible || _maxValue == _minValue)
        {
            cursor.visible = false;
            return;
        }

        if (_cursorSpan > 0)
        {
            spanScale = (_cursorSpan / (_maxValue + _cursorSpan)) * (range.height / baseCursorHeight);
            cursor.scaleY = Math.max(_minCursorScale, spanScale);
        }
        else
        {
            cursor.scaleY = 1;
        }

        if (cursor.height >= range.height)
        {
            cursor.visible = false;
            return;
        }

        cursor.visible = true;

        fractionalValue = (_value - _minValue) / (_maxValue - _minValue);
        maxCursorY = range.height - cursor.height;

        cursor.y = range.y + fractionalValue * maxCursorY;
    }
}
}
