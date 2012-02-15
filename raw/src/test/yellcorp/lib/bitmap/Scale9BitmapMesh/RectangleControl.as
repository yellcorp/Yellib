package test.yellcorp.lib.bitmap.Scale9BitmapMesh
{
import org.yellcorp.lib.ui.BaseDisplay;

import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;


[Event(name="change", type="flash.events.Event")]
public class RectangleControl extends BaseDisplay
{
    private static const LEFT:uint = 1;
    private static const RIGHT:uint = 2;
    private static const HCENTER:uint = 4;

    private static const TOP:uint = 8;
    private static const BOTTOM:uint = 16;
    private static const VCENTER:uint = 32;

    private var _strokeWidth:Number;
    private var _strokeColor:uint;
    private var _fillColor:uint;


    private var dragStartSize:Rectangle;
    private var dragZone:uint;
    private var leftDiff:Number;
    private var topDiff:Number;
    private var rightDiff:Number;
    private var bottomDiff:Number;

    public function RectangleControl(
        initialWidth:Number = 0, initialHeight:Number = 0,
        strokeWidth:Number = 1,
        strokeColor:uint = 0xFFFFFFFF,
        fillColor:uint = 0xFF000000)
    {
        super(initialWidth, initialHeight);
        _strokeWidth = strokeWidth;
        _strokeColor = strokeColor;
        _fillColor = fillColor;
        drawSize();

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    public function get strokeWidth():Number
    {
        return _strokeWidth;
    }

    public function set strokeWidth(new_strokeWidth:Number):void
    {
        if (_strokeWidth !== new_strokeWidth)
        {
            _strokeWidth = new_strokeWidth;
        }
    }

    public function get strokeColor():uint
    {
        return _strokeColor;
    }

    public function set strokeColor(new_strokeColor:uint):void
    {
        _strokeColor = new_strokeColor;
    }

    public function get fillColor():uint
    {
        return _fillColor;
    }

    public function set fillColor(new_fillColor:uint):void
    {
        if (_fillColor !== new_fillColor)
        {
            _fillColor = new_fillColor;
        }
    }

    protected override function draw():void
    {
        if (isInvalid(SIZE))
        {
            drawSize();
        }
    }

    private function onMouseDown(event:MouseEvent):void
    {
        dragStartSize = new Rectangle(x, y, _width, _height);

        leftDiff = dragStartSize.left - event.stageX;
        topDiff = dragStartSize.top - event.stageY;
        rightDiff = dragStartSize.right - event.stageX;
        bottomDiff = dragStartSize.bottom - event.stageY;

        if (event.localX < _width * .25)
        {
            dragZone = LEFT;
        }
        else if (event.localX > _width * .75)
        {
            dragZone = RIGHT;
        }
        else
        {
            dragZone = HCENTER;
        }

        if (event.localY < _height * .25)
        {
            dragZone |= TOP;
        }
        else if (event.localY > _height * .75)
        {
            dragZone |= BOTTOM;
        }
        else
        {
            dragZone |= VCENTER;
        }

        stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onMouseMove(event:MouseEvent):void
    {
        if (dragZone == (HCENTER | VCENTER))
        {
            x = leftDiff + event.stageX;
            y = topDiff + event.stageY;
        }
        else
        {
            var newLeft:Number = dragStartSize.left;
            var newTop:Number = dragStartSize.top;
            var newRight:Number = dragStartSize.right;
            var newBottom:Number = dragStartSize.bottom;

            if (dragZone & LEFT)
            {
                newLeft = leftDiff + event.stageX;
            }
            else if (dragZone & RIGHT)
            {
                newRight = rightDiff + event.stageX;
            }

            if (dragZone & TOP)
            {
                newTop = topDiff + event.stageY;
            }
            else if (dragZone & BOTTOM)
            {
                newBottom = bottomDiff + event.stageY;
            }
            setEdges(newLeft, newTop, newRight, newBottom);
        }
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function setEdges(newLeft:Number, newTop:Number, newRight:Number, newBottom:Number):void
    {
        if (newLeft <= newRight)
        {
            x = newLeft;
            width = newRight - newLeft;
        }
        else
        {
            x = newRight;
            width = newLeft - newRight;
        }

        if (newTop <= newBottom)
        {
            y = newTop;
            height = newBottom - newTop;
        }
        else
        {
            y = newBottom;
            height = newTop - newBottom;
        }
    }

    private function onMouseUp(event:MouseEvent):void
    {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function drawSize():void
    {
        graphics.clear();
        if (_width <= 0 || _height <= 0) return;

        if (_strokeWidth > 0)
        {
            graphics.lineStyle(
                _strokeWidth, getRGB(_strokeColor), getAlpha(_strokeColor),
                false, LineScaleMode.NONE, null, JointStyle.MITER);
        }
        graphics.beginFill(getRGB(_fillColor), getAlpha(_fillColor));
        graphics.drawRect(_strokeWidth / 2, _strokeWidth / 2,
            _width - _strokeWidth, _height - _strokeWidth);
    }

    private static function getRGB(argb:uint):uint
    {
        return argb & 0xFFFFFF;
    }

    private static function getAlpha(argb:uint):Number
    {
        return (argb >>> 24) / 0xFF;
    }
}
}
