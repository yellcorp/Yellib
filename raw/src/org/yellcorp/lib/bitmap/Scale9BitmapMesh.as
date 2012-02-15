package org.yellcorp.lib.bitmap
{
import org.yellcorp.lib.error.assert;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;


public class Scale9BitmapMesh extends Sprite
{
    private var _width:Number;
    private var _height:Number;

    private var _scale9Grid:Rectangle;
    private var _bitmapData:BitmapData;
    private var _smoothing:Boolean;

    private var verts:Vector.<Number>;
    private var uvs:Vector.<Number>;

    private var vertsNeedRecalc:Boolean;
    private var uvsNeedRecalc:Boolean;

    private var drawIndexSet:uint;
    private static const CENTER_ROW:uint = 1;
    private static const CENTER_COLUMN:uint = 2;

    private static const CORNER_PATCHES:uint = 0;
    private static const NO_CENTER_COLUMN:uint = 1;
    private static const NO_CENTER_ROW:uint = 2;
    private static const ALL:uint = 3;

    private static var _indicesAll:Vector.<int>;
    private static var _indicesNoCenterRow:Vector.<int>;
    private static var _indicesNoCenterColumn:Vector.<int>;
    private static var _indicesCornerPatches:Vector.<int>;
    private static var _indicesCorners:Vector.<int>;

    public function Scale9BitmapMesh(
        bitmapData:BitmapData = null, innerRectangle:Rectangle = null,
        smoothing:Boolean = false)
    {
        verts = Vector.<Number>([
            0.00, 0.00,   0.00, 0.00,   0.00, 0.00,   0.00, 0.00,
            0.00, 0.00,   0.00, 0.00,   0.00, 0.00,   0.00, 0.00,
            0.00, 0.00,   0.00, 0.00,   0.00, 0.00,   0.00, 0.00,
            0.00, 0.00,   0.00, 0.00,   0.00, 0.00,   0.00, 0.00
        ]);
        verts.fixed = true;

        uvs = Vector.<Number>([
            0.00, 0.00,   0.33, 0.00,   0.67, 0.00,   1.00, 0.00,
            0.00, 0.33,   0.33, 0.33,   0.67, 0.33,   1.00, 0.33,
            0.00, 0.67,   0.33, 0.67,   0.67, 0.67,   1.00, 0.67,
            0.00, 1.00,   0.33, 1.00,   0.67, 1.00,   1.00, 1.00
        ]);
        uvs.fixed = true;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
        _width = bitmapData ? bitmapData.width : 0;
        _height = bitmapData ? bitmapData.height : 0;
        this.bitmapData = bitmapData;
        this.scale9Grid = innerRectangle;
        this.smoothing = smoothing;

        redraw();
    }

    public override function get width():Number
    {
        return _width;
    }

    public override function set width(new_width:Number):void
    {
        _width = new_width;
        vertsNeedRecalc = true;
        invalidate();
    }

    public override function get height():Number
    {
        return _height;
    }

    public override function set height(new_height:Number):void
    {
        _height = new_height;
        vertsNeedRecalc = true;
        invalidate();
    }

    public function setSize(width:Number, height:Number):void
    {
        _width = width;
        _height = height;
        vertsNeedRecalc = true;
        redraw();
    }

    public function get bitmapData():BitmapData
    {
        return _bitmapData;
    }

    public function set bitmapData(new_bitmapData:BitmapData):void
    {
        _bitmapData = new_bitmapData;
        scale9Grid = _scale9Grid;
        invalidate();
    }

    public override function get scale9Grid():Rectangle
    {
        return _scale9Grid;
    }

    public override function set scale9Grid(innerRectangle:Rectangle):void
    {
        _scale9Grid = innerRectangle && _bitmapData ?
              clampRect(innerRectangle, _bitmapData.rect)
            : innerRectangle;
        uvsNeedRecalc = vertsNeedRecalc = true;
        invalidate();
    }

    public function get smoothing():Boolean
    {
        return _smoothing;
    }

    public function set smoothing(new_smoothing:Boolean):void
    {
        _smoothing = new_smoothing;
        invalidate();
    }

    public function redraw():void
    {
        graphics.clear();

        if (_width <= 0 || _height <= 0 || !_bitmapData)  return;

        if (!_scale9Grid)
        {
            drawLinear();
        }
        else
        {
            drawScale9();
        }
    }

    private function drawLinear():void
    {
        if (vertsNeedRecalc)
        {
            recalcVertsLinear();
        }
        graphics.beginBitmapFill(_bitmapData, null, false, _smoothing);
        graphics.drawTriangles(verts, indicesCorners, uvs);
        graphics.endFill();
    }

    private function recalcVertsLinear():void
    {
        verts[6]  = verts[30] = _width - 1;
        verts[25] = verts[31] = _height - 1;
        vertsNeedRecalc = false;
    }

    private function drawScale9():void
    {
        if (uvsNeedRecalc)
        {
            recalcUVs();
        }

        if (vertsNeedRecalc)
        {
            recalcVertsScale9();
        }

        var indices:Vector.<int>;

        switch (drawIndexSet)
        {
        case CORNER_PATCHES:
            indices = indicesCornerPatches;
            break;
        case NO_CENTER_COLUMN:
            indices = indicesNoCenterColumn;
            break;
        case NO_CENTER_ROW:
            indices = indicesNoCenterRow;
            break;
        case ALL:
            indices = indicesAll;
            break;
        default:
            assert(false, "Weird drawIndexSet: " + drawIndexSet);
        }

        graphics.beginBitmapFill(_bitmapData, null, false, _smoothing);
        graphics.drawTriangles(verts, indices, uvs);
        graphics.endFill();
    }

    /*   0,1-----2,3-----4,5-----6,7
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *   8,9----10,11---12,13---14,15
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *  16,17---18,19---20,21---22,23
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *  24,25---26,27---28,29---30,31  */

    private function recalcUVs():void
    {
        uvs[2] = uvs[10] = uvs[18] = uvs[26] = _scale9Grid.x / _bitmapData.width;
        uvs[4] = uvs[12] = uvs[20] = uvs[28] = _scale9Grid.right / _bitmapData.width;
        uvs[9] = uvs[11] = uvs[13] = uvs[15] = _scale9Grid.y / _bitmapData.height;
        uvs[17] = uvs[19] = uvs[21] = uvs[23] = _scale9Grid.bottom / _bitmapData.height;
    }

    private function recalcVertsScale9():void
    {
        var rightStripStart:Number = _width - 1 - _bitmapData.width + _scale9Grid.right;
        if (rightStripStart > _scale9Grid.x)
        {
            drawIndexSet = CENTER_COLUMN;
            verts[2] = verts[10] = verts[18] = verts[26] = _scale9Grid.x;
            verts[4] = verts[12] = verts[20] = verts[28] = rightStripStart;
        }
        else
        {
            drawIndexSet = 0;
            verts[2] = verts[10] = verts[18] = verts[26] =
            verts[4] = verts[12] = verts[20] = verts[28] =
                _width * _scale9Grid.x / (_bitmapData.width - _scale9Grid.width);
        }
        verts[6] = verts[14] = verts[22] = verts[30] = _width - 1;

        var bottomStripStart:Number = _height - 1 - _bitmapData.height + _scale9Grid.bottom;
        if (bottomStripStart > _scale9Grid.y)
        {
            drawIndexSet |= CENTER_ROW;
            verts[9] = verts[11] = verts[13] = verts[15] = _scale9Grid.y;
            verts[17] = verts[19] = verts[21] = verts[23] = bottomStripStart;
        }
        else
        {
            verts[9] = verts[11] = verts[13] = verts[15] =
            verts[17] = verts[19] = verts[21] = verts[23] =
                _height * _scale9Grid.y / (_bitmapData.height - _scale9Grid.height);
        }
        verts[25] = verts[27] = verts[29] = verts[31] = _height - 1;
    }

    private function invalidate():void
    {
        if (stage) stage.invalidate();
    }

    private function onAddedToStage(event:Event):void
    {
        stage.addEventListener(Event.RENDER, onRender);
        redraw();
    }

    private function onRemovedFromStage(event:Event):void
    {
        stage.removeEventListener(Event.RENDER, onRender);
    }

    private function onRender(event:Event):void
    {
        redraw();
    }

    /*    0 ----- 1 ----- 2 ----- 3
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *    4 ----- 5 ----- 6 ----- 7
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *    8 ----- 9 ---- 10 ---- 11
     *    |     / |     / |     / |
     *    |   /   |   /   |   /   |
     *    | /     | /     | /     |
     *   12 ---- 13 ---- 14 ---- 15  */

    private static function get indicesAll():Vector.<int>
    {
        if (!_indicesAll)
        {
            _indicesAll = Vector.<int>([
                 0,  4,  1,    4,  1,  5,
                 1,  5,  2,    5,  2,  6,
                 2,  6,  3,    6,  3,  7,

                 4,  8,  5,    8,  5,  9,
                 5,  9,  6,    9,  6, 10,
                 6, 10,  7,    7, 10, 11,

                 8, 12,  9,   12,  9, 13,
                 9, 13, 10,   13, 10, 14,
                10, 14, 11,   14, 11, 15
            ]);
            _indicesAll.fixed = true;
        }
        return _indicesAll;
    }

    private static function get indicesNoCenterRow():Vector.<int>
    {
        if (!_indicesNoCenterRow)
        {
            _indicesNoCenterRow = Vector.<int>([
                 0,  4,  1,    4,  1,  5,
                 1,  5,  2,    5,  2,  6,
                 2,  6,  3,    6,  3,  7,

                 8, 12,  9,   12,  9, 13,
                 9, 13, 10,   13, 10, 14,
                10, 14, 11,   14, 11, 15
            ]);
            _indicesNoCenterRow.fixed = true;
        }
        return _indicesNoCenterRow;
    }

    private static function get indicesNoCenterColumn():Vector.<int>
    {
        if (!_indicesNoCenterColumn)
        {
            _indicesNoCenterColumn = Vector.<int>([
                 0,  4,  1,    4,  1,  5,
                 2,  6,  3,    6,  3,  7,

                 4,  8,  5,    8,  5,  9,
                 6, 10,  7,    7, 10, 11,

                 8, 12,  9,   12,  9, 13,
                10, 14, 11,   14, 11, 15
            ]);
            _indicesNoCenterColumn.fixed = true;
        }
        return _indicesNoCenterColumn;
    }

    private static function get indicesCornerPatches():Vector.<int>
    {
        if (!_indicesCornerPatches)
        {
            _indicesCornerPatches = Vector.<int>([
                 0,  4,  1,    4,  1,  5,
                 2,  6,  3,    6,  3,  7,

                 8, 12,  9,   12,  9, 13,
                10, 14, 11,   14, 11, 15
            ]);
            _indicesCornerPatches.fixed = true;
        }
        return _indicesCornerPatches;
    }

    private static function get indicesCorners():Vector.<int>
    {
        if (!_indicesCorners)
        {
            _indicesCorners = Vector.<int>([
                 0, 12, 3,  12, 3, 15
            ]);
            _indicesCorners.fixed = true;
        }
        return _indicesCorners;
    }

    private static function clampRect(rect:Rectangle, outer:Rectangle):Rectangle
    {
        var newLeft:Number = clamp(rect.left, outer.left, outer.right);
        var newRight:Number = clamp(rect.right, outer.left, outer.right);
        var newTop:Number = clamp(rect.top, outer.top, outer.bottom);
        var newBottom:Number = clamp(rect.bottom, outer.top, outer.bottom);

        return new Rectangle(newLeft, newTop, newRight - newLeft, newBottom - newTop);
    }

    private static function clamp(v:Number, min:Number, max:Number):Number
    {
        return v < min ? min :
               v > max ? max :
                         v;
    }
}
}
