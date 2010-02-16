package org.yellcorp.ui
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;


public class BaseDisplay extends Sprite implements Displayable
{
    private var _width:Number;
    private var _height:Number;
    private var _invalid:Boolean;

    protected var destroyed:Boolean;

    public function BaseDisplay()
    {
        addEventListener(Event.ADDED_TO_STAGE, callAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, callRemovedFromStage, false, 0, true);

        super();

        _width = getInitialViewWidth();
        _height = getInitialViewHeight();
    }

    public override function get width():Number
    {
        return _width;
    }

    public override function set width(new_width:Number):void
    {
        if (_width != new_width)
        {
            _width = new_width;
            invalidate();
        }
    }

    public override function get height():Number
    {
        return _height;
    }

    public override function set height(new_height:Number):void
    {
        if (_height != new_height)
        {
            _height = new_height;
            invalidate();
        }
    }

    public override function set visible(new_visible:Boolean):void
    {
        super.visible = new_visible;
        if (needsRedraw())
        {
            callRender();
        }
    }

    public function get display():DisplayObject
    {
        return this;
    }

    public function destroy():void
    {
        destroyed = true;

        removeEventListener(Event.ADDED_TO_STAGE, callAddedToStage);
        removeEventListener(Event.REMOVED_FROM_STAGE, callRemovedFromStage);
    }

    /**
     * Utility functions to jump up the inheritance chain and
     * return the non-overidden width (height) as measured by Flash
     * just in case you need it
     */
    protected final function getDisplayWidth():Number
    {
        return super.width;
    }

    protected final function getDisplayHeight():Number
    {
        return super.height;
    }

    /**
     * Override getInitialViewWidth/Height to set an
     * initial size.  Default is to just return the
     * height/width on DisplayObject
     */
    protected function getInitialViewWidth():Number
    {
        return getDisplayWidth();
    }

    protected function getInitialViewHeight():Number
    {
        return getDisplayHeight();
    }

    protected function onAddedToStage(addedEvent:Event):void
    {
    }

    protected function onRemovedFromStage(removedEvent:Event):void
    {
    }

    protected function onRender(renderEvent:Event):void
    {
    }

    internal function callRender():void
    {
        _invalid = false;
        onRender(null);
    }

    internal function handleRender(event:Event):void
    {
        _invalid = false;
        onRender(event);
    }

    public function forceRedraw():void
    {
        callRender();
    }

    protected function invalidate():void
    {
        _invalid = true;
        if (needsRedraw())
        {
            stage.invalidate();

            // start a frame listener to fall back on in case the
            // RENDER doesn't get dispatched, which is the biggest
            // likelihood
            addEventListener(Event.ENTER_FRAME, onNextFrame);
        }
    }

    private function onNextFrame(event:Event):void
    {
        removeEventListener(Event.ENTER_FRAME, onNextFrame);
        if (needsRedraw()) callRender();
    }

    private function needsRedraw():Boolean
    {
        return _invalid && visible && stage;
    }

    private function callAddedToStage(event:Event):void
    {
        stage.addEventListener(Event.RENDER, handleRender);
        onAddedToStage(event);
        if (needsRedraw()) callRender();
    }

    private function callRemovedFromStage(event:Event):void
    {
        onRemovedFromStage(event);
        stage.removeEventListener(Event.RENDER, callRender);
    }

    protected final function illegalOpAfterDestroy():void
    {
        throw new IllegalOperationError("Not allowed on destroyed object");
    }
}
}
