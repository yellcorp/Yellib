package org.yellcorp.format.printf.options
{
public class HexFloatFormatOptions extends FloatFormatOptions
{
    public var radixPrefix:String;

    public function HexFloatFormatOptions(options:Object = null)
    {
        super(options);
    }

    public override function copyFrom(other:CommonFormatOptions):void
    {
        super.copyFrom(other);

        var hexOpts:HexFloatFormatOptions = other as HexFloatFormatOptions;

        if (hexOpts)
        {
            radixPrefix = hexOpts.radixPrefix;
        }
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        fracWidth = Number.NaN;
        exponentDelimiter = "p";
        exponentSigns = new SignSet("", "", "-", "");
        exponentWidth = 1;
        radixPrefix = "0x";
    }
}
}
