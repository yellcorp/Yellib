package org.yellcorp.lib.events
{
import flash.events.ErrorEvent;
import flash.events.Event;


/**
 * Represents an XML parse error encountered in an asynchronous operation.
 * Useful for classes that encapsulate Loaders, Sockets, etc.
 */
public class XMLParseErrorEvent extends ErrorEvent
{
    /**
     * Defines the value of the type property of an <code>xmlParseError</code> event object.
     *
     * @eventType xmlParseError
     */
    public static const XML_PARSE_ERROR:String = "xmlParseError";

    private var _data:String;

    public function XMLParseErrorEvent(
        type:String,
        bubbles:Boolean = false,
        cancelable:Boolean = false,
        text:String = "",
        data:String = "")
    {
        super(type, bubbles, cancelable, text);
        _data = data;
    }

    public override function clone():Event
    {
        return new XMLParseErrorEvent(type, bubbles, cancelable, text, data);
    }

    public override function toString():String
    {
        return formatToString("XMLParseErrorEvent", "type", "text");
    }

    /**
     * A copy of the data that failed XML parsing.
     */
    public function get data():String
    {
        return _data;
    }
}
}
