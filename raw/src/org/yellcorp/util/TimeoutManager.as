package org.yellcorp.util
{
import org.yellcorp.map.MapUtil;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;


/**
 * TimeoutManager is a class that manages single delayed function calls.
 * Each call is associated with an ID chosen by the user of this class.
 * Calls can be queried, replaced or cancelled by these IDs.  When calls
 * are invoked, their id and reference is removed.
 */
public class TimeoutManager
{
    private var timeouts:Object;

    public function TimeoutManager()
    {
        timeouts = { };
    }

    /**
     * Schedules a function call after an amount of time has passed.
     *
     * @param id        A user-defined id to associate this call with.  If
     *                  the TimeoutManager already has a delayed call with
     *                  this id, it is cancelled and replaced.
     * @param closure   The function to call.
     * @param delay     The time to wait before invoking the call. In
     *                  milliseconds.
     * @param arguments Arguments to pass to the function, when called.
     */
    public function setTimeoutIn(id:String, closure:Function, delay:Number, arguments:Array = null):void
    {
        var thunk:Function = function ():void { call(id); };
        var systemid:uint = setTimeout(thunk, delay);
        var record:Object = { clientid: id, systemid: systemid, thunk: thunk, closure: closure, delay: delay, arguments: arguments };
        cancelTimeout(id);
        timeouts[id] = record;
    }


    /**
     * Schedules a function call at a certain point in time.
     *
     * @param id        A user-defined id to associate this call with.  If
     *                  the TimeoutManager already has a delayed call with
     *                  this id, it is cancelled and replaced.
     * @param closure   The function to call.
     * @param callTime  The time at which to invoke the call.  If the date
     *                  is in the past, the function is not scheduled.
     * @param arguments Arguments to pass to the function, when called.
     *
     * @return <code>true</code> if the function was scheduled,
     *         <code>false</code> if the specified date is in the past.
     */
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


    /**
     * Queries the existence of a scheduled function call by id
     *
     * @param id The id to query
     *
     * @return <code>true</code> if there is a function waiting to be
     *         called by this id, <code>false</code> if there is no call
     *         or it has already been executed.
     */
    public function hasTimeout(id:String):Boolean
    {
        return timeouts.hasOwnProperty(id);
    }

    /**
     * Cancels a scheduled function call by id
     *
     * @param id The id to cancel
     *
     * @return <code>true</code> if there was a function waiting, and was
     *         removed, <code>false</code> otherwise.
     */
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

    /**
     * Cancels all scheduled function calls.
     */
    public function cancelAll():void
    {
        var toRemove:Array = MapUtil.getKeys(timeouts);
        for each (var key:String in toRemove)
        {
            cancelTimeout(key);
        }
    }

    /**
     * Gets the function reference associated with an id
     *
     * @param id The id of the function to retrieve
     * @return A reference to the function, or null if id doesn't exist.
     */
    public function getClosureById(id:String):Function
    {
        return hasTimeout(id) ? timeouts[id].closure : null;
    }

    /**
     * Changes the function reference associated with an id
     *
     * @param id         The id of the function to change
     * @param newClosure The new function
     * @return <code>true</code> if the id exists and the function was
     *         changed, <code>false</code> otherwise.
     */
    public function setClosureById(id:String, newClosure:Function):Boolean
    {
        return replaceById(id, newClosure, -1, null);
    }

    /**
     * Gets the delay associated with an id.  Note that the value returned
     * is relative to the time the function was added, not necessarily the
     * current time.
     *
     * @param id The id of the function to retrieve
     * @return The delay in milliseconds, or Number.NaN if id doesn't exist.
     */
    public function getDelayById(id:String):Number
    {
        return hasTimeout(id) ? timeouts[id].delay : Number.NaN;
    }

    /**
     * Changes the delay associated with an id.  The new delay is
     * interpreted relative to the current time, not necessarily
     * the time the function was originally added.
     *
     * @param id         The id of the delay to change
     * @param newDelay   The new delay, in milliseconds
     * @return <code>true</code> if the id exists and the delay was
     *         changed, <code>false</code> otherwise.
     */
    public function setDelayById(id:String, newDelay:Number):Boolean
    {
        return replaceById(id, null, newDelay, null);
    }


    /**
     * Gets the delay associated with an id.  Note that the value returned
     * is relative to the time the function was added, not necessarily the
     * current time.
     *
     * @param id The id of the function to retrieve
     * @return The delay in milliseconds, or Number.NaN if id doesn't exist.
     */
    public function getArgumentsById(id:String):Array
    {
        return hasTimeout(id) ? timeouts[id].arguments : null;
    }


    /**
     * Changes the function arguments associated with an id.
     *
     * @param id           The id of the delay to change
     * @param newArguments The new arguments
     * @return <code>true</code> if the id exists and the arguments were
     *         changed, <code>false</code> otherwise.
     */
    public function setArgumentsById(id:String, newArguments:Array):Boolean
    {
        return replaceById(id, null, -1, newArguments);
    }


    /**
     * Returns a list of function ids and their delays as an Array of Strings.
     */
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
