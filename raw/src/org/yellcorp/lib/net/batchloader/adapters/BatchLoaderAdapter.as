package org.yellcorp.lib.net.batchloader.adapters
{
public interface BatchLoaderAdapter
{
    function get uri():String;
    function start(callback:BatchLoaderCallback):void;
    function cancel():void;
    function dispose():void;
}
}
