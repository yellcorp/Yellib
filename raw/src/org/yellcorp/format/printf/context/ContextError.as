package org.yellcorp.format.printf.context
{
public class ContextError extends Error
{
    public function ContextError(message:* = "", id:* = 0)
    {
        super(message, id);
        name = "PrecisionRangeError";
    }
}
}
