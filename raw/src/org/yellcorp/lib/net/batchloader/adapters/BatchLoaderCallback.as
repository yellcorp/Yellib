package org.yellcorp.lib.net.batchloader.adapters
{
public interface BatchLoaderCallback
{
    function complete():void;
    function httpStatus(statusCode:int):void;
    function progress(bytesLoaded:uint, bytesTotal:uint):void;
    function error(error:*):void;
}
}
