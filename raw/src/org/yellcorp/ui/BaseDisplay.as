package org.yellcorp.ui
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getQualifiedClassName;


public class BaseDisplay extends Sprite implements Displayable
{
    public static const SIZE:String = "SIZE";
    public static const SCROLL:String = "SCROLL";
    public static const STATE:String = "STATE";
    public static const CONTENT:String = "CONTENT";

    protected var _width:Number;
    protected var _height:Number;

    private var waitingForRender:Boolean;
    private var handlingRender:Boolean;

    private var debug:Boolean = false;

    private var invalidTokens:Object;

    public function BaseDisplay(initialWidth:Number = 0, initialHeight:Number = 0)
    {
        invalidTokens = { };

        _width = initialWidth;
        _height = initialHeight;
        addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
    }

    public function get display():DisplayObject
    {
        return this;
    }

    public override function get width():Number
    {
        return _width;
    }

    public override function set width(new_width:Number):void
    {
        _width = new_width;
        invalidate(SIZE);
    }

    public override function get height():Number
    {
        return _height;
    }

    public override function set height(new_height:Number):void
    {
        _height = new_height;
        invalidate(SIZE);
    }

    public function setSize(w:Number, h:Number):void
    {
        _width = w;
        _height = h;
        invalidate(SIZE);
    }

    public function forceRedraw():void
    {
        invalidate(SIZE);
        draw();
    }

    protected function getDisplayWidth():Number
    {
        return super.width;
    }

    protected function getDisplayHeight():Number
    {
        return super.height;
    }

    protected function setSizeOn(object:DisplayObject, w:Number, h:Number):void
    {
        var asBaseDisplay:BaseDisplay = object as BaseDisplay;
        if (asBaseDisplay)
        {
            asBaseDisplay.setSize(w, h);
            if (handlingRender)
            {
                asBaseDisplay.forceRedraw();
            }
        }
        else
        {
            object.width = w;
            object.height = h;
        }
    }

    protected function forceRedrawOn(... updatedObjects):void
    {
        var object:*;
        var asBaseDisplay:BaseDisplay;
        for each (object in updatedObjects)
        {
            if ((asBaseDisplay = object as BaseDisplay))
            {
                asBaseDisplay.forceRedraw();
            }
        }
    }

    protected function invalidate(token:String):void
    {
        invalidTokens[token] = true;

        if (!waitingForRender)
        {
            waitingForRender = true;
            if (stage)
            {
                stage.invalidate();
                addEventListener(Event.ENTER_FRAME, onNextFrame, false, 0, true);
            }
        }
    }

    protected function validate(token:String):void
    {
        delete invalidTokens[token];
    }

    protected function isInvalid(token:String):Boolean
    {
        return invalidTokens[token] === true;
    }

    protected function isValid(token:String):Boolean
    {
        return invalidTokens[token] !== true;
    }

    protected function onAddedToStage(event:Event):void
    {
    }

    protected function onRemovedFromStage(event:Event):void
    {
    }

    protected function draw():void
    {
    }

    protected function debugName():String
    {
        return "(" + getQualifiedClassName(this) + ")" + this.name;
    }

    private function _onAddedToStage(event:Event):void
    {
        stage.addEventListener(Event.RENDER, onRender);
        onAddedToStage(event);
        if (waitingForRender)
        {
            if (debug)
            {
                trace(debugName() + " " + event.type + " render");
            }
            onRender();
        }
    }

    private function _onRemovedFromStage(event:Event):void
    {
        onRemovedFromStage(event);
        stage.removeEventListener(Event.RENDER, onRender);
    }

    private function onRender(event:Event = null):void
    {
        waitingForRender = false;
        handlingRender = true;
        draw();
        handlingRender = false;
    }

    private function onNextFrame(event:Event):void
    {
        removeEventListener(Event.ENTER_FRAME, onNextFrame, false);
        if (waitingForRender)
        {
            if (debug)
            {
                trace(debugName() + " " + event.type + " render");
            }
            onRender();
        }
    }
}
}
