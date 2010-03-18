package org.yellcorp.bitmap
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;


public class Scale9Bitmap extends Sprite
{
    private var _sourceBitmapData:BitmapData;
    private var _canvas:BitmapData;
    private var _smoothing:Boolean;
    private var display:Bitmap;
    private var dirtyBitmap:Boolean;

    private var _width:Number;
    private var _height:Number;
    private var _scale9Grid:Rectangle;
    private var clipRect:Rectangle;
    private var dirtySize:Boolean;

    private var sourceWidths:Array;
    private var sourceHeights:Array;
    private var targetWidths:Array;
    private var targetHeights:Array;

    private var workMatrix:Matrix;
    private var workDrawRect:Rectangle;

    public function Scale9Bitmap(bitmapData:BitmapData = null,
                                 pixelSnapping:String = "auto",
                                 smoothing:Boolean = false,
                                 scale9Grid:Rectangle = null)
    {
        //Bitmap can't be trusted to remember it
        _smoothing = smoothing;
        addChild(display = new Bitmap(null, pixelSnapping, smoothing));

        sourceWidths =  [ 0, 0, 0 ];
        sourceHeights = [ 0, 0, 0 ];
        targetWidths =  [ 0, 0, 0 ];
        targetHeights = [ 0, 0, 0 ];

        clipRect = new Rectangle();
        workMatrix = new Matrix();
        workDrawRect = new Rectangle();

        addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);

        _width = bitmapData.width;
        _height = bitmapData.height;

