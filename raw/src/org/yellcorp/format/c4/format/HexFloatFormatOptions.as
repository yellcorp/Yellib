package org.yellcorp.format.c4.format
{
public class HexFloatFormatOptions extends FloatFormatOptions
{
    public var radixPrefix:String = "0x";

    public function HexFloatFormatOptions(options:Object = null)
    {
        exponentDelimiter = "p";
        exponentSigns = new SignSet("", "", "-", "");
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
}
}
