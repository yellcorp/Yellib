package org.yellcorp.bitmap
{
import org.yellcorp.mem.Destructor;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.geom.Matrix;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;


public class BitmapLoader extends EventDispatcher implements Destructor
{
    public static const FP9_MAX_AXIS:uint = 2880;
    public static const FP10_MAX_AXIS:uint = 8192;
    public static const FP10_MAX_AREA:uint = 16777216;

    public var transparent:Boolean;
    public var fillColor:uint;

    private var _fitMethod:String;
    private var _loaded:Boolean;
    private var _isOverSize:Boolean;

    private var loader:Loader;

    private var bmpWidth:Number;
    private var bmpHeight:Number;
    private var drawMatrix:Matrix;

    private static var versionChecked:Boolean;
    private static var playerV9:Boolean;

    public function BitmapLoader(newTransparent:Boolean = true, newFillColor:uint = 0xFFFFFFFF, newFitMethod:String = "crop")
    {
        super();
        transparent = newTransparent;
        fillColor = newFillColor;
        _fitMethod = newFitMethod;
        loader = new Loader();

        if (!versionChecked)
        {
            versionChecked = true;
            try {
                playerV9 = !(loader['unloadAndStop']);
            }
            catch (re:ReferenceError)
            {
                playerV9 = true;
            }
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
        if (playerV9)
        {
            _isOverSize = contentWidth > FP9_MAX_AXIS || contentHeight > FP9_MAX_AXIS;
        }
        else
        {
            _isOverSize = contentWidth > FP10_MAX_AXIS || contentHeight > FP10_MAX_AXIS ||
                          contentWidth * contentHeight > FP10_MAX_AREA;
        }
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
                {
                    bmpWidth = 0;
                    bmpHeight = 0;
                    return;
                }
                case BitmapLoaderFitMethod.SCALE :
                {
                    if (playerV9)
                        fitScaleV9();
                    else
                        fitScaleV10();
                    return;
                }
                default :
                {
                    if (playerV9)
                        fitCropV9();
                    else
                        fitCropV10();
                    return;
                }
            }
        }
        else
        {
            bmpWidth = contentWidth;
            bmpHeight = contentHeight;
            drawMatrix = null;
        }
    }

    private function fitScaleV9():void
    {
        var inWidth:Number = contentWidth;
        var inHeight:Number = contentHeight;

        if (inWidth > inHeight)
        {
            bmpWidth = FP9_MAX_AXIS;
            bmpHeight = Math.round(inHeight * FP9_MAX_AXIS / inWidth);
        }
        else
        {
            bmpWidth = Math.round(inWidth * FP9_MAX_AXIS / inHeight);
            bmpHeight = FP9_MAX_AXIS;
        }

        // recalculate the ratio as rounding changes it very
        // slightly which would cause semitransparent edges near
        // the bottom and right borders
        drawMatrix = new Matrix(bmpWidth / inWidth, 0, 0, bmpHeight / inHeight, 0, 0);
    }

    private function fitCropV9():void
    {
        bmpWidth =  Math.min(FP9_MAX_AXIS, contentWidth);
        bmpHeight = Math.min(FP9_MAX_AXIS, contentHeight);
        drawMatrix = null;
    }

    private function fitScaleV10():void
    {
        var inWidth:Number = contentWidth;
        var inHeight:Number = contentHeight;
        var areaScale:Number;

        if (inWidth > FP10_MAX_AXIS || inHeight > FP10_MAX_AXIS)
        {
            if (inWidth > inHeight)
            {
                bmpWidth = FP10_MAX_AXIS;
                bmpHeight = inHeight * FP10_MAX_AXIS / inWidth;
            }
            else
            {
                bmpWidth = inWidth * FP10_MAX_AXIS / inHeight;
                bmpHeight = FP9_MAX_AXIS;
            }
        }
        // axes now within limits, but area may still be too big

        // round before the area test to get the true final pixel count
        bmpWidth = Math.round(bmpWidth);
        bmpHeight = Math.round(bmpHeight);

        if (bmpWidth * bmpHeight > FP10_MAX_AREA)
        {
            // but use the original dimensions for calculating the
            // area scale as it's slightly more accurate
            areaScale = Math.sqrt(FP10_MAX_AREA / (inWidth * inHeight));

            // floor because a round could bump the total area back
            // above the limit
            bmpWidth = Math.floor(inWidth * areaScale);
            bmpHeight = Math.floor(inHeight * areaScale);
        }
        drawMatrix = new Matrix(bmpWidth / inWidth, 0, 0, bmpHeight / inHeight, 0, 0);
    }

    private function fitCropV10():void
    {
        var inWidth:Number = contentWidth;
        var inHeight:Number = contentHeight;
        var areaScale:Number;

        bmpWidth =  Math.min(FP10_MAX_AXIS, contentWidth);
        bmpHeight = Math.min(FP10_MAX_AXIS, contentHeight);

        if (bmpWidth * bmpHeight > FP10_MAX_AREA)
        {
            areaScale = Math.sqrt(FP10_MAX_AREA / (inWidth * inHeight));
            bmpWidth = Math.floor(inWidth * areaScale);
            bmpHeight = Math.floor(inHeight * areaScale);
        }
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
