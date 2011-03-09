package org.yellcorp.format.printf.options
{
public class GeneralFormatOptions extends CommonFormatOptions
{
    public var maxWidth:int;

    public function GeneralFormatOptions(options:Object = null)
    {
        super(options);
    }

    public override function copyFrom(other:CommonFormatOptions):void
    {
        super.copyFrom(other);

        var genOpts:GeneralFormatOptions = other as GeneralFormatOptions;

        if (genOpts)
        {
            maxWidth = genOpts.maxWidth;
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        super.setFromFlags(flags);
        // not supported: positive*, negative*, zeroPad, grouping
        maxWidth = isNaN(flags.precision) ? int.MAX_VALUE : flags.precision;
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        maxWidth = int.MAX_VALUE;
    }
}
}
