package org.yellcorp.lib.display.inject
{
public class DisplayPathError extends DisplayInjectorError
{
    public var displayPath:String;

    public function DisplayPathError(
        message:* = "",
        displayPath:String = "",
        property:String = "",
        id:* = 0)
    {
        super(message, id, property);
        name = "DisplayPathError";
        this.displayPath = displayPath;
    }
}
}
