package wip.yellcorp.display
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;


public class BaseDisplay extends Sprite
{
    private var _width:Number;
    private var _height:Number;

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

    public function get hierarchicalDepth():int
    {
        var node:DisplayObjectContainer;
        var depth:int = 0;

        for (node = parent; node; node = node.parent)
        {
            depth++;
        }

        return depth;
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

    protected function onRender():void
    {
    }

    protected function onAddedToStage():void
    {
    }

    protected function onRemovedFromStage():void
    {
    }

    private function callAddedToStage(event:Event):void
    {
        var renderPriority:int = int.MAX_VALUE - hierarchicalDepth;
        stage.addEventListener(Event.RENDER, callRender, false, renderPriority);

        onAddedToStage();
    }

    private function callRemovedFromStage(event:Event):void
    {
        onRemovedFromStage();
    }

    private function callRender(event:Event):void
    {
        onRender();
    }

    private function invalidate():void
    {
        if (destroyed || !stage) return;

        stage.invalidate();
    }
}
}
