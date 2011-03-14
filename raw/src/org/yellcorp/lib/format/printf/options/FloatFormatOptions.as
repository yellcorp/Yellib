package org.yellcorp.lib.format.printf.options
{
import org.yellcorp.lib.locale.Locale;


public class FloatFormatOptions extends NumberFormatOptions
{
    public var fractionalWidth:Number;
    public var radixPoint:String;
    public var forceRadixPoint:Boolean;

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
            fractionalWidth = floatOpts.fractionalWidth;
            radixPoint = floatOpts.radixPoint;
            forceRadixPoint = floatOpts.forceRadixPoint;
            exponentWidth = floatOpts.exponentWidth;
            exponentDelimiter = floatOpts.exponentDelimiter;
            exponentSigns = floatOpts.exponentSigns.clone();
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        super.setFromFlags(flags);
        fractionalWidth = isNaN(flags.precision) ? 6 : flags.precision;
        forceRadixPoint = flags.alternateForm;
    }

    public override function setFromLocale(locale:Locale):void
    {
        super.setFromLocale(locale);
        radixPoint = locale.radixPoint;
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        fractionalWidth = 6;
        radixPoint = ".";
        forceRadixPoint = false;
        exponentWidth = 2;
        exponentDelimiter = "e";
        exponentSigns = new SignSet("+", "", "-", "");
    }
}
}
