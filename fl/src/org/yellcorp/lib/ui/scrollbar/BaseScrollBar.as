package org.yellcorp.lib.ui.scrollbar
{
import fl.events.ScrollEvent;

import org.yellcorp.lib.core.Disposable;
import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.ui.BaseDisplay;
import org.yellcorp.lib.ui.utils.AutoVaryingTimer;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Dictionary;


[Event(name="scroll", type="fl.events.ScrollEvent")]
public class BaseScrollBar extends BaseDisplay implements Disposable
{
    public var arrowStep:Number;
    public var pageStep:Number;
    public var updateWhileDragging:Boolean;

    private var _minScroll:Number;
    private var _maxScroll:Number;
    private var _currentScroll:Number;

    private var orientation:String;

    private var skin:ScrollBarSkin;
    private var track:InteractiveObject;
    private var decButton:InteractiveObject;
    private var incButton:InteractiveObject;
    private var cursor:InteractiveObject;

    private var nativeDecButtonSize:Number;
    private var nativeIncButtonSize:Number;
    private var nativeCursorSize:Number;
    private var lastTotalSize:Number;

    private var _cursorSize:Number;
    private var _minCursorSize:Number;
    private var lastCursorSize:Number;
    private var cursorSizeNeedsRecalc:Boolean;

    private var repeatTimer:AutoVaryingTimer;
    private var repeatDelta:Number;
    private var repeatStopScroll:Number;

    private var draggingCursor:Boolean;
    private var dragOffset:Number;

    private var wheelTargets:Dictionary;

    private var reducedButtons:Boolean;

    private var integerValues:Boolean;

    public function BaseScrollBar(initSkin:ScrollBarSkin, useIntegerScrollValues:Boolean = true)
    {
        integerValues = useIntegerScrollValues;

        skin = initSkin;

        super();

        addChild(track = skin.createTrack());
        addChild(decButton = skin.createDecrementButton());
        addChild(incButton = skin.createIncrementButton());
        addChild(cursor = skin.createCursor());

        _width = decButton.width;
        _height = decButton.height;

        setupView();

        wheelTargets = new Dictionary(true);

        _minScroll = _maxScroll = _currentScroll = 0;
        _minCursorSize = _cursorSize;

        arrowStep = 1;
        pageStep = 4;
        updateWhileDragging = true;

        repeatTimer = new AutoVaryingTimer(250, 1000 / 30, 2);

        orientation = getOrientation();

        setupEvents();
    }

    public function addMouseWheelListener(mouseWheelTarget:InteractiveObject):void
    {
        if (!wheelTargets[mouseWheelTarget])
        {
            wheelTargets[mouseWheelTarget] = mouseWheelTarget;
            mouseWheelTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        }
    }

    public function removeMouseWheelListener(mouseWheelTarget:InteractiveObject):void
    {
        delete wheelTargets[mouseWheelTarget];
        mouseWheelTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function clearMouseWheelListeners():void
    {
        var mwTarget:InteractiveObject;
        for each (mwTarget in wheelTargets)
        {
            removeMouseWheelListener(mwTarget);
        }
    }

    public function dispose():void
    {
        clearMouseWheelListeners();
        destroyEvents();
    }

    public function get minScroll():Number
    {
        return _minScroll;
    }

    public function set minScroll(new_minScroll:Number):void
    {
        if (integerValues) new_minScroll = Math.round(new_minScroll);

        if (_minScroll !== new_minScroll)
        {
            _minScroll = new_minScroll;
            scrollRangeChanged();
        }
    }

    public function get maxScroll():Number
    {
        return _maxScroll;
    }

    public function set maxScroll(new_maxScroll:Number):void
    {
        if (integerValues) new_maxScroll = Math.round(new_maxScroll);

        if (_maxScroll !== new_maxScroll)
        {
            _maxScroll = new_maxScroll;
            scrollRangeChanged();
        }
    }

    public function get currentScroll():Number
    {
        return _currentScroll;
    }

    public function set currentScroll(new_currentScroll:Number):void
    {
        var scrollEvent:ScrollEvent;

        if (integerValues) new_currentScroll = Math.round(new_currentScroll);

        if (new_currentScroll < _minScroll)
        {
            new_currentScroll = _minScroll;
        }
        else if (new_currentScroll > _maxScroll)
        {
            new_currentScroll = _maxScroll;
        }

        if (_currentScroll !== new_currentScroll)
        {
            scrollEvent = new ScrollEvent(orientation, new_currentScroll - _currentScroll, new_currentScroll);
            _currentScroll = new_currentScroll;
            if (!draggingCursor) redrawCursor();
            dispatchEvent(scrollEvent);
        }
    }

    public function get cursorSize():Number
    {
        return _cursorSize;
    }

    public function set cursorSize(new_cursorSize:Number):void
    {
        if (!isFinite(new_cursorSize) || new_cursorSize <= 0)
        {
            new_cursorSize = 0;
        }

        if (_cursorSize !== new_cursorSize)
        {
            _cursorSize = new_cursorSize;
            cursorSizeChanged();
        }
    }

    public function get minCursorSize():Number
    {
        return _minCursorSize;
    }

    public function set minCursorSize(new_minCursorSize:Number):void
    {
        if (_minCursorSize !== new_minCursorSize)
        {
            _minCursorSize = new_minCursorSize;
            cursorSizeChanged();
        }
    }

    protected function getOrientation():String
    {
        // return an fl.controls.ScrollBarDirection constant here
        throw new AbstractCallError();
    }

    protected function getAxisCoord(display:DisplayObject):Number
    {
        // this should be overridden by a function returns the x
        // of the display object if the scroll bar is horizontal,
        // or y if it is vertical
        throw new AbstractCallError();
    }

    protected function setAxisCoord(display:DisplayObject, newPosition:Number):void
    {
        throw new AbstractCallError();
    }

    protected function getAxisSize(display:DisplayObject):Number
    {
        // this should be overridden by a function that measures the
        // passed-in display object and returns its width if the
        // scroll bar is horizontal, or height if it is vertical
        throw new AbstractCallError();
    }

    protected function setAxisSize(display:DisplayObject, newSize:Number):void
    {
        throw new AbstractCallError();
    }

    protected function getMouseCoordinate():Number
    {
        throw new AbstractCallError();
    }

    protected function getTotalSize():Number
    {
        throw new AbstractCallError();
    }

    protected function setTotalSize(newSize:Number):void
    {
        // should be called from the subclass when the width changes
        // for h-scrollbars, or when the height changes for v-scrollbars
        if (newSize !== lastTotalSize)
        {
            lastTotalSize = newSize;
            redraw(newSize);
        }
    }

    private function onDecPress(event:MouseEvent):void
    {
        step(-arrowStep, true, _minScroll);
    }

    private function onIncPress(event:MouseEvent):void
    {
        step(arrowStep, true, _maxScroll);
    }

    private function onTrackPress(event:MouseEvent):void
    {
        var stopScroll:Number;

        if (!cursor.visible) return;

        stopScroll = convertTrackCoordToScrollValue(getMouseCoordinate(), true);

        step(stopScroll > currentScroll ? pageStep : -pageStep, true, stopScroll);
    }

    private function onCursorPress(event:MouseEvent):void
    {
        startCursorDrag(getAxisCoord(cursor) - getMouseCoordinate());
    }

    private function onMouseWheel(event:MouseEvent):void
    {
        currentScroll += event.delta * -arrowStep;    // WheelUp is positive
    }

    private function onAnyRelease(event:MouseEvent):void
    {
        stopRepeat();
        if (draggingCursor) stopCursorDrag();
    }

    private function startCursorDrag(offset:Number):void
    {
        dragOffset = offset;
        draggingCursor = true;
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onCursorDrag);
    }

    private function stopCursorDrag():void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onCursorDrag);
        setCurrentScrollFromCursor();
        draggingCursor = false;
        redrawCursor();
    }

    private function onCursorDrag(event:MouseEvent):void
    {
        setCursorCoord(getMouseCoordinate() + dragOffset);

        if (updateWhileDragging)
        {
            setCurrentScrollFromCursor();
        }
    }

    private function setCursorCoord(newCursorCoord:Number):void
    {
        var cursorMin:Number;
        var cursorMax:Number;

        cursorMin = getAxisSize(decButton);
        cursorMax = cursorMin + getAxisSize(track) - getAxisSize(cursor);

        if (newCursorCoord < cursorMin)
        {
            newCursorCoord = cursorMin;
        }
        else if (newCursorCoord > cursorMax)
        {
            newCursorCoord = cursorMax;
        }

        setAxisCoord(cursor, newCursorCoord);
    }

    private function setCurrentScrollFromCursor():void
    {
        currentScroll = convertTrackCoordToScrollValue(getAxisCoord(cursor), false);
    }

    private function step(delta:Number, repeat:Boolean, stopScroll:Number):void
    {
        currentScroll = addWithSignedClamp(currentScroll, delta, stopScroll);

        if (repeat && currentScroll != stopScroll)
        {
            startRepeat(delta, stopScroll);
        }
    }

    private function startRepeat(delta:Number, stopScroll:Number):void
    {
        stopRepeat();
        repeatDelta = delta;
        repeatStopScroll = stopScroll;
        repeatTimer.start();
    }

    private function stopRepeat():void
    {
        repeatTimer.stop();
        repeatTimer.reset();
    }

    private function onRepeat(event:TimerEvent):void
    {
        var newScroll:Number = addWithSignedClamp(currentScroll, repeatDelta, repeatStopScroll);

        currentScroll = newScroll;

        if (newScroll == repeatStopScroll)
        {
            stopRepeat();
        }
    }

    private function redraw(size:Number):void
    {
        if (size <= nativeDecButtonSize + nativeIncButtonSize)
        {
            redrawReducedButtonsMode(size);
        }
        else
        {
            redrawNormal(size);
        }
    }

    private function redrawReducedButtonsMode(size:Number):void
    {
        var decProportion:Number = nativeDecButtonSize / (nativeDecButtonSize + nativeIncButtonSize);

        var decSize:Number = Math.round(decProportion * size);

        setAxisSize(decButton, decSize);
        setAxisCoord(incButton, decSize);
        setAxisSize(incButton, size - decSize);

        track.visible = false;
        cursor.visible = false;

        reducedButtons = true;
    }

    private function redrawNormal(size:Number):void
    {
        var trackSize:Number;

        if (reducedButtons)
        {
            setAxisSize(decButton, nativeDecButtonSize);
            setAxisSize(incButton, nativeIncButtonSize);
            reducedButtons = false;
        }

        setAxisCoord(incButton, size - getAxisSize(incButton));

        trackSize = size - nativeDecButtonSize - nativeIncButtonSize;
        setAxisSize(track, trackSize);
        track.visible = true;

        redrawCursor();
    }

    private function redrawCursor():void
    {
        var cursorPos:Number;
        var trackSize:Number;

        trackSize = getAxisSize(track);

        if (reducedButtons || _minScroll == _maxScroll)
        {
            cursor.visible = false;
            return;
        }

        if (!isFinite(lastCursorSize) || cursorSizeNeedsRecalc)
        {
            lastCursorSize = _cursorSize > 0 ? calcCursorSize(trackSize) : nativeCursorSize;
            cursorSizeNeedsRecalc = false;
        }

        cursor.visible = lastCursorSize < trackSize;

        if (cursor.visible)
        {
            setAxisSize(cursor, lastCursorSize);
            cursorPos = scaleRange(_currentScroll,
                                   _minScroll, _maxScroll,
                                   nativeDecButtonSize,
                                   nativeDecButtonSize + trackSize - lastCursorSize);

            if (!isFinite(cursorPos))
            {
                cursorPos = 0;
            }

            setAxisCoord(cursor, Math.round(cursorPos));
        }
    }

    private function calcCursorSize(maxSize:Number):Number
    {
        if (isNaN(cursorSize) || _cursorSize <= 0)
        {
            return nativeCursorSize;
        }
        else if (_maxScroll == _minScroll)
        {
            return maxSize;
        }
        else
        {
            return Math.abs(_cursorSize / (_maxScroll - _minScroll + _cursorSize)) * maxSize;
        }
    }

    private function setupView():void
    {
        nativeDecButtonSize = getAxisSize(decButton);
        nativeIncButtonSize = getAxisSize(incButton);
        nativeCursorSize = getAxisSize(cursor);

        setAxisCoord(decButton, 0);
        setAxisCoord(track, nativeDecButtonSize);

        // maxScroll and minScroll both start inited to zero, this
        // means no cursor
        cursor.visible = false;
    }

    private function setupEvents():void
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

        track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackPress);
        decButton.addEventListener(MouseEvent.MOUSE_DOWN, onDecPress);
        incButton.addEventListener(MouseEvent.MOUSE_DOWN, onIncPress);
        cursor.addEventListener(MouseEvent.MOUSE_DOWN, onCursorPress);

        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

        repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
    }

    private function destroyEvents():void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

        track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackPress);
        decButton.removeEventListener(MouseEvent.MOUSE_DOWN, onDecPress);
        incButton.removeEventListener(MouseEvent.MOUSE_DOWN, onIncPress);
        cursor.removeEventListener(MouseEvent.MOUSE_DOWN, onCursorPress);

        removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

        repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);
    }

    private function onMouseDown(event:MouseEvent):void
    {
        if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onAnyRelease);
    }

    private function convertTrackCoordToScrollValue(trackCoord:Number, useCentre:Boolean):Number
    {
        var scrollValue:Number;
        var trackMin:Number;
        var trackMax:Number;

        var cursorSize:Number = cursor.visible ? getAxisSize(cursor) : 0;

        trackMin = getAxisCoord(track);
        trackMax = trackMin + getAxisSize(track) - cursorSize;

        if (useCentre)
        {
            trackMin += cursorSize * .5;
            trackMax += cursorSize * .5;
        }
        // else use top-left

        scrollValue = scaleRange(trackCoord, trackMin, trackMax, _minScroll, _maxScroll);

        if (!isFinite(scrollValue) || scrollValue < _minScroll)
        {
            return _minScroll;
        }
        else if (scrollValue > _maxScroll)
        {
            return _maxScroll;
        }
        else
        {
            return scrollValue;
        }
    }

    private static function addWithSignedClamp(oldValue:Number, delta:Number, limit:Number):Number
    {
        var newValue:Number = oldValue + delta;

        if ((delta > 0 && newValue > limit) ||
            (delta < 0 && newValue < limit))
        {
            newValue = limit;
        }

        return newValue;
    }

    private static function scaleRange(oldValue:Number, oldMin:Number, oldMax:Number, newMin:Number, newMax:Number):Number
    {
        return (oldValue - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
    }

    private function scrollRangeChanged():void
    {
        cursorSizeNeedsRecalc = cursorSizeNeedsRecalc || !isFinite(_cursorSize);
        // invoke the currentScroll setter
        currentScroll = currentScroll;
        redrawCursor();
    }

    private function cursorSizeChanged():void
    {
        cursorSizeNeedsRecalc = true;
        redrawCursor();
    }
}
}
