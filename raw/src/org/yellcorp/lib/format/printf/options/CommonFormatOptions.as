package org.yellcorp.lib.format.printf.options
{
public class CommonFormatOptions
{
    public var minWidth:int;
    public var leftJustify:Boolean;
    public var uppercase:Boolean;

    public function CommonFormatOptions(options:Object = null)
    {
        setDefaults();
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

    protected function setDefaults():void
    {
        minWidth = 0;
        leftJustify = false;
        uppercase = false;
    }
}
}
