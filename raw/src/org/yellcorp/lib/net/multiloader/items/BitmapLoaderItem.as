package org.yellcorp.lib.net.multiloader.items
{
import org.yellcorp.lib.bitmap.BitmapLoader;
import org.yellcorp.lib.net.multiloader.core.MultiLoaderItem;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;


/**
 * Used with MultiLoader to download a JPEG, PNG, GIF or SWF file from a
 * URL, and make it available as an instance of BitmapData.  Implemented
 * as a Loader, and as such is subject to the same restrictions.
 */
public class BitmapLoaderItem extends MultiLoaderItem
{
    private var _loader:BitmapLoader;

    /**
     * Creates a BinaryLoaderItem which will make the specified request
     * when it starts loading.
     *
     * @param request      The request to issue and download from.
     */
    public function BitmapLoaderItem(request:URLRequest)
    {
        super(request);
    }

    public override function dispose():void
    {
        super.dispose();
        _loader.removeEventListener(Event.OPEN, onOpen);
        _loader.removeEventListener(Event.COMPLETE, onComplete);
        _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onAsyncError);
        _loader.dispose();
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
        _loader = new BitmapLoader();
        _loader.addEventListener(Event.OPEN, onOpen);
        _loader.addEventListener(Event.COMPLETE, onComplete);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
        _loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, onAsyncError);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAsyncError);
        _loader.load(request);
    }

    /**
     * The BitmapLoader object used to load the bitmap.
     */
    public function get loader():BitmapLoader
    {
        return _loader;
    }

    /**
     * Creates a new copy of the loaded bitmap as a BitmapData object. No
     * reference to this bitmap is retained by the BitmapLoaderItem - it
     * is the caller's responsibility to call dispose() on it when it is
     * no longer needed.
     *
     * @see flash.display.BitmapData#dispose
     */
    public function copyBitmapData():BitmapData
    {
        return _loader.copyBitmapData();
    }
}
}
