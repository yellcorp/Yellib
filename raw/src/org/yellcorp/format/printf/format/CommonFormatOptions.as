package org.yellcorp.format.printf.format
{
public class CommonFormatOptions
{
    public var minWidth:int = 0;
    public var leftJustify:Boolean = false;
    public var uppercase:Boolean = false;

    public function CommonFormatOptions(options:Object = null)
    {
        if (options is CommonFormatOptions)
        {
            copyFrom(CommonFormatOptions(options));
        }
        else if (options is Object)
        {
            for (var k:String in options)
            {
                this[k] = options[k];
            }
        }
    }

    public function copyFrom(other:CommonFormatOptions):void
    {
        minWidth = other.minWidth;
        leftJustify = other.leftJustify;
        uppercase = other.uppercase;
    }

    public function setFromFlags(flags:Flags):void
    {
        minWidth = flags.width;
        leftJustify = flags.leftJustify;
        uppercase = flags.uppercase;
    }
}
}