package org.yellcorp.format.printf.format
{
public class FloatFormatOptions extends NumberFormatOptions
{
    public var fracWidth:Number = 6;
    public var forceDecimalSeparator:Boolean = false;

    public var exponentWidth:uint = 2;
    public var exponentDelimiter:String = "e";
    public var exponentSigns:SignSet = new SignSet("+", "", "-", "");

    public function FloatFormatOptions(options:Object = null)
    {
        super(options);
    }

    public override function copyFrom(other:CommonFormatOptions):void
    {
        super.copyFrom(other);

        var floatOpts:FloatFormatOptions = other as FloatFormatOptions;

        if (floatOpts)
        {
            fracWidth = floatOpts.fracWidth;
            forceDecimalSeparator = floatOpts.forceDecimalSeparator;
            exponentWidth = floatOpts.exponentWidth;
            exponentDelimiter = floatOpts.exponentDelimiter;
            exponentSigns = floatOpts.exponentSigns.clone();
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        fracWidth = isNaN(flags.precision) ? 6 : flags.precision;
        forceDecimalSeparator = flags.alternateForm;
    }
}
}
