package org.yellcorp.format.printf.format
{
public class NumberFormatOptions extends CommonFormatOptions
{
    public var paddingChar:String = " ";
    public var grouping:Boolean = false;
    public var signs:SignSet = new SignSet("", "", "-", "");

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
            paddingChar = numOpts.paddingChar;
            grouping = numOpts.grouping;
            signs = numOpts.signs.clone();
        }
    }

    public override function setFromFlags(flags:Flags):void
    {
        super.setFromFlags(flags);

        if (flags.zeroPad)
        {
            paddingChar = "0";
        }

        grouping = flags.grouping;

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
            signs.positive.setSigns("(", ")");
        }
    }
}
}
