package org.yellcorp.lib.debug
{
import org.yellcorp.lib.core.StringBuilder;
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.debug.dumputil.DisplayTreeDumper;
import org.yellcorp.lib.debug.dumputil.ObjectDumper;

import flash.display.DisplayObjectContainer;
import flash.utils.ByteArray;


public class DumpUtil
{
    public static function dumpDisplayTree(container:DisplayObjectContainer, maxDepth:int = 0):String
    {
        return getDisplayTreeDumper().dump(container, maxDepth);
    }

    private static var _displayTreeDumper:DisplayTreeDumper;

    private static function getDisplayTreeDumper():DisplayTreeDumper
    {
        if (!_displayTreeDumper)
        {
            _displayTreeDumper = new DisplayTreeDumper();
        }
        return _displayTreeDumper;
    }


    public static function dumpObject(root:*, maxDepth:int = 3,
            evaluateGetters:Boolean = false):String
    {
        return getObjectDumper().dump(root, maxDepth, evaluateGetters);
    }

    private static var _objectDumper:ObjectDumper;

    private static function getObjectDumper():ObjectDumper
    {
        if (!_objectDumper)
        {
            _objectDumper = new ObjectDumper();
        }
        return _objectDumper;
    }


    public static function dumpByteArray(byteArray:ByteArray, bytesPerLine:uint = 16, nonPrintingChar:String = "."):String
    {
        var byte:uint;
        var byteIndex:uint;
        var endOfLine:uint;

        var outputBuffer:StringBuilder = new StringBuilder();

        var valueString:String;
        var valueBuffer:StringBuilder = new StringBuilder();
        var valueBufferLength:uint = (bytesPerLine * 3);

        var charCodeBuffer:Array;
        var nonPrintingCharCode:uint;

        if (bytesPerLine == 0)
        {
            throw new ArgumentError("bytesPerLine must be greater than 0");
        }

        if (!nonPrintingChar || nonPrintingChar.length != 1)
        {
            throw new ArgumentError("nonPrintingChar must be a String of length 1");
        }

        nonPrintingCharCode = nonPrintingChar.charCodeAt(0);

        while (byteIndex < byteArray.length)
        {
            endOfLine = byteIndex + bytesPerLine;
            if (endOfLine > byteArray.length)
            {
                endOfLine = byteArray.length;
            }

            valueBuffer.clear();
            charCodeBuffer = [ ];

            outputBuffer.append(StringUtil.padLeft(
                    byteIndex.toString(16).toUpperCase(),
                    8, "0"));

            for (; byteIndex < endOfLine; byteIndex++)
            {
                byte = byteArray[byteIndex];

                valueString = byte.toString(16).toUpperCase();

                valueBuffer.append(byte < 0x10 ? " 0" : " ");
                valueBuffer.append(valueString);

                if ((byte >= 0x20 && byte <= 0x7E) ||
                        (byte >= 0xA0 && byte <= 0xAC) ||
                        (byte >= 0xAE && byte <= 0xFF))
                {
                    charCodeBuffer.push(byte);
                }
                else
                {
                    charCodeBuffer.push(nonPrintingCharCode);
                }
            }

            outputBuffer.appendMany(
                    StringUtil.padRight(
                        valueBuffer.toString(),
                        valueBufferLength, " "),
                    " ",
                    StringUtil.padRight(
                        String.fromCharCode.apply(String, charCodeBuffer),
                        bytesPerLine, " "),
                    "\n");
        }

        return outputBuffer.toString();
    }
}
}
