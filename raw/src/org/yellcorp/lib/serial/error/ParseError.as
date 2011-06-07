package org.yellcorp.lib.serial.error
{
public class ParseError extends Error
{
    public function ParseError(message:* = "", id:* = 0)
    {
        name = "ParseError";
        super(message, id);
    }
}
}
