package org.yellcorp.lib.keyboard
{
import flash.events.KeyboardEvent;


public class KeyUtil
{
    public static const SHIFT:uint = 1;
    public static const CTRL:uint = 2;
    public static const ALT:uint = 4;

    public static function matchEventKeyMask(keyOrMouseEvent:Object,
        mustBeDown:uint, mustBeUp:uint = 0):Boolean
    {
        var testBits:uint = 0;

        if (keyOrMouseEvent.shiftKey) testBits |= SHIFT;
        if (keyOrMouseEvent.ctrlKey)  testBits |= CTRL;
        if (keyOrMouseEvent.altKey)   testBits |= ALT;

        return ((mustBeDown &  testBits) == mustBeDown) &&
               ((mustBeUp   & ~testBits) == mustBeUp);
    }

    public static function matchEventKeyChord(keyOrMouseEvent:Object,
        shift:Boolean, ctrl:Boolean, alt:Boolean):Boolean
    {
        return (shift == keyOrMouseEvent.shiftKey &&
                ctrl  == keyOrMouseEvent.ctrlKey  &&
                alt   == keyOrMouseEvent.altKey);
    }

    public static function matchEventCharacter(event:KeyboardEvent,
        char:String,
        shift:Boolean = false,
        ctrl:Boolean = false,
        alt:Boolean = false):Boolean
    {
        return event.charCode == char.charCodeAt(0) &&
            matchEventKeyChord(event, shift, ctrl, alt);
    }

    public static function matchEventKeyCode(event:KeyboardEvent,
        keyCode:int,
        shift:Boolean = false,
        ctrl:Boolean = false,
        alt:Boolean = false):Boolean
    {
        return event.keyCode == keyCode &&
            matchEventKeyChord(event, shift, ctrl, alt);
    }
}
}
