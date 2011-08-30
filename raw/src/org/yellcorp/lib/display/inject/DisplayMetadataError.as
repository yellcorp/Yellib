package org.yellcorp.lib.display.inject
{
public class DisplayMetadataError extends DisplayInjectorError
{
    public function DisplayMetadataError(message:* = "", property:String = null, id:* = 0)
    {
        super(message, property, id);
        name = "DisplayMetadataError";
    }
}
}
