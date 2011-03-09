package org.yellcorp.format.printf.options
{
public class FloatFormatOptions extends NumberFormatOptions
{
    public var fracWidth:Number;
    public var forceDecimalSeparator:Boolean;

    public var exponentWidth:uint;
    public var exponentDelimiter:String;
    public var exponentSigns:SignSet;

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
        super.setFromFlags(flags);
        fracWidth = isNaN(flags.precision) ? 6 : flags.precision;
        forceDecimalSeparator = flags.alternateForm;
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        fracWidth = 6;
        forceDecimalSeparator = false;
        exponentWidth = 2;
        exponentDelimiter = "e";
        exponentSigns = new SignSet("+", "", "-", "");
    }
}
}
