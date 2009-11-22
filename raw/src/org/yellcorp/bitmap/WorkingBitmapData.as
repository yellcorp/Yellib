package org.yellcorp.bitmap
{
import flash.display.BitmapData;


public class WorkingBitmapData extends BitmapData
{
    internal var owner:WorkingBitmapSet;

    public function WorkingBitmapData(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF)
    {
        super(width, height, transparent, fillColor);
    }

    public override function dispose():void
    {
        owner.recycle(this);
    }

    internal function trueDispose():void
    {
        super.dispose();
    }
}
}
