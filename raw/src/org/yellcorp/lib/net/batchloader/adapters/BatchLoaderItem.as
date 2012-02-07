package org.yellcorp.lib.net.batchloader.adapters
{
import flash.events.IEventDispatcher;


// dispatches:
//  httpStatus
//  open
//  progress
//  complete
//  error
public interface BatchLoaderItem extends IEventDispatcher
{
    function start():void;
    function stop():void;
    function dispose():void;
    function get content():*;
}
}
