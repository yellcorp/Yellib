package org.yellcorp.lib.binary
{
import flash.utils.ByteArray;
import flash.utils.Endian;


/* Heavily based on http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/
 * by Jean-Philippe Auclair
 *
 * Added support for Base64 variations a la Apache Commons - padding can be
 * disabled, + and / characters can be swapped with their url-safe equivalents
 * - and _.
 *
 * Lookups are built procedurally and cached
 */

public class Base64
{
    private static const COMMON_CHARSET:String =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    private static const STANDARD_CHARSET:String = COMMON_CHARSET + "+/";

    private static const URL_CHARSET:String = COMMON_CHARSET + "-_";

    private static var _standardEncodeTable:Array;
    private static var _urlSafeEncodeTable:Array;
    private static var _decodeTable:Array;


    public static function encode(binary:ByteArray, padding:Boolean = true, urlSafe:Boolean = false):String
    {
        return encodeUsing(binary,
            urlSafe ? getURLSafeEncodeTable() : getStandardEncodeTable(),
            padding ? "=" : "");
    }


    public static function decode(text:String):ByteArray
    {
        return decodeUsing(text, getDecodeTable());
    }


    public static function getEncodedLength(numBytes:int, padding:Boolean = true):int
    {
        return padding ? Math.ceil(numBytes / 3) * 4
                       : Math.ceil(numBytes * 4 / 3);
    }


    private static function encodeUsing(input:ByteArray, table:Array, paddingChar:String):String
    {
        var output:ByteArray;

        var remain:int = input.length;
        var inWord:uint;
        var outWord:uint;
        var i:int = 0;

        var usePadding:Boolean = paddingChar.length == 1;
        var paddingCharCode:uint = usePadding ? paddingChar.charCodeAt(0) : 0;

        if (paddingChar.length > 1)
        {
            throw new ArgumentError("Padding char must be one character long, or an empty string");
        }

        input.endian = Endian.BIG_ENDIAN;

        output = new ByteArray();
        output.endian = Endian.BIG_ENDIAN;
        output.length = getEncodedLength(remain, usePadding);

        while (remain >= 3)
        {
            // 10987654321098765432109876543210
            //         AAAAAAAABBBBBBBBCCCCCCCC
            // --AAAAAA--AABBBB--BBBBCC--CCCCCC
            inWord = input[i++] << 16 |
                     input[i++] <<  8 |
                     input[i++];

            outWord = table[inWord >>> 18] << 24 |
                      table[inWord >>> 12 & 0x3f] << 16 |
                      table[inWord >>>  6 & 0x3f] <<  8 |
                      table[inWord & 0x3f];

            output.writeUnsignedInt(outWord);

            remain -= 3;
        }

        if (usePadding)
        {
            switch (remain)
            {
            case 1:
            // 10987654321098765432109876543210
            //                         AAAAAAAA
            // --AAAAAA--AA0000--======--======
                inWord = input[i++];
                outWord = table[inWord >>> 2] << 24 |
                          table[inWord  << 4] << 16 |
                          paddingCharCode * 0x101;

                output.writeUnsignedInt(outWord);
                break;

            case 2:
            // 10987654321098765432109876543210
            //                 AAAAAAAABBBBBBBB
            // --AAAAAA--AABBBB--BBBB00--======
                inWord = input[i++] << 8 |
                         input[i++];

                outWord = table[inWord >>> 10] << 24 |
                          table[inWord >>>  4 & 0x3f] << 16 |
                          table[inWord  <<  2 & 0x3f] <<  8 |
                          paddingCharCode;

                output.writeUnsignedInt(outWord);
                break;
            }
        }
        else
        {
            switch (remain)
            {
            case 1:
                inWord = input[i++];
                outWord = table[inWord >>> 2] << 8 |
                          table[inWord  << 4];

                output.writeShort(outWord);
                break;

            case 2:
                inWord = input[i++] << 8 |
                         input[i++];

                outWord = table[inWord >>> 10] << 8 |
                          table[inWord >>>  4 & 0x3f];

                output.writeShort(outWord);

                outWord = table[inWord  <<  2 & 0x3f];

                output.writeByte(outWord);
                break;
            }
        }

        output.position = 0;
        return output.readUTFBytes(output.bytesAvailable);
    }


    private static function decodeUsing(input:String, table:Array):ByteArray
    {
        var b0:int, b1:int, b2:int, b3:int;

        var inBytes:ByteArray = new ByteArray();
        inBytes.endian = Endian.BIG_ENDIAN;
        inBytes.writeUTFBytes(input);

        var output:ByteArray = new ByteArray();
        output.endian = Endian.BIG_ENDIAN;

        var i:int;
        var len:int = input.length;

        while (i < len)
        {
            do {
                b0 = table[inBytes[i++]];
            }
            while (i < len && b0 == -1);
            if (b0 == -1) break;

            do {
                b1 = table[inBytes[i++]];
            }
            while (i < len && b1 == -1);
            if (b1 == -1) break;

            // 5432109876543210
            // --AAAAAA--AABBBB
            output.writeByte(b0 << 2 | b1 >> 4);

            do {
                b2 = table[inBytes[i++]];
            }
            while (i < len && b2 == -1);
            if (b2 == -1) break;

            // 76543210
            // --BBBBCC
            output.writeByte(b1 << 4 | b2 >> 2);

            do {
                b3 = table[inBytes[i++]];
            }
            while (i < len && b3 == -1);
            if (b3 == -1) break;

            // 76543210
            // --CCCCCC
            output.writeByte(b2 << 6 | b3);
        }
        output.position = 0;
        return output;
    }


    private static function getStandardEncodeTable():Array
    {
        if (!_standardEncodeTable)
        {
            _standardEncodeTable = createEncodeLookup(STANDARD_CHARSET);
        }
        return _standardEncodeTable;
    }


    private static function getURLSafeEncodeTable():Array
    {
        if (!_urlSafeEncodeTable)
        {
            _urlSafeEncodeTable = createEncodeLookup(URL_CHARSET);
        }
        return _urlSafeEncodeTable;
    }


    private static function getDecodeTable():Array
    {
        if (!_decodeTable)
        {
            _decodeTable = createDecodeLookup();
        }
        return _decodeTable;
    }


    private static function createEncodeLookup(charSet:String):Array
    {
        var lookup:Array = new Array(charSet.length);
        var len:int = charSet.length;
        for (var i:int; i < len; i++)
        {
            lookup[i] = charSet.charCodeAt(i);
        }
        return lookup;
    }


    private static function createDecodeLookup():Array
    {
        var lookup:Array = [ ];

        writeDecodeLookup(lookup, COMMON_CHARSET, 0);
        writeDecodeLookup(lookup, "+/", 62);
        writeDecodeLookup(lookup, "-_", 62);

        return lookup;
    }


    private static function writeDecodeLookup(lookup:Array, charSet:String, offset:int):void
    {
        var len:int = charSet.length;
        var code:int;

        var i:int;

        for (i = 0; i < len; i++)
        {
            code = charSet.charCodeAt(i);

            // avm abuse: make sure all assigns are in sequential indices
            // to prevent avm from switching the array to a hashtable
            while (lookup.length < code)
            {
                lookup.push(-1);
            }
            lookup[code] = i + offset;
        }
    }
}
}
