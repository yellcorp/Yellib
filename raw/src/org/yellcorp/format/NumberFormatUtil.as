package org.yellcorp.format
{
// TODO: does this work with -ve numbers?
public class NumberFormatUtil
{
    public static function groupNumber(
        number:Number,
        radixChar:String = ".",
        groupChar:String = ",",
        groupSize:uint = 3):String
    {
        return groupNumberStr(number.toString(), radixChar, groupChar, groupSize);
    }

    public static function groupNumberStr(
        numString:String,
        radixChar:String = ".",
        groupChar:String = ",",
        groupSize:uint = 3):String
    {
        var intPart:String;
        var point:int;
        var intResult:String = "";
        var fracPart:String;

        var i:int;

        if (numString == "") return "";
        if (groupSize == 0) return numString;

        point = numString.indexOf(".");

        if (point >= 0)
        {
            intPart = numString.substr(0, point);
            fracPart = numString.substr(point + 1);
        }
        else
        {
            intPart = numString;
        }

        if (intPart.length > groupSize)
        {
            i = intPart.length % groupSize;
            if (i > 0)
            {
                intResult = intPart.substr(0, i);
            }
            while (i < intPart.length)
            {
                intResult += (intResult == "" ? "" : groupChar) +
                             intPart.substr(i, groupSize);

                i += groupSize;
            }
        }
        else
        {
            intResult = intPart;
        }

        if (point >= 0)
        {
            intResult += radixChar + fracPart;
        }

        return intResult;
    }

    public static function localizeNumberSeparators(
        number:Number,
        radixChar:String = ".",
        groupChar:String = ","):String
    {
        return localizeNumberSeparatorsStr(number.toString(), radixChar, groupChar);
    }

    public static function localizeNumberSeparatorsStr(
        floatStr:String,
        radixChar:String = ".",
        groupChar:String = ","):String
    {
        var intPart:String;
        var fracPart:String;
        var intSep:int;

        if (groupChar == "," && radixChar == ".") return floatStr;

        intSep = floatStr.indexOf(".");

        if (intSep < 0)
        {
            return floatStr.replace(",", groupChar);
        }
        else
        {
            intPart = floatStr.substr(0, intSep);
            fracPart = floatStr.substr(intSep + 1);

            return intPart.replace(",", groupChar) + radixChar + fracPart;
        }
    }
}
}
