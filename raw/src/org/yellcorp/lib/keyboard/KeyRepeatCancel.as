package org.yellcorp.lib.keyboard
{
import org.yellcorp.lib.core.Disposable;

import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;


public class KeyRepeatCancel extends EventDispatcher implements Disposable
{
    private var eventSource:EventDispatcher;
    private var keysDown:Object;

    public function KeyRepeatCancel(listenTo:EventDispatcher)
    {
        keysDown = new Object();

        eventSource = listenTo;
        eventSource.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
        eventSource.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
    }

    public function dispose():void
    {
        eventSource.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        eventSource.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        eventSource = null;
    }

    private function onKeyDown(event:KeyboardEvent):void
    {
        if (!isKeyDown(event))
        {
            setKey(event, true);
            dispatchEvent(event);
        }
    }

    private function onKeyUp(event:KeyboardEvent):void
    {
        setKey(event, false);
        dispatchEvent(event);
    }

    private function isKeyDown(event:KeyboardEvent):Boolean
    {
        return keysDown[event.keyCode];
    }

    private function setKey(event:KeyboardEvent, isDown:Boolean):void
    {
        if (isDown)
            keysDown[event.keyCode] = true;
        else
            delete keysDown[event.keyCode];
    }
}
}
