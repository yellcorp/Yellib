package org.yellcorp.lib.net.batchloader.events
{
import flash.events.Event;


public class BatchLoaderProgressEvent extends BatchLoaderEvent
{
    public static const BATCH_PROGRESS:String = "batchProgress";

    private var _bytesLoaded:Number;
    private var _bytesTotal:Number;
    private var _progress:Number;

    public function BatchLoaderProgressEvent(type:String, bytesLoaded:Number, bytesTotal:Number, progress:Number, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _bytesLoaded = bytesLoaded;
        _bytesTotal = bytesTotal;
        _progress = progress;
    }

    public function get bytesLoaded():Number
    {
        return _bytesLoaded;
    }

    public function get bytesTotal():Number
    {
        return _bytesTotal;
    }

    public function get progress():Number
    {
        return _progress;
    }

    public override function clone():Event
    {
        return new BatchLoaderProgressEvent(type, _bytesLoaded, _bytesTotal, _progress, bubbles, cancelable);
    }

    public override function toString():String
    {
        return formatToString("BatchLoaderProgressEvent", "type", "bytesLoaded", "bytesTotal", "progress");
    }
}
}
