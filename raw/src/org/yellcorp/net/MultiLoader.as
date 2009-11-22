package org.yellcorp.net
{
import org.yellcorp.binary.ByteUtils;
import org.yellcorp.map.OrderedStringMap;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.utils.ByteArray;


[Event(name="complete", type="flash.events.Event")]
[Event(name="MULTILOADER_ERROR", type="org.yellcorp.net.MultiLoaderErrorEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]

public class MultiLoader extends EventDispatcher
{
    public var reportUnknownProgress:Boolean = false;

    private var records:OrderedStringMap;
    private var recordPointer:uint;
    private var openCount:uint;

    private var status:Object;
    private var xmls:Object;

    private var started:Boolean;

    private var _concurrency:uint = 4;

    private var responseText:Object;
    private var responseBin:Object;
    private var responseVars:Object;
    private var responseXML:Object;

    public function MultiLoader()
    {
        super(null);
        clear();
    }

    public function get concurrency():uint
    {
        return _concurrency;
    }

    public function set concurrency(newConcurrency:uint):void
    {
        _concurrency = newConcurrency;
        if (started) fillQ();
    }

    public function addTextRequest(id:String, url:URLRequest):void
    {
        addRequest(id, url, URLLoaderDataFormat.TEXT);
    }

    public function addBinaryRequest(id:String, url:URLRequest):void
    {
        addRequest(id, url, URLLoaderDataFormat.BINARY);
    }

    public function addVariablesRequest(id:String, url:URLRequest):void
    {
        addRequest(id, url, URLLoaderDataFormat.VARIABLES);
    }

    public function addXMLRequest(id:String, url:URLRequest):void
    {
        addRequest(id, url, URLLoaderDataFormat.TEXT);
        xmls[id] = true;
    }

    public function start():void
    {
        started = true;
        fillQ();
    }

    public function getTextResponse(id:String):String
    {
        return getResponse(responseText, id);
    }

    public function getBinaryResponse(id:String):ByteArray
    {
        return getResponse(responseBin, id);
    }

    public function getVariablesResponse(id:String):URLVariables
    {
        return getResponse(responseVars, id);
    }

    public function getXMLResponse(id:String):XML
    {
        return getResponse(responseXML, id);
    }

    private function getResponse(source:Object, id:String):*
    {
        var val:*;

        val = source[id];

        if (!val)
        {
            throw new ArgumentError("No request with id \"" + id + "\"");
        }
        else
        {
            return val;
        }
    }

    public function destroy():void
    {
        var record:MultiLoaderRecord;
        //var bkey:String;

        while (records.length > 0)
        {
            record = records.pop();
            unlisten(record);
            record.destroy();
        }

        // only in FP10+!
        /*
        for (bkey in responseBin)
        {
            responseBin[bkey].clear();
        }
         */
        reset();
    }

    private function clear():void
    {
        reset();
        records = new OrderedStringMap();
    }

    private function reset():void
    {
        records = null;

        openCount = 0;
        recordPointer = 0;

        status = { };
        xmls = { };

        responseText = { };
        responseBin  = { };
        responseVars = { };
        responseXML =  { };
    }

    private function addRequest(id:String, url:URLRequest, format:String):void
    {
        var loader:URLLoader;

        loader = new URLLoader();
        loader.dataFormat = format;

        records.setKey(id, new MultiLoaderRecord(id, loader, url));
    }

    private function hasPendingLoads():Boolean
    {
        return recordPointer < records.length;
    }

    private function fillQ():void
    {
        while (openCount < _concurrency && hasPendingLoads())
        {
            startNext();
        }
    }

    private function startNext():void
    {
        var nextRecord:MultiLoaderRecord;

        nextRecord = records.getValueAtIndex(recordPointer);

        listen(nextRecord);

        nextRecord.loader.load(nextRecord.request);

        recordPointer++;
        openCount++;
    }

    private function listen(record:MultiLoaderRecord):void
    {
        record.addEventListener(Event.COMPLETE, onComplete);

        record.addEventListener(IOErrorEvent.IO_ERROR, onError);
        record.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

        record.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        record.addEventListener(ProgressEvent.PROGRESS, onProgress);

        record.addEventListener(Event.COMPLETE, onTerminate);
        record.addEventListener(IOErrorEvent.IO_ERROR, onTerminate);
        record.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTerminate);
    }

    private function unlisten(record:MultiLoaderRecord):void
    {
        record.removeEventListener(Event.COMPLETE, onComplete);

        record.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        record.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

        record.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        record.removeEventListener(ProgressEvent.PROGRESS, onProgress);

        record.removeEventListener(Event.COMPLETE, onTerminate);
        record.removeEventListener(IOErrorEvent.IO_ERROR, onTerminate);
        record.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onTerminate);
    }

    private function onComplete(event:Event):void
    {
        trace("MultiLoader.onComplete(event)");
        var record:MultiLoaderRecord = MultiLoaderRecord(event.target);
        copyResponse(record.id);
    }

    private function copyResponse(id:String):void
    {
        var record:MultiLoaderRecord = MultiLoaderRecord(records.getKey(id));
        var response:* = record.loader.data;

        switch (record.loader.dataFormat)
        {
            case URLLoaderDataFormat.TEXT :
                if (xmls[id])
                {
                    responseXML[id] = XML(response);
                }
                else
                {
                    responseText[id] = String(response);
                }
                break;

            case URLLoaderDataFormat.BINARY :
                responseBin[id] = ByteUtils.cloneByteArray(response);
                break;

            case URLLoaderDataFormat.VARIABLES :
                responseVars[id] = URLVariables(response);
                break;
        }
    }

    private function onError(event:ErrorEvent):void
    {
        var record:MultiLoaderRecord = MultiLoaderRecord(event.target);
        var error:MultiLoaderErrorEvent;

        error = new MultiLoaderErrorEvent(MultiLoaderErrorEvent.MULTILOADER_ERROR,
                                          event, record.id, record.request);

        dispatchEvent(error);
    }

    private function onHttpStatus(event:HTTPStatusEvent):void
    {
        var record:MultiLoaderRecord = MultiLoaderRecord(event.target);

        status[record.id] = event.status;
    }

    private function onProgress(event:ProgressEvent):void
    {
        //var record:MultiLoaderRecord = MultiLoaderRecord(event.target);

        //loads[record.id] = event.bytesLoaded;
        //totals[record.id] = event.bytesTotal;

        dispatchProgress();
    }

    private function dispatchProgress():void
    {
        var calcTotal:uint;
        var calcLoaded:uint;

        calcTotal = bytesTotal;

        if (calcTotal > 0 || reportUnknownProgress)
        {
            calcLoaded = bytesLoaded;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, calcLoaded, calcTotal));
        }
    }

    public function get bytesTotal():uint
    {
        var i:int;
        var sum:uint = 0;
        var cRecord:MultiLoaderRecord;
        var total:int = 0;

        for (i = 0; i < records.length; i++)
        {
            cRecord = records.getValueAtIndex(i);
            total = cRecord.loader.bytesTotal;

            if (total <= 0)
            {
                sum = 0;
                break;
            }
            else
            {
                sum += total;
            }
        }

        return sum;
    }

    public function get bytesLoaded():uint
    {
        var i:int;
        var sum:uint = 0;
        var cRecord:MultiLoaderRecord;

        for (i = 0; i < records.length; i++)
        {
            cRecord = records.getValueAtIndex(i);
            sum += cRecord.loader.bytesLoaded;
        }

        return sum;
    }

    private function onTerminate(event:Event):void
    {
        trace("MultiLoader.onTerminate(event)");

        unlisten(MultiLoaderRecord(event.target));
        openCount--;

        if (hasPendingLoads())
        {
            fillQ();
        }
        else if (openCount == 0)
        {
            dispatchEvent(new Event(Event.COMPLETE, false, false));
        }
    }
}
}
