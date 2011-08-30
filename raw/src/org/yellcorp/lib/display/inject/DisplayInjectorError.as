package org.yellcorp.lib.display.inject
{
public class DisplayInjectorError extends Error
{
    public var property:String;

    public function DisplayInjectorError(message:* = "", property:String = null, id:* = 0)
    {
        super(message, id);
        this.property = property;
        name = "DisplayInjectorError";
    }
}
}
