package org.yellcorp.format.printf.parser
{
public class PrecisionRangeError extends Error
{
    public function PrecisionRangeError(message:* = "", id:* = 0)
    {
        super(message, id);
        name = "PrecisionRangeError";
    }
}
}
