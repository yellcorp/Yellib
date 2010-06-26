package org.yellcorp.util
{
public class KeyChord
{
    public static const SHIFT:uint = 1;
    public static const CTRL:uint = 2;
    public static const ALT:uint = 4;

    public static function matchEventKeys(keyOrMouseEvent:Object, mustBeDown:uint, mustBeUp:uint = 0):Boolean
    {
        var testBits:uint = 0;

        if (keyOrMouseEvent.shiftKey) testBits |= SHIFT;
        if (keyOrMouseEvent.ctrlKey)  testBits |= CTRL;
        if (keyOrMouseEvent.altKey)   testBits |= ALT;

        return ((mustBeDown &  testBits) == mustBeDown) &&
               ((mustBeUp   & ~testBits) == mustBeUp);
    }
}
}
