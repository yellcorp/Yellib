package org.yellcorp.bitmap
{
import org.yellcorp.ui.BaseDisplay;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;


public class Scale9Bitmap extends BaseDisplay
{
    private var _sourceBitmapData:BitmapData;
    private var _canvas:BitmapData;
    private var _smoothing:Boolean;
    private var bitmapDisplay:Bitmap;

    private var _scale9Grid:Rectangle;
    private var clipRect:Rectangle;

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
        _smoothing = smoothing;
        addChild(bitmapDisplay = new Bitmap(null, pixelSnapping, smoothing));

        sourceWidths =  [ 0, 0, 0 ];
        sourceHeights = [ 0, 0, 0 ];
        targetWidths =  [ 0, 0, 0 ];
        targetHeights = [ 0, 0, 0 ];

        clipRect = new Rectangle();
        workMatrix = new Matrix();
        workDrawRect = new Rectangle();

        super(bitmapData.width, bitmapData.height);

        this.bitmapData = bitmapData;
        this.scale9Grid = scale9Grid;
    }

    public function get bitmapData():BitmapData
    {
        return _sourceBitmapData;
    }

    public function set bitmapData(new_bitmapData:BitmapData):void
    {
        _sourceBitmapData = new_bitmapData;
        if (_sourceBitmapData)
        {
            setSize(_sourceBitmapData.width, _sourceBitmapData.height);
        }
        else
        {
            setSize(0, 0);
        }
    }

    public function get pixelSnapping():String
    {
        return bitmapDisplay.pixelSnapping;
    }

    public function set pixelSnapping(new_pixelSnapping:String):void
    {
        bitmapDisplay.pixelSnapping = new_pixelSnapping;
    }

    public function get smoothing():Boolean
    {
        return _smoothing;
    }

    public function set smoothing(new_smoothing:Boolean):void
    {
        _smoothing = bitmapDisplay.smoothing = new_smoothing;
    }

    public override function get scale9Grid():Rectangle
    {
        return _scale9Grid;
    }

    public override function set scale9Grid(scalingArea:Rectangle):void
    {
        _scale9Grid = scalingArea;
        invalidate(SIZE);
    }

    protected override function draw():void
    {
        if (isInvalid(SIZE))
        {
            drawSize();
        }
    }

    protected function drawBitmap():void
    {
        invalidate(SIZE);
    }

    protected function drawSize():void
    {
        if (_sourceBitmapData && _height > 0 && _width > 0)
        {
            if (!contains(bitmapDisplay))
            {
                addChild(bitmapDisplay);
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
            if (contains(bitmapDisplay))
            {
                removeChild(bitmapDisplay);
            }
        }
        validate(SIZE);
    }

    private function drawLinearScale():void
    {
        bitmapDisplay.bitmapData = _sourceBitmapData;
        bitmapDisplay.width = _width;
        bitmapDisplay.height = _height;
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

        bitmapDisplay.scaleX = bitmapDisplay.scaleY = 1;
        bitmapDisplay.bitmapData = _canvas;
        clipRect.width = _width;
        clipRect.height = _height;
        bitmapDisplay.scrollRect = clipRect;
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
