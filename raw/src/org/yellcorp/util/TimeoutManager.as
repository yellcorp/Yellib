package org.yellcorp.util
{
import org.yellcorp.map.MapUtil;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;


public class TimeoutManager
{
    private var timeouts:Object;

    public function TimeoutManager()
    {
        timeouts = { };
    }

    public function setTimeoutIn(id:String, closure:Function, delay:Number, arguments:Array = null):void
    {
        var thunk:Function = function ():void { call(id); };
        var systemid:uint = setTimeout(thunk, delay);
        var record:Object = { clientid: id, systemid: systemid, thunk: thunk, closure: closure, delay: delay, arguments: arguments };
        cancelTimeout(id);
        timeouts[id] = record;
    }

    public function setTimeoutAt(id:String, closure:Function, callTime:Date, arguments:Array = null):Boolean
    {
        var now:Date = new Date();
        if (now.time <= callTime.time)
        {
            setTimeoutIn(id, closure, callTime.time - now.time, arguments);
            return true;
        }
        else
        {
            return false;
        }
    }

    public function hasTimeout(id:String):Boolean
    {
        return timeouts.hasOwnProperty(id);
    }

    public function cancelTimeout(id:String):Boolean
    {
        var oldRecord:Object;
        if (hasTimeout(id))
        {
            oldRecord = timeouts[id];
            delete timeouts[id];
            clearTimeout(oldRecord.systemid);
            return true;
        }
        else
        {
            return false;
        }
    }

    public function cancelAll():void
    {
        var toRemove:Array = MapUtil.getKeys(timeouts);
        for each (var key:String in toRemove)
        {
            cancelTimeout(key);
        }
    }

    public function getClosureById(id:String):Function
    {
        return hasTimeout(id) ? timeouts[id].closure : null;
    }

    public function setClosureById(id:String, newClosure:Function):Boolean
    {
        return replaceById(id, newClosure, -1, null);
    }

    public function getDelayById(id:String):Number
    {
        return hasTimeout(id) ? timeouts[id].delay : Number.NaN;
    }

    public function setDelayById(id:String, newDelay:Number):Boolean
    {
        return replaceById(id, null, newDelay, null);
    }

    public function getArgumentsById(id:String):Array
    {
        return hasTimeout(id) ? timeouts[id].arguments : null;
    }

    public function setArgumentsById(id:String, newArguments:Array):Boolean
    {
        return replaceById(id, null, -1, newArguments);
    }

    public function dump():String
    {
        var linebuf:Array = [ ];
        for (var k:String in timeouts)
        {
            linebuf.push(k + ": " + (timeouts[k].delay / 1000));
        }
        return linebuf.join("\n");
    }

    private function replaceById(id:String, closure:Function, delay:Number, arguments:Array):Boolean
    {
        var oldRecord:Object;
        var newDelay:Number;
        var newClosure:Function;
        var newArguments:Array;
        if (hasTimeout(id))
        {
            oldRecord = timeouts[id];
            newClosure = closure !== null ? closure : oldRecord.closure;
            newDelay = delay >= 0 ? delay : oldRecord.delay;
            newArguments = arguments !== null ? copyArray(arguments) : copyArray(oldRecord.arguments);
            setTimeoutIn(id, newClosure, newDelay, newArguments);
            return true;
        }
        else
        {
            return false;
        }
    }

    private function call(id:String):void
    {
        var record:Object = timeouts[id];
        var args:Array = record.arguments || [ ];
        var func:Function = record.closure;
        if (record)
        {
            delete timeouts[id];
            func.apply(null, args);
        }
        else
        {
            throw new Error("Internal error: no record with id " + id);
        }
    }

    private static function copyArray(arguments:Array):Array
    {
        return arguments ? arguments.slice() : arguments;
    }
}
}
