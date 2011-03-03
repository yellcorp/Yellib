package org.yellcorp.net
{
import org.yellcorp.events.XMLParseErrorEvent;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;


[Event(name="xmlParseError", type="org.yellcorp.events.XMLParseErrorEvent")]

/**
 * A subclass of flash.net.URLLoader which will automatically attempt to
 * parse received data as XML if its dataFormat property is set to "xml".
 *
 * If data is successfully loaded, but fails XML parsing, the normal
 * Event.COMPLETE event will be suppressed and an
 * XMLParseErrorEvent.XML_PARSE_ERROR will be dispatched instead.
 *
 */

[Event(name="xmlParseError", type="org.yellcorp.events.XMLParseErrorEvent")]
public class URLXMLLoader extends URLLoader
{
    private var inProgress:Boolean;
    private var privateLoader:URLLoader;

    public function URLXMLLoader(request:URLRequest = null)
    {
        super(null);
        dataFormat = URLXMLLoaderDataFormat.XML;
        privateLoader = new URLLoader();
        if (request)
        {
            load(request);
        }
    }

    public override function close():void
    {
        privateLoader.close();
    }

    public override function load(request:URLRequest):void
    {
        if (dataFormat == URLXMLLoaderDataFormat.XML)
        {
            privateLoader.dataFormat = URLLoaderDataFormat.TEXT;
        }
        else
        {
            privateLoader.dataFormat = dataFormat;
        }

        bytesLoaded = 0;
        bytesTotal = 0;
        data = null;
        listen(privateLoader);
        privateLoader.load(request);
    }

    private function onComplete(event:Event):void
    {
        var parsedXML:XML;
        var parseError:Error;

        unlisten(privateLoader);

        if (dataFormat == URLXMLLoaderDataFormat.XML)
        {
            try {
                parsedXML = XML(privateLoader.data);
                data = parsedXML;
            }
            catch (error:TypeError)
            {
                parseError = error;
            }
            catch (error:SyntaxError)
            {
                parseError = error;
            }

            if (parseError)
            {
                dispatchParseError(parseError, privateLoader.data);
            }
            else
            {
                dispatchEvent(event);
            }
        }
        else
        {
            data = privateLoader.data;
            dispatchEvent(event);
        }
    }

    private function onError(event:Event):void
    {
        unlisten(privateLoader);
        dispatchEvent(event);
    }

    private function onProgress(event:ProgressEvent):void
    {
        bytesLoaded = privateLoader.bytesLoaded;
        bytesTotal = privateLoader.bytesTotal;
        dispatchEvent(event);
    }

    private function dispatchParseError(error:Error, faultText:String):void
    {
        var event:XMLParseErrorEvent = new XMLParseErrorEvent(
                XMLParseErrorEvent.XML_PARSE_ERROR,
                false, false, error.message, faultText);

        dispatchEvent(event);
    }

    private function listen(loader:URLLoader):void
    {
        inProgress = true;

        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        loader.addEventListener(Event.COMPLETE, onComplete);
        loader.addEventListener(Event.OPEN, dispatchEvent);
    }

    private function unlisten(loader:URLLoader):void
    {
        inProgress = false;

        loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
        loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        loader.removeEventListener(Event.COMPLETE, onError);
        loader.removeEventListener(Event.OPEN, dispatchEvent);
    }
}
}
