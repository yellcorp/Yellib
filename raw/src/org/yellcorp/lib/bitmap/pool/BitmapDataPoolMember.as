package org.yellcorp.lib.bitmap.pool
{
import flash.display.BitmapData;


internal class BitmapDataPoolMember extends BitmapData
{
    internal var owner:BitmapDataPool;

    public function BitmapDataPoolMember(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF)
    {
        super(width, height, transparent, fillColor);
    }
    public override function dispose():void
    {
        if (owner)
        {
            owner.recycle(this);
        }
        else
        {
            super.dispose();
        }
    }

    internal function trueDispose():void
    {
        super.dispose();
    }
}
}
