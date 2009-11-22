package org.yellcorp.util
{
import flash.events.MouseEvent;


public class KeyChord
{
    public static const SHIFT:uint = 1;
    public static const CTRL:uint = 2;
    public static const ALT:uint = 4;

    public static function matchEventKeys(e:MouseEvent, mustBeDown:uint, mustBeUp:uint = 0):Boolean
    {
        var testBits:uint = 0;

        if (e.shiftKey) testBits |= SHIFT;
        if (e.ctrlKey)  testBits |= CTRL;
        if (e.altKey)   testBits |= ALT;

        return ((mustBeDown &  testBits) == mustBeDown) &&
               ((mustBeUp   & ~testBits) == mustBeUp);
    }
}
}
