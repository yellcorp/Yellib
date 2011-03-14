package org.yellcorp.lib.net.multiloader.core
{
import org.yellcorp.lib.error.AbstractCallError;
import org.yellcorp.lib.net.multiloader.MultiLoader;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;


public class MultiLoaderItem
{
    ml_internal var callback:MultiLoader;
    private var _httpStatusHistory:Array;
    private var _request:URLRequest;

    public function MultiLoaderItem(request:URLRequest)
    {
        _request = request;
        _httpStatusHistory = [ ];
    }

    public function destroy():void
    {
    }

    public function get request():URLRequest
    {
        return _request;
    }

    public function get httpStatusHistory():Array
    {
        return _httpStatusHistory.slice();
    }

    public function get lastHttpStatus():int
    {
        return _httpStatusHistory[_httpStatusHistory.length - 1];
    }

    public function get bytesLoaded():uint
    {
        throw new AbstractCallError();
    }

    public function get bytesTotal():uint
    {
        throw new AbstractCallError();
    }

    public function get bytesTotalKnown():Boolean
    {
        throw new AbstractCallError();
    }

    ml_internal function load():void
    {
        startLoad();
    }

    protected function startLoad():void
    {
        throw new AbstractCallError();
    }

    protected function onComplete(event:Event):void
    {
        ml_internal::callback.ml_internal::onComplete(this);
    }

    protected function onOpen(event:Event):void
    {
        ml_internal::callback.ml_internal::onOpen(this);
    }

    protected function onStatus(event:HTTPStatusEvent):void
    {
        _httpStatusHistory.push(event.status);
        ml_internal::callback.ml_internal::onStatus(this, event.status);
    }

    protected function onProgress(event:ProgressEvent):void
    {
        ml_internal::callback.ml_internal::onProgress(this, event.bytesLoaded, event.bytesTotal);
    }

    protected function onAsyncError(event:ErrorEvent):void
    {
        ml_internal::callback.ml_internal::onAsyncError(this, event);
    }
}
}
