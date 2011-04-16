package test.yellcorp.lib.color.Gradient
{
import org.yellcorp.lib.ui.BaseDisplay;

import flash.display.BitmapData;
import flash.geom.Rectangle;


public class CheckerBox extends BaseDisplay
{
    private var _checkWidth:int;
    private var _checkHeight:int;
    private var _color1:uint;
    private var _color2:uint;

    private var pattern:BitmapData;
    private var fillArea:Rectangle;

    public function CheckerBox(
        checkWidth:int, checkHeight:int, color1:uint, color2:uint,
        initialWidth:Number = 0, initialHeight:Number = 0)
    {
        super(initialWidth, initialHeight);
        this.checkWidth = checkWidth;
        this.checkHeight = checkHeight;
        this.color1 = color1;
        this.color2 = color2;
        fillArea = new Rectangle();
    }

    public function get checkWidth():int
    {
        return _checkWidth;
    }

    public function set checkWidth(new_checkWidth:int):void
    {
        if (_checkWidth !== new_checkWidth)
        {
            _checkWidth = new_checkWidth;
            invalidate(CONTENT);
        }
    }

    public function get checkHeight():int
    {
        return _checkHeight;
    }

    public function set checkHeight(new_checkHeight:int):void
    {
        if (_checkHeight !== new_checkHeight)
        {
            _checkHeight = new_checkHeight;
            invalidate(CONTENT);
        }
    }

    public function get color1():uint
    {
        return _color1;
    }

    public function set color1(new_color1:uint):void
    {
        if (_color1 !== new_color1)
        {
            _color1 = new_color1;
            invalidate(CONTENT);
        }
    }

    public function get color2():uint
    {
        return _color2;
    }

    public function set color2(new_color2:uint):void
    {
        if (_color2 !== new_color2)
        {
            _color2 = new_color2;
            invalidate(CONTENT);
        }
    }

    protected override function draw():void
    {
        if (isInvalid(CONTENT))
        {
            drawContent();
            drawSize();
        }
        else if (isInvalid(SIZE))
        {
            drawSize();
        }
    }

    private function drawContent():void
    {
        if (!(pattern
              && pattern.width == _checkWidth * 2
              && pattern.height == _checkHeight * 2))
        {
            if (pattern) pattern.dispose();
            pattern = new BitmapData(_checkWidth * 2, _checkHeight * 2, false, _color1);
        }
        else
        {
            pattern.fillRect(pattern.rect, _color1);
        }

        fillArea.width = _checkWidth;
        fillArea.height = _checkHeight;

        fillArea.x = _checkWidth;
        fillArea.y = 0;
        pattern.fillRect(fillArea, _color2);

        fillArea.x = 0;
        fillArea.y = _checkHeight;
        pattern.fillRect(fillArea, _color2);

        validate(CONTENT);
    }

    private function drawSize():void
    {
        graphics.clear();

        if (_width > 0 && _height > 0)
        {
            graphics.beginBitmapFill(pattern);
            graphics.drawRect(0, 0, _width, _height);
            graphics.endFill();
        }
        validate(SIZE);
    }
}
}
