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
