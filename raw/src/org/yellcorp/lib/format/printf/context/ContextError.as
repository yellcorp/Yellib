package org.yellcorp.lib.format.printf.context
{
/**
 * @private
 */
public class ContextError extends Error
{
    public function ContextError(message:* = "", id:* = 0)
    {
        super(message, id);
        name = "PrecisionRangeError";
    }
}
}
