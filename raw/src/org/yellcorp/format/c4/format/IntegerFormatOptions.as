package org.yellcorp.format.c4.format
{
public class IntegerFormatOptions extends NumberFormatOptions
{
    public var base:int = 10;
    public var minDigits:int = 1;
    public var radixPrefix:String = "";

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
}
}
