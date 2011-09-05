package org.yellcorp.lib.ui
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getQualifiedClassName;


/**
 * A minimal implementation of a sprite that responds to stage invalidation.
 * Similar to the invalidation routine of fl.core.UIComponent, without
 * styles, accessibility, or live preview.
 *
 * <p>The general usage pattern is as follows:</p>
 * <ul>
 *   <li>Some function (often a setter) that triggers a change in the
 *       appearance of the object calls the <code>invalidate()</code>
 *       method, passing in a string that will be used to identify which
 *       aspect of the apperance needs redrawing.  If the redraw routine
 *       can't be broken into independent parts, just pass
 *       <code>SIZE</code>.</li>
 *   <li><code>invalidate()</code> schedules an <code>Event.RENDER</code>,
 *       which ultimately results in a call to <code>draw()</code>.</li>
 *   <li><code>draw()</code> is overridden with a implementation that checks
 *       which identifiers have been invalidated, updates the display that
 *       corresponds to each one, then calls <code>validate()</code> for
 *       each one.</li>
 * </ui>
 */
public class BaseDisplay extends Sprite
{
    /**
     * Identifies that the width and/or height of this object is invalid and
     * needs updating.
     */
    public static const SIZE:String = "SIZE";

    /**
     * Identifies that the scroll offset of this object is invalid and
     * needs updating.
     */
    public static const SCROLL:String = "SCROLL";

    /**
     * Identifies that the state of this object (e.g. disabled, selected,
     * rolled over, etc) is invalid and needs updating.
     */
    public static const STATE:String = "STATE";

    /**
     * Identifies that the content of this object (e.g. labels, source data,
     * etc) is invalid and needs updating.
     */
    public static const CONTENT:String = "CONTENT";

    /**
     * The stored width as set by callers.
     */
    protected var _width:Number;

    /**
     * The stored height as set by callers.
     */
    protected var _height:Number;

    private var waitingForRender:Boolean;
    private var handlingRender:Boolean;

    private var debug:Boolean = false;

    private var invalidTokens:Object;

    /**
     * Constructor.
     *
     * @param initialWidth   The initial value for width.
     * @param initialHeight  The initial value for height.
     */
    public function BaseDisplay(initialWidth:Number = 0, initialHeight:Number = 0)
    {
        invalidTokens = { };

        _width = initialWidth;
        _height = initialHeight;
        addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage, false, 0, true);
    }

    /**
     * The width at which this object should be drawn.
     */
    public override function get width():Number
    {
        return _width;
    }

    public override function set width(new_width:Number):void
    {
        _width = new_width;
        invalidate(SIZE);
    }


    /**
     * The height at which this object should be drawn.
     */
    public override function get height():Number
    {
        return _height;
    }

    public override function set height(new_height:Number):void
    {
        _height = new_height;
        invalidate(SIZE);
    }

    /**
     * Convenience method to set width and height at once.
     */
    public function setSize(w:Number, h:Number):void
    {
        _width = w;
        _height = h;
        invalidate(SIZE);
    }

    /**
     * Invalidates <code>SIZE</code> and calls draw immediately.  This is
     * necessary when a parent BaseDisplay is already drawing in response to
     * an invalidation, as invalidations aren't re-entrant.
     */
    public function forceRedraw():void
    {
        invalidate(SIZE);
        draw();
    }

    /**
     * Called when any aspect of the BaseDisplay is marked as invalid.
     * Subclasses should override this with code to update the display and
     * validate all identifiers.  The base implementation does nothing.
     */
    protected function draw():void
    {
    }

    /**
     * Returns the width as calculated by Flash Player.
     */
    protected function getDisplayWidth():Number
    {
        return super.width;
    }

    /**
     * Returns the height as calculated by Flash Player.
     */
    protected function getDisplayHeight():Number
    {
        return super.height;
    }

    /**
     * Convenience method to set the size on a child DisplayObject.  This
     * also detects whether the DisplayObject is a BaseDisplay, and if so,
     * forces it to redraw.
     */
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

    /**
     * Convenience method to call the <code>forceRedraw()</code> method of
     * one or more BaseDisplays.
     */
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

    /**
     * Flags a certain visual state (identified by a String) as needing
     * validation, then triggers an invalidation if one is not already
     * queued.
     */
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

    /**
     * Flags a certain visual state (identified by a String) as valid.
     * Should be called after the <code>draw()</code> method has updated the
     * display's appearance to match its state.
     */
    protected function validate(token:String):void
    {
        delete invalidTokens[token];
    }

    /**
     * Query if a certain visual state is invalidated.
     */
    protected function isInvalid(token:String):Boolean
    {
        return invalidTokens[token] === true;
    }

    /**
     * Query if a certain visual state is up to date.
     */
    protected function isValid(token:String):Boolean
    {
        return invalidTokens[token] !== true;
    }

    /**
     * Convenience method that is called in response to this BaseDisplay's
     * ADDED_TO_STAGE event.  The base implementation does nothing.
     */
    protected function onAddedToStage(event:Event):void
    {
    }

    /**
     * Convenience method that is called in response to this BaseDisplay's
     * REMOVED_FROM_STAGE event.  The base implementation does nothing.
     */
    protected function onRemovedFromStage(event:Event):void
    {
    }

    /**
     * Returns the class and display name of this object.
     */
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