        this.bitmapData = bitmapData;
        this.scale9Grid = scale9Grid;
    }

    public override function get width():Number
    {
        return _width;
    }

    public override function set width(new_width:Number):void
    {
        _width = new_width;
        invalidateSize();
    }

    public override function get height():Number
    {
        return _height;
    }

    public override function set height(new_height:Number):void
    {
        _height = new_height;
        invalidateSize();
    }

    public function setSize(w:Number, h:Number):void
    {
        _width = w;
        _height = h;
        invalidateSize();
    }

    public function get bitmapData():BitmapData
    {
        return _sourceBitmapData;
    }

    public function set bitmapData(new_bitmapData:BitmapData):void
    {
        _sourceBitmapData = new_bitmapData;
        invalidateBitmap();
    }

    public function get pixelSnapping():String
    {
        return display.pixelSnapping;
    }

    public function set pixelSnapping(new_pixelSnapping:String):void
    {
        display.pixelSnapping = new_pixelSnapping;
    }

    public function get smoothing():Boolean
    {
        return _smoothing;
    }

    public function set smoothing(new_smoothing:Boolean):void
    {
        _smoothing = display.smoothing = new_smoothing;
    }

    public override function get scale9Grid():Rectangle
    {
        return _scale9Grid;
    }

    public override function set scale9Grid(scalingArea:Rectangle):void
    {
        _scale9Grid = scalingArea;
        invalidateSize();
    }

    public function drawNow():void
    {
        draw();
    }

    protected function invalidateSize():void
    {
        dirtySize = true;
        if (stage) stage.invalidate();
    }

    protected function invalidateBitmap():void
    {
        dirtyBitmap = true;
        if (stage) stage.invalidate();
    }

    protected function draw():void
    {
        if (dirtyBitmap)
        {
            drawBitmap();
            drawSize();
        }
        else if (dirtySize)
        {
            drawSize();
        }
    }

    protected function drawBitmap():void
    {
        if (_sourceBitmapData)
        {
            _width = _sourceBitmapData.width;
            _height = _sourceBitmapData.height;
        }
        else
        {
            _width = 0;
            _height = 0;
        }
        dirtySize = true;
        dirtyBitmap = false;
    }

    protected function drawSize():void
    {
        if (_sourceBitmapData && _height > 0 && _width > 0)
        {
            if (!contains(display))
            {
                addChild(display);
            }
            if (!_scale9Grid)
            {
                drawLinearScale();
            }
            else
            {
                drawScale9();
            }
        }
        else
        {
            if (contains(display))
            {
                removeChild(display);
            }
        }
        dirtySize = false;
    }

    private function drawLinearScale():void
    {
        display.bitmapData = _sourceBitmapData;
        display.width = _width;
        display.height = _height;
    }

    private function drawScale9():void
    {
        var i:int;
        var j:int;

        var cSourceX:Number;
        var cSourceY:Number;
        var cTargetX:Number;
        var cTargetY:Number;
        var cSourceWidth:Number;
        var cSourceHeight:Number;
        var cTargetWidth:Number;
        var cTargetHeight:Number;

        _canvas = allocateCanvas(_canvas, Math.ceil(_width), Math.ceil(_height));

        sourceWidths[0]  = _scale9Grid.x;
        sourceWidths[1]  = _scale9Grid.width;
        sourceWidths[2]  = _sourceBitmapData.width - _scale9Grid.width - _scale9Grid.x;
        sourceHeights[0] = _scale9Grid.y;
        sourceHeights[1] = _scale9Grid.height;
        sourceHeights[2] = _sourceBitmapData.height - _scale9Grid.height - _scale9Grid.y;

        if ((targetWidths[1] = _width - sourceWidths[0] - sourceWidths[2]) > 0)
        {
            targetWidths[0] = sourceWidths[0];
            targetWidths[2] = sourceWidths[2];
        }
        else
        {
            targetWidths[0] = _width * sourceWidths[0] / (sourceWidths[0] + sourceWidths[2]);
            targetWidths[2] = _width * sourceWidths[2] / (sourceWidths[0] + sourceWidths[2]);
        }

        if ((targetHeights[1] = _height - sourceHeights[0] - sourceHeights[2]) > 0)
        {
            targetHeights[0] = sourceHeights[0];
            targetHeights[2] = sourceHeights[2];
        }
        else
        {
            targetHeights[0] = _height * sourceHeights[0] / (sourceHeights[0] + sourceHeights[2]);
            targetHeights[2] = _height * sourceHeights[2] / (sourceHeights[0] + sourceHeights[2]);
        }

        cSourceX = cTargetX = 0;
        for (i = 0; i < 3; i++)
        {
            cSourceY = cTargetY = 0;
            if ((cSourceWidth = sourceWidths[i]) > 0 &&
                (cTargetWidth = targetWidths[i]) > 0)
            {
                workMatrix.a = cTargetWidth / cSourceWidth;
                workMatrix.tx = cTargetX - cSourceX * workMatrix.a;
                workDrawRect.x = cTargetX;
                workDrawRect.width = cTargetWidth;

                for (j = 0; j < 3; j++)
                {
                    if ((cSourceHeight = sourceHeights[j]) > 0 &&
                        (cTargetHeight = targetHeights[j]) > 0)
                    {
                        workMatrix.d = cTargetHeight / cSourceHeight;
                        workMatrix.ty = cTargetY - cSourceY * workMatrix.d;
                        workDrawRect.y = cTargetY;
                        workDrawRect.height = cTargetHeight;

                        _canvas.draw(_sourceBitmapData, workMatrix, null, null, workDrawRect, _smoothing);

                        cTargetY += cTargetHeight;
                    }
                    cSourceY += cSourceHeight;
                }
                cTargetX += cTargetWidth;
            }
            cSourceX += cSourceWidth;
        }

        display.scaleX = display.scaleY = 1;
        display.bitmapData = _canvas;
        clipRect.width = _width;
        clipRect.height = _height;
        display.scrollRect = clipRect;
    }

    private function onAdded(event:Event):void
    {
        stage.addEventListener(Event.RENDER, onRender);
        draw();
    }

    private function onRemoved(event:Event):void
    {
        stage.removeEventListener(Event.RENDER, onRender);
    }

    private function onRender(event:Event):void
    {
        draw();
    }

    protected static function allocateCanvas(bitmap:BitmapData, width:int, height:int):BitmapData
    {
        var w2:int = width - 1;
        var h2:int = height - 1;

        // next highest power of two via bit banging
        // maybe the jit will do something nice with it who knows
        w2 |= w2 >> 1;  w2 |= w2 >> 2;  w2 |= w2 >> 4;  w2 |= w2 >> 8;  w2 |= w2 >> 16;
        w2++;
        h2 |= h2 >> 1;  h2 |= h2 >> 2;  h2 |= h2 >> 4;  h2 |= h2 >> 8;  h2 |= h2 >> 16;
        h2++;

        if (!bitmap || bitmap.width != w2 || bitmap.height != h2)
        {
            if (bitmap) bitmap.dispose();
            bitmap = new BitmapData(w2, h2, true, 0);
        }
        else
        {
            bitmap.fillRect(bitmap.rect, 0);
        }
        return bitmap;
    }
}
}
