package org.yellcorp.bitmap
{
import org.yellcorp.map.MultiMap;

import flash.display.BitmapData;


public class WorkingBitmapSet
{
    private var freePool:MultiMap;

    public function WorkingBitmapSet()
    {
        freePool = new MultiMap();
    }

    public function getBitmapData(width:uint, height:uint, transparent:Boolean = true):BitmapData
    {
        var bmp:WorkingBitmapData;
        var hash:uint;

        hash = calcHash(width, height, transparent);
        bmp = freePool.pop(hash);

        if (!bmp)
        {
            bmp = new WorkingBitmapData(width, height, transparent);
        }
        bmp.owner = this;

        return bmp;
    }

    public function purge():void
    {
        emptyPool();
        freePool.clear();
    }

    public function dispose():void
    {
        emptyPool();
        freePool = null;
    }

    internal function recycle(bmp:WorkingBitmapData):void
    {
        var hash:uint;

        bmp.owner = null;

        if (freePool)
        {
            hash = calcHash(bmp.width, bmp.height, bmp.transparent);
            freePool.push(hash, bmp);
        }
        else
        {
            bmp.trueDispose();
        }
    }

    private function calcHash(width:uint, height:uint, alpha:Boolean):uint
    {
        return (alpha ? 1 : 0) | (width << 14) | (height << 1);
    }

    private function emptyPool():void
    {
        var allKeys:Array;
        var currentList:Array;
        var i:int;
        var bmp:WorkingBitmapData;

        allKeys = freePool.getKeys();

        for (i = 0; i < allKeys.length; i++)
        {
            currentList = freePool.getList(allKeys[i]);
            for each (bmp in currentList)
            {
                bmp.trueDispose();
            }
        }
    }
}
}
