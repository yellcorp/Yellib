package org.yellcorp.lib.display.inject
{
public class DisplayPathError extends Error
{
    public var displayPath:String;
    public var property:String;

    public function DisplayPathError(
        message:* = "",
        displayPath:String = "",
        property:String = "",
        id:* = 0)
    {
        super(message, id);
        name = "DisplayPathError";
        this.displayPath = displayPath;
        this.property = property;
    }
}
}
