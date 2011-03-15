package org.yellcorp.lib.bitmap.pool
{
import org.yellcorp.lib.core.Disposable;
import org.yellcorp.lib.core.MultiMap;

import flash.display.BitmapData;


/**
 * BitmapDataPool is a factory class with a goal of maximising reuse of
 * BitmapData objects, while minimising disposal and reallocation.  Its
 * <code>getBitmapData</code> method returns a subclass of
 * <code>BitmapData</code>, with an overridden <code>dispose</code> method
 * that returns it to a pool instead of deallocating it.  This pool is then
 * used to fill subsequent requests to <code>getBitmapData</code>.  If a
 * matching object is already in the pool, it will be returned instead of
 * creating a new one.
 */
public class BitmapDataPool implements Disposable
{
    private var freePool:MultiMap;

    public function BitmapDataPool()
    {
        freePool = new MultiMap();
    }

    /**
     * Creates a new <code>BitmapData</code> or returns a matching
     * one from the pool.  The arguments to this function are the same as
     * the <code>BitmapData</code> constructor, except for the lack of a
     * <code>fillColor</code> parameter.
     *
     * <p>Note that pooled <code>BitmapData</code> objects aren't
     * automatically cleared and may contain old content.  To erase the
     * bitmap, call <code>fillRect()</code>.</p>
     *
     * @param width The width of the bitmap image in pixels.
     * @param height The height of the bitmap image in pixels.
     * @param transparent <code>true</code> if transparency support (alpha
     *        channel) is required.  @default true
     *
     * @return A new or pooled <code>BitmapData</code> object.
     *
     * @see flash.display.BitmapData#BitmapData()
     * @see flash.display.BitmapData#fillRect()
     */
    public function getBitmapData(width:uint, height:uint, transparent:Boolean = true):BitmapData
    {
        var bmp:BitmapDataPoolMember;
        var hash:uint;

        hash = calcHash(width, height, transparent);
        bmp = freePool.pop(hash);

        if (!bmp)
        {
            bmp = new BitmapDataPoolMember(width, height, transparent);
        }
        bmp.owner = this;

        return bmp;
    }

    /**
     * Clears and deallocates all objects in the
     * <code>WorkingBitmapData</code> pool.
     */
    public function purge():void
    {
        emptyPool();
        freePool.clear();
    }

    /**
     * Clears and deallocates all objects in the
     * <code>WorkingBitmapData</code> pool and stops pooling behaviour.
     *
     * <p>Should be called when an instance of this class is no longer
     * being used.  After this method is called, <code>getBitmapData()</code>
     * will return objects that behave like regular <code>BitmapData</code>
     * instances.
     */
    public function dispose():void
    {
        emptyPool();
        freePool = null;
    }

    /**
     * @private
     */
    internal function recycle(bmp:BitmapDataPoolMember):void
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
        var bmp:BitmapDataPoolMember;

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
