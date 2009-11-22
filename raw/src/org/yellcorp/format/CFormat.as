package org.yellcorp.format
{
import org.yellcorp.format.cformat.CFormatParser;
import org.yellcorp.format.cformat.CFormatTemplate;


// using http://www.opengroup.org/onlinepubs/000095399/functions/printf.html
// as a base, although of course a lot of stuff don't apply to AS
public class CFormat
{
    private static var parser:CFormatParser = new CFormatParser();

    public static function sprintf(format:String, ... args):String
    {
        return sprintfa(format, args);
    }

    public static function sprintfa(format:String, args:Array):String
    {
        var template:CFormatTemplate = parser.parse(format);
        return template.format(args);
    }
}
}

/*
                      '      0        -          [SPACE] or +  #
                      group  zeroPad  alignLeft  positiveSign  alternateForm  width  precision  caps
d  TYPE_DECIMAL_INT   y      y        y          y                            y      IGNORE 0
I  TYPE_DECIMAL_INT   y      y        y          y                            y      IGNORE 0
o  TYPE_OCTAL_INT            y        y                        y              y      IGNORE 0
u  TYPE_UNSIGNED_INT  y      y        y                                       y      IGNORE 0
x  TYPE_HEX_INT              y        y                        y              y      IGNORE 0   y
f  TYPE_FIX_FLOAT     y      y        y          y             y              y                 y
e  TYPE_EXP_FLOAT            y        y          y             y              y                 y
g  TYPE_VAR_FLOAT     y      y        y          y             y              y                 y
a  TYPE_HEX_FLOAT            y        y          y             y              y                 y
c  TYPE_CHAR                          y                                       y
s  TYPE_STRING                        y                                       y      y
p  TYPE_POINTER                       y                                       y
n  TYPE_NUMCHARS                      y                                       y
                                      IGNORE 0
*/
