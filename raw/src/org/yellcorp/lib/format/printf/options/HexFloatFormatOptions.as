package org.yellcorp.lib.format.printf.options
{
public class HexFloatFormatOptions extends FloatFormatOptions
{
    public var basePrefix:String;

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
            basePrefix = hexOpts.basePrefix;
        }
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        fractionalWidth = Number.NaN;
        exponentDelimiter = "p";
        exponentSigns = new SignSet("", "", "-", "");
        exponentWidth = 1;
        basePrefix = "0x";
    }
}
}
