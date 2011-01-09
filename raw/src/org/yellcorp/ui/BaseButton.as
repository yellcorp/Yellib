package org.yellcorp.ui
{
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;


public class BaseButton extends BaseDisplay
{
    private var _enabled:Boolean = true;
    private var _emphasized:Boolean;
    private var _selected:Boolean;
    private var _interactiveWhenSelected:Boolean = true;

    protected var mouseOver:Boolean;
    protected var mouseDown:Boolean;
    protected var hasFocus:Boolean;

    public function BaseButton(initialWidth:Number = 0, initialHeight:Number = 0)
    {
        super(initialWidth, initialHeight);

        mouseChildren = false;
        buttonMode = true;
        focusRect = false;
        //useHandCursor = false;

        addEventListener(MouseEvent.ROLL_OVER,  _onOver, false, 0, true);
        addEventListener(MouseEvent.ROLL_OUT,   _onOut,  false, 0, true);
        addEventListener(MouseEvent.MOUSE_DOWN, _onDown, false, 0, true);
        addEventListener(MouseEvent.MOUSE_UP,   _onUp,   false, 0, true);
    }

    protected override function onAddedToStage(event:Event):void
    {
        stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange, false, 0, true);
        super.onAddedToStage(event);
    }

    protected override function onRemovedFromStage(event:Event):void
    {
        stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange, false);
        super.onRemovedFromStage(event);
    }

    public function get enabled():Boolean
    {
        return _enabled;
    }

    public function set enabled(new_enabled:Boolean):void
    {
        _enabled = new_enabled;
        updateInteractive();
        invalidate(STATE);
    }

    public function get emphasized():Boolean
    {
        return _emphasized;
    }

    public function set emphasized(new_emphasized:Boolean):void
    {
        _emphasized = new_emphasized;
        invalidate(STATE);
    }

    public function get selected():Boolean
    {
        return _selected;
    }

    public function set selected(new_selected:Boolean):void
    {
        _selected = new_selected;
        updateInteractive();
        invalidate(STATE);
    }

    public function get interactiveWhenSelected():Boolean
    {
        return _interactiveWhenSelected;
    }

    public function set interactiveWhenSelected(v:Boolean):void
    {
        _interactiveWhenSelected = v;
        updateInteractive();
    }

    private function updateInteractive():void
    {
        mouseEnabled = _selected ? (_enabled && _interactiveWhenSelected) : _enabled;
    }

    private function _onOver(event:MouseEvent):void
    {
        mouseOver = true;
        invalidate(STATE);
        onOver(event);
    }

    protected function onOver(event:MouseEvent):void
    {
    }

    private function _onDown(event:MouseEvent):void
    {
        mouseDown = true;
        stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, int.MAX_VALUE, true);
        invalidate(STATE);
        onDown(event);
    }

    protected function onDown(event:MouseEvent):void
    {
    }

    private function _onUp(event:MouseEvent):void
    {
        mouseDown = false;
        invalidate(STATE);
        onUp(event);
    }

    protected function onUp(event:MouseEvent):void
    {
    }

    private function onStageUp(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp, false);
        if (mouseDown)
        {
            // means onUp wasn't triggered, which means it happened outside
            mouseDown = false;
            invalidate(STATE);
            if (onUpOutside(event))
            {
                onUp(event);
            }
        }
    }

    protected function onUpOutside(event:MouseEvent):Boolean
    {
        return true;
    }

    private function _onOut(event:MouseEvent):void
    {
        mouseOver = false;
        invalidate(STATE);
        onOut(event);
    }

    protected function onOut(event:MouseEvent):void
    {
    }

    private function onKeyFocusChange(event:FocusEvent):void
    {
        if (event.relatedObject === this)
        {
            hasFocus = true;
            invalidate(STATE);
            onFocusIn(event);
        }
        else if (event.target === this)
        {
            hasFocus = false;
            invalidate(STATE);
            onFocusOut(event);
        }
    }

    protected function onFocusIn(event:FocusEvent):void
    {
    }

    protected function onFocusOut(event:FocusEvent):void
    {
    }
}
}
