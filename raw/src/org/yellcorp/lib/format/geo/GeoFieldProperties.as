package org.yellcorp.lib.format.geo
{
public class GeoFieldProperties
{
    public var zeroPad:Boolean;
    public var minWidth:int;
    public var precision:int;

    public function GeoFieldProperties()
    {
        clear();
    }

    public function clear():void
    {
        zeroPad = false;
        precision = 0;
    }
}
}
