package org.yellcorp.lib.display.inject
{
public class DisplayMetadataError extends Error
{
    public var property:String;

    public function DisplayMetadataError(message:* = "", property:String = null, id:* = 0)
    {
        super(message, id);
        this.property = property;
        name = "DisplayMetadataError";
    }
}
}
