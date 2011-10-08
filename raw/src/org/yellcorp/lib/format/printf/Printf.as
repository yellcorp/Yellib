package org.yellcorp.lib.format.printf
{
import org.yellcorp.lib.format.printf.parser.PrintfParser;


public class Printf
{
    private static var parser:PrintfParser;

    public static function sprintf(format:String, ... args):String
    {
        if (!parser)
        {
            parser = new PrintfParser();
        }
        return parser.format(format, args);
    }

    public static function sprintfa(format:String, args:Array):String
    {
        if (!parser)
        {
            parser = new PrintfParser();
        }
        return parser.format(format, args);
    }
}
}
