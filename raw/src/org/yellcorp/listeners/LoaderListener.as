package org.yellcorp.listeners
{
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;


public interface LoaderListener
{
    function onLoaderHttpStatus(event:HTTPStatusEvent):void;
    function onLoaderProgress(event:ProgressEvent):void;
    function onLoaderComplete(event:Event):void;
    function onLoaderIOError(event:IOErrorEvent):void;
    function onLoaderSecurityError(event:SecurityErrorEvent):void;
}
}
