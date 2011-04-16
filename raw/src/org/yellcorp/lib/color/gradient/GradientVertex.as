package org.yellcorp.lib.color.gradient
{
public class GradientVertex
{
    internal var owner:Gradient;

    internal var _param:Number;
    internal var _value:uint;

    public function GradientVertex(param:Number, value:uint)
    {
        _param = param;
        _value = value;
    }

    public function get param():Number
    {
        return _param;
    }

    public function set param(new_param:Number):void
    {
        if (_param !== new_param)
        {
            _param = new_param;
            if (owner) owner.stale = true;
        }
    }

    public function get value():uint
    {
        return _value;
    }

    public function set value(new_value:uint):void
    {
        if (_value !== new_value)
        {
            _value = new_value;
            if (owner) owner.stale = true;
        }
    }

    public function clone():GradientVertex
    {
        return new GradientVertex(_param, _value);
    }
}
}
