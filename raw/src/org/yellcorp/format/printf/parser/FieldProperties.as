package org.yellcorp.format.printf.parser
{
import org.yellcorp.format.printf.context.RenderContext;
import org.yellcorp.format.printf.options.Flags;


public class FieldProperties implements Flags
{
    public var argValue:DynamicValue = new DynamicValue();

    public var widthValue:DynamicValue = new DynamicValue();
    public var precisionValue:DynamicValue = new DynamicValue();

    private var _leftJustify:Boolean;
    private var _alternateForm:Boolean;
    private var _positivePlus:Boolean;
    private var _positiveSpace:Boolean;
    private var _zeroPad:Boolean;
    private var _grouping:Boolean;
    private var _negativeParens:Boolean;
    private var _uppercase:Boolean;

    public function FieldProperties()
    {
        clear();
    }

    public function clear():void
    {
        argValue.clear();
        widthValue.clear();
        precisionValue.clear();

        _leftJustify =
        _alternateForm =
        _positivePlus =
        _positiveSpace =
        _zeroPad =
        _grouping =
        _negativeParens =
        _uppercase = false;
    }

    public function resolve(context:RenderContext, consumesArg:Boolean):void
    {
        if (consumesArg && !argValue.isSet)
        {
            argValue.setRelativeIndexArg(0, null);
        }
        else if (!consumesArg && argValue.isSet)
        {
            throw new FormatTokenError("Field doesn't support positional argument", argValue.token);
        }

        widthValue.resolve(context);
        precisionValue.resolve(context);
        argValue.resolve(context);
    }

    public function get leftJustify():Boolean
    {
        return _leftJustify;
    }

    public function set leftJustify(leftJustify:Boolean):void
    {
        _leftJustify = leftJustify;
    }

    public function get alternateForm():Boolean
    {
        return _alternateForm;
    }

    public function set alternateForm(alternateForm:Boolean):void
    {
        _alternateForm = alternateForm;
    }

    public function get positivePlus():Boolean
    {
        return _positivePlus;
    }

    public function set positivePlus(positivePlus:Boolean):void
    {
        _positivePlus = positivePlus;
    }

    public function get positiveSpace():Boolean
    {
        return _positiveSpace;
    }

    public function set positiveSpace(positiveSpace:Boolean):void
    {
        _positiveSpace = positiveSpace;
    }

    public function get zeroPad():Boolean
    {
        return _zeroPad;
    }

    public function set zeroPad(zeroPad:Boolean):void
    {
        _zeroPad = zeroPad;
    }

    public function get grouping():Boolean
    {
        return _grouping;
    }

    public function set grouping(grouping:Boolean):void
    {
        _grouping = grouping;
    }

    public function get negativeParens():Boolean
    {
        return _negativeParens;
    }

    public function set negativeParens(negativeParens:Boolean):void
    {
        _negativeParens = negativeParens;
    }

    public function get width():Number
    {
        return widthValue.getValue(0);
    }

    public function get precision():Number
    {
        return precisionValue.getValue(Number.NaN);
    }

    public function get uppercase():Boolean
    {
        return _uppercase;
    }

    public function set uppercase(uppercase:Boolean):void
    {
        _uppercase = uppercase;
    }
}
}
