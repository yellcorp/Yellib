package org.yellcorp.net
{
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.net.URLRequest;


public class MultiLoaderErrorEvent extends ErrorEvent
{
    public static const MULTILOADER_ERROR:String = "MULTILOADER_ERROR";

    public var cause:ErrorEvent;
    public var id:String;
    public var url:URLRequest;

    public function MultiLoaderErrorEvent(type:String, initCause:ErrorEvent, initId:String, initUrl:URLRequest)
    {
        cause = ErrorEvent(initCause.clone());
        id = initId;
        url = initUrl;
        super(type, false, false, initCause.text);
    }

    public override function clone():Event
    {
        return new MultiLoaderErrorEvent(type, cause, id, url);
    }

    public override function toString():String
    {
        return "[MultiLoaderErrorEvent type=" + type +
               " cause=" + cause.type +
               " id=" + id +
               " url=" + url +
               " text=" + text +
               "]";
    }
}
}
