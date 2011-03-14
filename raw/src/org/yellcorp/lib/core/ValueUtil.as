package org.yellcorp.lib.core
{
/**
 * Helper functions for turning null or undefined values into something more useful.
 */
public class ValueUtil
{
    /**
     * Returns the first argument that isn't <code>null</code> or
     * <code>undefined</code>.
     */
    public static function firstNonNull(... args):*
    {
        for (var i:int = 0; i < args.length; i++)
        {
            if (args[i] != null) return args[i];
        }
        return null;
    }

    /**
     * Returns the first argument that isn't <code>NaN</code>,
     * <code>Infinity</code> or <code>-Infinity</code>.
     */
    public static function firstFinite(... numbers):Number
    {
        for (var i:int = 0; i < numbers.length; i++)
        {
            if (isFinite(numbers[i])) return numbers[i];
        }
        return Number.NaN;
    }

    /**
     * Tries to access a property on an object, with default values
     * returned if the object or property doesn't exist.
     *
     * @param object          The object to evaluate the property on.
     * @param property        The property to evaluate.
     * @param noPropertyValue The value to return if
     *                        <code>object[property]</code> doesn't exist.
     * @param noObjectValue   The value to return if <code>object</code> is
     *                        <code>null</code> or <code>undefined</code>.
     */
    public static function getProperty(object:Object, property:*, noPropertyValue:* = null, noObjectValue:* = null):*
    {
        if (object)
        {
            if (object.hasOwnProperty(property))
            {
                return object[property];
            }
            else
            {
                return noPropertyValue;
            }
        }
        else
        {
            return noObjectValue;
        }
    }
}
}
