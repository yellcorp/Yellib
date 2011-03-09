package org.yellcorp.format.printf.options
{
import org.yellcorp.locale.Locale;


public class NumberFormatOptions extends CommonFormatOptions
{
    public var paddingCharacter:String;
    public var groupingCharacter:String;
    public var groupingSize:int;
    public var signs:SignSet;

    public function NumberFormatOptions(options:Object = null)
    {
        super(options);
    }

    public override function copyFrom(other:CommonFormatOptions):void
    {
        super.copyFrom(other);

        var numOpts:NumberFormatOptions = other as NumberFormatOptions;

        if (numOpts)
        {
            paddingCharacter = numOpts.paddingCharacter;
            groupingCharacter = numOpts.groupingCharacter;
            signs = numOpts.signs.clone();
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        super.setFromFlags(flags);

        if (flags.zeroPad)
        {
            paddingCharacter = "0";
        }

        groupingCharacter = flags.grouping ? "," : "";

        if (flags.positivePlus)
        {
            signs.positive.setSigns("+", "");
        }
        else if (flags.positiveSpace)
        {
            signs.positive.setSigns(" ", "");
        }

        if (flags.negativeParens)
        {
            signs.negative.setSigns("(", ")");
        }
    }

    public function setFromLocale(locale:Locale):void
    {
        groupingCharacter = locale.numberGroupingChar;
        groupingSize = locale.numberGroupingSize;
    }

    protected override function setDefaults():void
    {
        super.setDefaults();
        paddingCharacter = " ";
        groupingCharacter = "";
        groupingSize = 3;
        signs = new SignSet("", "", "-", "");
    }
}
}
