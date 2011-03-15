package org.yellcorp.lib.error.chain
{
import org.yellcorp.lib.core.ReflectUtil;

import flash.events.AsyncErrorEvent;
import flash.events.TextEvent;
import flash.utils.getQualifiedClassName;


public class ChainUtil
{
    public static function extractErrorText(errorObject:*):String
    {
        if (!errorObject)
        {
            return "";
        }
        else if (errorObject is IndirectError)
        {
            return IndirectError(errorObject).message ||
                   extractErrorText(IndirectError(errorObject).cause);
        }
        else if (errorObject is Error)
        {
            return Error(errorObject).message;
        }
        else if (errorObject is AsyncErrorEvent)
        {
            return AsyncErrorEvent(errorObject).text ||
                   extractErrorText(AsyncErrorEvent(errorObject).error);
        }
        else if (errorObject is TextEvent)
        {
            return TextEvent(errorObject).text;
        }
        else
        {
            return ReflectUtil.getShortClassName(getQualifiedClassName(errorObject));
        }
    }

    public static function getErrorChain(errorObject:*):Array
    {
        var stackTrace:String;
        var chain:Array = [ ];

        while (errorObject)
        {
            if (errorObject is Error)
            {
                stackTrace = Error(errorObject).getStackTrace();
            }
            else
            {
                stackTrace = "";
            }
            chain.push(new ErrorDescriptor(errorObject, extractErrorText(errorObject), stackTrace));

            if (errorObject is IndirectError)
            {
                errorObject = IndirectError(errorObject).cause;
            }
            else if (errorObject is IndirectErrorEvent)
            {
                errorObject = IndirectErrorEvent(errorObject).cause;
            }
            else
            {
                break;
            }
        }
        return chain;
    }
}
}
