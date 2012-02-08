package org.yellcorp.lib.error.chain
{
import org.yellcorp.lib.core.ReflectUtil;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.utils.getQualifiedClassName;


public class IndirectErrorEvent extends ErrorEvent
{
    protected var _cause:*;

    public function IndirectErrorEvent(type:String, cause:*, bubbles:Boolean = false, cancelable:Boolean = false, text:String = null)
    {
        _cause = cause;
        super(type, bubbles, cancelable, text || ErrorChainUtil.extractErrorText(_cause));
    }

    public function get cause():*
    {
        return _cause;
    }

    public function getChain():Array
    {
        return ErrorChainUtil.getErrorChain(this);
    }

    public override function clone():Event
    {
        return new (Object(this).constructor as Class)(type, _cause, bubbles, cancelable, text);
    }

    public override function toString():String
    {
        return formatToString(
            ReflectUtil.getShortClassName(getQualifiedClassName(this)),
            "text");
    }
}
}
