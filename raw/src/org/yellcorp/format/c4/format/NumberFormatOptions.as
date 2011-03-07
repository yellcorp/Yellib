package org.yellcorp.format.c4.format
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
}
}
