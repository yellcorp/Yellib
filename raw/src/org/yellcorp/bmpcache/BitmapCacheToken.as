package org.yellcorp.bmpcache
{
import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.net.URLRequest;


public class BitmapCacheToken extends EventDispatcher
{
    private var parent:BitmapCache;
    private var _bitmapData:BitmapData;

    internal var id:String;
    internal var url:URLRequest;

    public function BitmapCacheToken(parent:BitmapCache, url:URLRequest, id:String, internalKey:Internal_ctor)
    {
        super();

        if (!internalKey)
        {
            throw new IllegalOperationError("Internal constructor");
        }

        this.parent = parent;
        this.url = url;
        this.id = id;
    }

    public function start():void
    {
        parent.startToken(this);
    }

    public function get bitmapData():BitmapData
    {
        return _bitmapData;
    }

    // actionscript is broken again yay
    // can't have mixed-access getters and setters
    // internal function set bitmapData(v:BitmapData):void
    internal function setBitmapData(v:BitmapData):void
    {
        _bitmapData = v;
    }
}
}
