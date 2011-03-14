package org.yellcorp.lib.bitmap.loader
{
import org.yellcorp.lib.core.Destructor;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;


[Event(name="complete", type="flash.events.Event")]
[Event(name="open", type="flash.events.Event")]
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
[Event(name="progress", type="flash.events.ProgressEvent")]
[Event(name="ioError", type="flash.events.IOErrorEvent")]
public class BitmapLoader extends EventDispatcher implements Destructor
{
    public var transparent:Boolean;
    public var fillColor:uint;

    private var _fitMethod:String;
    private var _loaded:Boolean;
    private var _isOverSize:Boolean;

    private var loader:Loader;

    private var bmpWidth:Number;
    private var bmpHeight:Number;
    private var bmpSize:Point;
    private var drawMatrix:Matrix;

    private static var resizer:Resizer;
    private static var playerV9:Boolean;

    public function BitmapLoader(newTransparent:Boolean = true, newFillColor:uint = 0xFFFFFFFF, newFitMethod:String = "crop")
    {
        super();

        transparent = newTransparent;
        fillColor = newFillColor;
        _fitMethod = newFitMethod;

        bmpSize = new Point();
        loader = new Loader();

        if (!resizer)
        {
            try {
                playerV9 = !(loader['unloadAndStop']);
            }
            catch (re:ReferenceError)
            {
                playerV9 = true;
            }
            resizer = playerV9 ? new ResizerV9() : new ResizerV10();
        }
        addListeners(loader.contentLoaderInfo);
    }

    public function destroy():void
    {
        removeListeners(loader.contentLoaderInfo);
        try {
            loader.close();
        }
        catch (e:Error)
        { }
        clear();
    }

    public function get bytesLoaded():uint
    {
        return loader.contentLoaderInfo.bytesLoaded;
    }

    public function get bytesTotal():uint
    {
        return loader.contentLoaderInfo.bytesTotal;
    }

    public function get fitMethod():String
    {
        return _fitMethod;
    }

    public function set fitMethod(new_fitMethod:String):void
    {
        _fitMethod = new_fitMethod;
        updateFitMethod();
    }

    public function load(request:URLRequest, context:LoaderContext = null):void
    {
        _loaded = false;
        loader.load(request, context);
    }

    public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
    {
        _loaded = false;
        loader.loadBytes(bytes, context);
    }

    public function get contentWidth():int
    {
        return _loaded ? loader.contentLoaderInfo.width : -1;
    }

    public function get contentHeight():int
    {
        return _loaded ? loader.contentLoaderInfo.height : -1;
    }

    public function get loaded():Boolean
    {
        return _loaded;
    }

    public function get isOverSize():Boolean
    {
        return _isOverSize;
    }

    /**
     * Creates a new copy of the loaded bitmap as a BitmapData object. No
     * reference to this bitmap is retained by the BitmapLoaderItem - it
     * is the caller's responsibility to call dispose() on it when it is
     * no longer needed.
     *
     * @see flash.display.BitmapData#dispose
     */
    public function getBitmapData():BitmapData
    {
        var bmp:BitmapData;

        if (!_loaded || bmpWidth == 0 || bmpHeight == 0) return null;

        bmp = new BitmapData(bmpWidth, bmpHeight, transparent, fillColor);
        bmp.draw(loader, drawMatrix, null, null, null, true);
        return bmp;
    }

    public function clear():void
    {
        if (_loaded)
        {
            if (playerV9)
            {
                loader.unload();
            }
            else
            {
                loader['unloadAndStop']();
            }
            _loaded = false;
        }
    }

    private function onComplete(event:Event):void
    {
        _loaded = true;
        _isOverSize = resizer.isOversize(contentWidth, contentHeight);
        updateFitMethod();
        dispatchEvent(event);
    }

    private function updateFitMethod():void
    {
        if (_isOverSize)
        {
            switch (_fitMethod)
            {
                case BitmapLoaderFitMethod.NULL :
                    fitNull();
                    return;

                case BitmapLoaderFitMethod.SCALE :
                    fitScale();
                    return;

                default :
                    fitCrop();
                    return;
            }
        }
        else
        {
            fitNone();
        }
    }

    private function fitNull():void
    {
        bmpWidth = 0;
        bmpHeight = 0;
        drawMatrix = null;
    }

    private function fitScale():void
    {
        if (!drawMatrix)
        {
            drawMatrix = new Matrix();
        }
        resizer.fitScale(contentWidth, contentHeight, bmpSize, drawMatrix);
        bmpWidth = bmpSize.x;
        bmpHeight = bmpSize.y;
    }

    private function fitCrop():void
    {
        resizer.fitCrop(contentWidth, contentHeight, bmpSize);
        drawMatrix = null;
        bmpWidth = bmpSize.x;
        bmpHeight = bmpSize.y;
    }

    private function fitNone():void
    {
        bmpWidth = contentWidth;
        bmpHeight = contentHeight;
        drawMatrix = null;
    }

    private function addListeners(cli:LoaderInfo):void
    {
        cli.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
        cli.addEventListener(Event.OPEN, dispatchEvent, false, 0, true);
        cli.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent, false, 0, true);
        cli.addEventListener(ProgressEvent.PROGRESS, dispatchEvent, false, 0, true);
        cli.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent, false, 0, true);
    }

    private function removeListeners(cli:LoaderInfo):void
    {
        cli.removeEventListener(Event.COMPLETE, onComplete, false);
        cli.removeEventListener(Event.OPEN, dispatchEvent, false);
        cli.removeEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent, false);
        cli.removeEventListener(ProgressEvent.PROGRESS, dispatchEvent, false);
        cli.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent, false);
    }
}
}
