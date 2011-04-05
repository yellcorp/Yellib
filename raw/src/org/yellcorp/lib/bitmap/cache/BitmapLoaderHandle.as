package org.yellcorp.lib.bitmap.cache
{
import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.system.LoaderContext;


public class BitmapLoaderHandle extends EventDispatcher
{
    private var parent:BitmapCache;
    private var _bitmapData:BitmapData;

    internal var id:String;
    internal var url:URLRequest;
    internal var context:LoaderContext;

    public function BitmapLoaderHandle(parent:BitmapCache, url:URLRequest, context:LoaderContext, id:String, internalKey:Internal_ctor)
    {
        super();

        if (!internalKey)
        {
            throw new IllegalOperationError("Internal constructor");
        }

        this.parent = parent;
        this.url = url;
        this.context = context;
        this.id = id;
    }

    public function start():void
    {
        parent.startHandle(this);
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
