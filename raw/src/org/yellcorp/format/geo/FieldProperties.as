package org.yellcorp.format.geo
{
public class FieldProperties
{
    public var zeroPad:Boolean;
    public var minWidth:int;
    public var precision:int;

    public function FieldProperties()
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
