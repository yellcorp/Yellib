package org.yellcorp.net.multiloader.items
{
import org.yellcorp.bitmap.loader.BitmapLoader;
import org.yellcorp.net.multiloader.core.MultiLoaderItem;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;


/**
 * Used with MultiLoader to download a JPEG, PNG, GIF or SWF file from a
 * URL, and make it available as an instance of BitmapData.  Implemented
 * as a Loader, and as such is subject to the same restrictions.
 */
public class BitmapLoaderItem extends MultiLoaderItem
{
    private var _loader:BitmapLoader;
    public var context:LoaderContext;
    public var transparent:Boolean;
    public var fillColor:uint;
    public var fitMethod:String;

    /**
     * Creates a BinaryLoaderItem which will make the specified request
     * when it starts loading.
     *
     * @param request      The request to issue and download from.
     * @param context      The LoaderContext for the load operation.
     * @param transparent  Whether to compose the loaded image over a
     *                     transparent background.
     * @param fillColor    The background color to compose the loaded image
     *                     over
     * @param fitMethod    Resize strategy in case the loaded Bitmap exceeds
     *                     the allowed dimensions of BitmapData objects
     *
     * @see flash.display.BitmapData
     * @see flash.display.Loader#load
     */
    public function BitmapLoaderItem(
        request:URLRequest,
        context:LoaderContext = null,
        transparent:Boolean = true,
        fillColor:uint = 0xFFFFFFFF,
        fitMethod:String = "crop")
    {
        super(request);
        this.context = context;
        this.transparent = transparent;
        this.fillColor = fillColor;
        this.fitMethod = fitMethod;
    }

    public override function destroy():void
    {
        super.destroy();
        _loader.removeEventListener(Event.OPEN, onOpen);
        _loader.removeEventListener(Event.COMPLETE, onComplete);
        _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.destroy();
        _loader = null;
    }

    public override function get bytesLoaded():uint
    {
        return _loader ? _loader.bytesLoaded : 0;
    }

    public override function get bytesTotal():uint
    {
        return _loader ? _loader.bytesTotal : 0;
    }

    public override function get bytesTotalKnown():Boolean
    {
        return _loader ? _loader.bytesTotal > 0 : false;
    }

    protected override function startLoad():void
    {
        _loader = new BitmapLoader(transparent, fillColor, fitMethod);
        _loader.addEventListener(Event.OPEN, onOpen);
        _loader.addEventListener(Event.COMPLETE, onComplete);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.load(request, context);
    }

    /**
     * The BitmapLoader object used to load the bitmap.
     */
    public function get loader():BitmapLoader
    {
        return _loader;
    }

    /**
     * Creates a new copy of the bitmap as a BitmapData object. No reference
     * is retained to this bitmap by the BitmapLoaderItem - the caller is
     * considered to own it. It is the caller's responsibility to call
     * dispose() on it when it is no longer needed.
     *
     * @see flash.display.BitmapData#dispose
     */
    public function getBitmapData():BitmapData
    {
        return _loader.getBitmapData();
    }
}
}
