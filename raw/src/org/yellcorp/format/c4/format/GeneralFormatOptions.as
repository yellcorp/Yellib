package org.yellcorp.format.c4.format
{
public class GeneralFormatOptions extends CommonFormatOptions
{
    public var maxWidth:int = 0;

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
}
}
