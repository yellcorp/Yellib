package org.yellcorp.listeners
{
import flash.display.Loader;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;


public class LoaderListenerProxy
{
    private var loader:Loader;
    private var listener:LoaderListener;
    private var _active:Boolean = false;

    public function LoaderListenerProxy(loader:Loader, listener:LoaderListener, startActive:Boolean = true)
    {
        this.loader = loader;
        this.listener = listener;

        active = startActive;
    }

    public function get active():Boolean
    {
        return _active;
    }

    public function set active(new_active:Boolean):void
    {
        if (_active !== new_active)
        {
            _active = new_active;
            if (_active)
            {
                addListeners();
            }
            else
            {
                removeListeners();
            }
        }
    }

    private function addListeners():void
    {
        loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, listener.onLoaderHttpStatus);
        loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, listener.onLoaderProgress);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, listener.onLoaderComplete);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, listener.onLoaderIOError);
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, listener.onLoaderSecurityError);
    }

    private function removeListeners():void
    {
        loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, listener.onLoaderHttpStatus);
        loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, listener.onLoaderProgress);
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, listener.onLoaderComplete);
        loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, listener.onLoaderIOError);
        loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, listener.onLoaderSecurityError);
    }
}
}
