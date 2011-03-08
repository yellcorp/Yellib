package org.yellcorp.format.printf
{
import org.yellcorp.format.printf.parser.Parser;


public class Printf
{
    private static var parser:Parser;

    public static function sprintf(format:String, ... args):String
    {
        if (!parser)
        {
            parser = new Parser();
        }
        return parser.format(format, args);
    }

    public static function sprintfa(format:String, args:Array):String
    {
        if (!parser)
        {
            parser = new Parser();
        }
        return parser.format(format, args);
    }
}
}
