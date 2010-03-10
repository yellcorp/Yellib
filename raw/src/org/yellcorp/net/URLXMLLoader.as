package org.yellcorp.net
{
import org.yellcorp.events.XMLParseErrorEvent;

import flash.events.Event;
import flash.net.URLLoader;
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
public class URLXMLLoader extends URLLoader
{
    public function URLXMLLoader(request:URLRequest = null)
    {
        super(request);
        dataFormat = URLXMLLoaderDataFormat.XML;
        addEventListener(Event.COMPLETE, onComplete, false, int.MAX_VALUE, true);
    }

    private function onComplete(event:Event):void
    {
        var parsedXML:XML;
        if (dataFormat == URLXMLLoaderDataFormat.XML)
        {
            try {
                parsedXML = XML(data);
                data = parsedXML;
            }
            catch (error:TypeError)
            {
                dispatchParseError(event, error);
            }
            catch (error:SyntaxError)
            {
                dispatchParseError(event, error);
            }
        }
    }

    private function dispatchParseError(event:Event, error:Error):void
    {
        event.stopImmediatePropagation();
        // should this.data be cleared?
        dispatchEvent(new XMLParseErrorEvent(XMLParseErrorEvent.XML_PARSE_ERROR, false, false, error.message, data));
    }
}
}
