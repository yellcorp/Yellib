package org.yellcorp.binary
{
import org.yellcorp.string.StringUtil;

import flash.utils.ByteArray;


public class BinDump
{
    public static function dump(bin:ByteArray):String
    {
        var bytesPerRow:uint = 32;

        var flush:Boolean = false;
        var lineStart:uint = 0;
        var lines:Array = new Array();
        var uintArray:Array = new Array();

        var i:int;

        bin.position = 0;
        while (true)
        {
            if ((i > 0 && i % bytesPerRow == 0) || flush)
            {
                lines.push( [ formatLine(lineStart),
                              StringUtil.padRight(charDump(uintArray), bytesPerRow),
                              hexDump(uintArray)
                            ].join("  ") );

                uintArray = new Array();
                lineStart = i;
            }
            if (flush) break;
            try
            {
                uintArray.push(bin.readUnsignedByte());
            } catch (e:Error)
            {
                flush = true;
            }
            i++;
        }

        return lines.join("\n");
    }

    private static function formatLine(lineNum:uint):String
    {
        return StringUtil.padLeft(lineNum.toString(16), 8, "0");
    }

    private static function charDump(uintArray:Array):String
    {
        return uintArray.map(charByte).join("");
    }

    private static function charByte(byte:*, index:int, array:Array):String
    {
        var b:uint = byte as uint;
        return (b < 32 || b > 0x7f) ? "." : String.fromCharCode(b);
    }

    private static function hexDump(uintArray:Array):String
    {
        return uintArray.map(hexByte).join(" ");
    }

    private static function hexByte(byte:*, index:int, array:Array):String
    {
        return StringUtil.padLeft((byte as uint).toString(16), 2, "0");
    }
}
}
