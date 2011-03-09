package org.yellcorp.format.printf.options
{
public class IntegerFormatOptions extends NumberFormatOptions
{
    public var base:int;
    public var minDigits:int;
    public var basePrefix:String;

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
            basePrefix = intOpts.basePrefix;
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
                    basePrefix = "0";
                    break;

                case 16:
                    basePrefix = "0x";
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
        basePrefix = "";
    }
}
}
