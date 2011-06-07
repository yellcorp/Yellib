package org.yellcorp.lib.serial.error
{
public class SourceError extends Error
{
    public function SourceError(message:* = "", id:* = 0)
    {
        name = "SourceError";
        super(message, id);
    }
}
}
