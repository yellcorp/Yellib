package org.yellcorp.format.printf.options
{
public class IntegerFormatOptions extends NumberFormatOptions
{
    public var base:int;
    public var minDigits:int;
    public var radixPrefix:String;

    public function IntegerFormatOptions(options:Object = null)
    {
        super(options);
    }

    public override function copyFrom(other:CommonFormatOptions):void
    {
        super.copyFrom(other);

        var intOpts:IntegerFormatOptions = other as IntegerFormatOptions;

        if (intOpts)
        {
            base = intOpts.base;
            minDigits = intOpts.minDigits;
            radixPrefix = intOpts.radixPrefix;
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        super.setFromFlags(flags);

        minDigits = flags.precision || 1;

        if (flags.alternateForm)
        {
            switch (base)
            {
                case 8:
                    radixPrefix = "0";
                    break;

                case 16:
                    radixPrefix = "0x";
                    break;

                default:
                    // ignore
                    break;
            }
        }
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        base = 10;
        minDigits = 1;
        radixPrefix = "";
    }
}
}
