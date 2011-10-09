package org.yellcorp.lib.format.geo
{
public class GeoFormatError extends Error
{
    public function GeoFormatError(message:* = "", id:* = 0)
    {
        name = "GeoFormatError";
        super(message, id);
    }
}
}
