package org.yellcorp.lib.bitmap.cache
{
import flash.display.BitmapData;
import flash.utils.Dictionary;


public class BitmapDictionary
{
    private var bitmaps:Dictionary;
    private var _size:uint;
    private var _length:uint;

    public function BitmapDictionary()
    {
        bitmaps = new Dictionary();
        _size = 0;
        _length = 0;
    }

    public function hasBitmap(key:String):Boolean
    {
        return bitmaps[key] is BitmapData;
    }

    public function setBitmap(key:String, bitmap:BitmapData):void
    {
        deleteBitmap(key);
        bitmaps[key] = bitmap;
        _size += CacheUtil.bitmapSize(bitmap);
        _length++;
        //trace("Added bitmap size="+_size);
    }

    public function getBitmap(key:String):BitmapData
    {
        return bitmaps[key];
    }

    public function deleteBitmap(key:String):Boolean
    {
        var bitmap:BitmapData = getBitmap(key);

        if (bitmap != null)
        {
            _size -= CacheUtil.bitmapSize(bitmap);
            _length--;
            bitmap.dispose();
            delete bitmaps[key];
            //trace("Deleted bitmap size="+_size);
            return true;
        }
        else
        {
            return false;
        }
    }

    public function clearAll():void
    {
        var keys:Array = new Array();
        var keyIter:String;

        // create a snapshot of the keys
        for (keyIter in bitmaps)
        {
            keys.push(keyIter);
        }

        // now delete them
        for each (keyIter in keys)
        {
            deleteBitmap(keyIter);
        }
    }

    public function get size():uint
    {
        return _size;
    }
}
}
