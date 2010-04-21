package org.yellcorp.debug.console
{
import org.yellcorp.ui.scrollbar.VerticalScrollBar;

import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.text.TextField;


public interface DebugConsoleSkin
{
    function createBackground():InteractiveObject;
    function createSizeHandle():Sprite;
    function createOutputField():TextField;
    function createOutputScrollBar():VerticalScrollBar;
    function createInputField():TextField;

    function get windowGutter():Number;
    function get controlGutter():Number;
}
}
