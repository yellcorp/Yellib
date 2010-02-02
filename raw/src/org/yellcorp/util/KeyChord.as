package org.yellcorp.util
{
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;


public class KeyChord
{
    public static const SHIFT:uint = 1;
    public static const CTRL:uint = 2;
    public static const ALT:uint = 4;

    public static function matchEventKeys(keyOrMouseEvent:Event, mustBeDown:uint, mustBeUp:uint = 0):Boolean
    {
        var testBits:uint = 0;
        var ke:KeyboardEvent;
        var me:MouseEvent;

        if ((ke = keyOrMouseEvent as KeyboardEvent))
        {
            if (ke.shiftKey) testBits |= SHIFT;
            if (ke.ctrlKey)  testBits |= CTRL;
            if (ke.altKey)   testBits |= ALT;
        }
        else if ((me = keyOrMouseEvent as MouseEvent))
        {
            if (me.shiftKey) testBits |= SHIFT;
            if (me.ctrlKey)  testBits |= CTRL;
            if (me.altKey)   testBits |= ALT;
        }
        else
        {
            throw new ArgumentError("event must be a KeyboardEvent or a MouseEvent");
        }

        return ((mustBeDown &  testBits) == mustBeDown) &&
               ((mustBeUp   & ~testBits) == mustBeUp);
    }
}
}
