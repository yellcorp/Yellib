package org.yellcorp.display.shapes
{
import org.yellcorp.error.AbstractCallError;

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.events.Event;


public class BaseFilledOutlinedShape extends Shape
{
    private var _width:Number;
    private var _height:Number;

    private var _useFill:Boolean;
    private var _fillColor:uint;
    private var _fillAlpha:Number;

    private var _useLine:Boolean;
    private var _lineThickness:Number;
    private var _lineColor:uint;
    private var _lineAlpha:Number;
    private var _linePixelHinting:Boolean;
    private var _lineScaleMode:String;
    private var _lineCaps:String;
    private var _lineJoints:String;
    private var _lineMiterLimit:Number;

    private var qRedraw:Boolean;

    public function BaseFilledOutlinedShape(startWidth:Number, startHeight:Number)
    {
        super();

        _width = startWidth;
        _height = startHeight;

        _useFill = true;
        _fillColor = 0;
        _fillAlpha = 1;

        _lineThickness = 1;
        _lineColor = 0;
        _lineAlpha = 1;
        _linePixelHinting = false;
        _lineScaleMode = LineScaleMode.NONE;
        _lineCaps = CapsStyle.ROUND;
        _lineJoints = JointStyle.ROUND;
        _lineMiterLimit = 3;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
    }

    public override function get width():Number
    {
        return _width * scaleX;
    }

    public override function set width(new_width:Number):void
    {
        setProp("_width", new_width);
    }

    public override function get height():Number
    {
        return _height * scaleY;
    }

    public override function set height(new_height:Number):void
    {
        setProp("_height", new_height);
    }

    public function get useFill():Boolean  {  return _useFill;  }
    public function set useFill(new_useFill:Boolean):void  {  setProp("_useFill", new_useFill);  }

    public function get fillColor():uint  {  return _fillColor;  }
    public function set fillColor(new_fillColor:uint):void  {  setProp("_fillColor", new_fillColor);  }

    public function get fillAlpha():Number  {  return _fillAlpha;  }
    public function set fillAlpha(new_fillAlpha:Number):void  {  setProp("_fillAlpha", new_fillAlpha);  }

    public function get useLine():Boolean  {  return _useLine;  }
    public function set useLine(new_useLine:Boolean):void  {  setProp("_useLine", new_useLine);  }

    public function get lineThickness():Number  {  return _lineThickness;  }
    public function set lineThickness(new_lineThickness:Number):void  {  setProp("_lineThickness", new_lineThickness);  }

    public function get lineColor():uint  {  return _lineColor;  }
    public function set lineColor(new_lineColor:uint):void  {  setProp("_lineColor", new_lineColor);  }

    public function get lineAlpha():Number  {  return _lineAlpha;  }
    public function set lineAlpha(new_lineAlpha:Number):void  {  setProp("_lineAlpha", new_lineAlpha);  }

    public function get linePixelHinting():Boolean  {  return _linePixelHinting;  }
    public function set linePixelHinting(new_linePixelHinting:Boolean):void  {  setProp("_linePixelHinting", new_linePixelHinting);  }

    public function get lineScaleMode():String  {  return _lineScaleMode;  }
    public function set lineScaleMode(new_lineScaleMode:String):void  {  setProp("_lineScaleMode", new_lineScaleMode);  }

    public function get lineCaps():String  {  return _lineCaps;  }
    public function set lineCaps(new_lineCaps:String):void  {  setProp("_lineCaps", new_lineCaps);  }

    public function get lineJoints():String  {  return _lineJoints;  }
    public function set lineJoints(new_lineJoints:String):void  {  setProp("_lineJoints", new_lineJoints);  }

    public function get lineMiterLimit():Number  {  return _lineMiterLimit;  }
    public function set lineMiterLimit(new_lineMiterLimit:Number):void  {  setProp("_lineMiterLimit", new_lineMiterLimit);  }

    protected function draw(w:Number, h:Number):void
    {
        throw new AbstractCallError();
    }

    protected function queueRedraw():void
    {
        qRedraw = true;
        if (stage) stage.invalidate();
    }

    public function redraw():void
    {
        var g:Graphics = graphics;

        g.clear();

        if (_width == 0 || _height == 0) return;

        if (_useLine)
        {
            g.lineStyle(_lineThickness, _lineColor, _lineAlpha,
                        _linePixelHinting, _lineScaleMode,
                        _lineCaps, _lineJoints, _lineMiterLimit);
        }

        if (_useFill)
        {
            g.beginFill(_fillColor, _fillAlpha);
            draw(_width / scaleX, _height / scaleY);
            g.endFill();
        }
        else
        {
            draw(_width / scaleX, _height / scaleY);
        }
        qRedraw = false;
    }

    private function setProp(propName:String, newVal:*):void
    {
        if (this[propName] !== newVal)
        {
            this[propName] = newVal;
            queueRedraw();
        }
    }

    private function onAddedToStage(event:Event):void
    {
        stage.addEventListener(Event.RENDER, onRender, false, 0, true);
        queueRedraw();
    }

    private function onRemovedFromStage(event:Event):void
    {
        stage.removeEventListener(Event.RENDER, onRender);
    }

    private function onRender(event:Event):void
    {
        if (qRedraw)
        {
            redraw();
            qRedraw = false;
        }
    }
}
}
