package wip.yellcorp.lib.debug
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;


public class DiagnosticLoader extends EventDispatcher
{
    private var messages:Array;
    private var url:URLRequest;
    private var loader:URLLoader;
    private var progressEventCount:int;
    private var _httpStatus:int;

    public function DiagnosticLoader()
    {
        messages = [];
    }

    public function test(untypedURL:*):void
    {
        if (url is URLRequest)
        {
            url = URLRequest(untypedURL);
        }
        else
        {
            if (url is String)
            {
                log("URL is String: creating URLRequest");
            }
            else
            {
                log("URL is type "+(typeof url)+": converting to String");
            }
            url = new URLRequest(String(url));
        }

        progressEventCount = 0;
        _httpStatus = 0;
        loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        listen(loader);
    }

    private function diagnoseContent(file:ByteArray):void
    {
        var type:String = "";

        if (matchBytes(file, 0, [0xFF, 0xD8, 0xFF, 0xE0]))
        {
            type = "JPEG/JFIF image";
        }
        else if (matchBytes(file, 0, [0xFF, 0xD8, 0xFF, 0xE1]))
        {
            type = "JPEG/EXIF image";
        }
        else if (matchBytes(file, 0, ["GIF8", -1, "a"]))
        {
            type = "GIF image";
        }
        else if (matchBytes(file, 0, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]))
        {
            type = "PNG image";
        }
        else if (matchBytes(file, 0, ["FWS"]))
        {
            type = "SWF file (uncompressed)";
        }
        else if (matchBytes(file, 0, ["CWS"]))
        {
            type = "SWF file (compressed)";
        }
        else if (matchBytes(file, 0, ["FLV"]))
        {
            type = "FLV video";
        }
    }

    private function matchBytes(bin:ByteArray, offset:int, sequence:Array):Boolean
    {
        var i:int;
        var j:int;
        var expectByte:int;
        var actualByte:int;
        var intSequence:Array;

        intSequence = new Array();
        for (i=0; i < sequence.length; i++)
        {
            if (sequence[i] is String)
            {
                for (j=0; j<sequence[i].length; j++)
                {
                    intSequence.push(sequence[i].charCodeAt(j));
                }
            }
            else
            {
                intSequence.push(sequence[i]);
            }
        }

        if (offset < 0) offset += bin.length;

        bin.position = offset;

        for (i=0; i < intSequence.length; i++)
        {
            expectByte = intSequence[i];
            if (expectByte >= 0)
            {
                actualByte = bin.readUnsignedByte();
                if (actualByte != expectByte)
                {
                    return false;
                }
            }
        }

        return true;
    }

    private function result():void
    {
        unlisten(loader);
        dispatchEvent(new Event(Event.COMPLETE, false, false));
    }

    private function onProgress(event:ProgressEvent):void
    {
        progressEventCount++;
    }

    private function onOpen(event:Event):void
    {
        log(event.type);
    }

    private function onError(event:IOErrorEvent):void
    {
        log(event.type + " " + event.text);
        result();
    }

    private function onStatus(event:HTTPStatusEvent):void
    {
        _httpStatus = event.status;
        log(event.type + " " + event.status);
    }

    private function onComplete(event:Event):void
    {
        log(event.type);
        diagnoseContent(ByteArray(loader.data));
        result();
    }

    private function listen(ed:EventDispatcher):void
    {
        ed.addEventListener(Event.COMPLETE, onComplete);
        ed.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        ed.addEventListener(IOErrorEvent.IO_ERROR, onError);
        ed.addEventListener(Event.OPEN, onOpen);
        ed.addEventListener(ProgressEvent.PROGRESS, onProgress);
        ed.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }

    private function unlisten(ed:EventDispatcher):void
    {
        ed.removeEventListener(Event.COMPLETE, onComplete);
        ed.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        ed.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        ed.removeEventListener(Event.OPEN, onOpen);
        ed.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        ed.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }

    private function log(message:String):void
    {
        messages.push(message);
    }

    public function get httpStatus():int
    {
        return _httpStatus;
    }
}
}
