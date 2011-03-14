package org.yellcorp.lib.ui.scrollbar
{
import flash.display.InteractiveObject;


public interface ScrollBarSkin
{
    function createTrack():InteractiveObject;
    function createCursor():InteractiveObject;
    function createDecrementButton():InteractiveObject;
    function createIncrementButton():InteractiveObject;
}
}
