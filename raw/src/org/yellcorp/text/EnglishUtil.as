package org.yellcorp.text
{
public class EnglishUtil
{
    private static var unitWords:Array = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    private static var teenWords:Array = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];
    private static var tenWords:Array = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
    private static var powerWords:Array = ["thousand", "million", "billion", "trillion", "quadrillion", "quintillion"];

    public static function spellInteger(num:Number, negativeWord:String = "negative", useAnd:Boolean = true):String
    {
        var powers:Array;
        var result:Array;
        var resultStr:String;
        var i:int;
        var p:int;
        var isNeg:Boolean;

        if (num == 0) return "zero";

        powers = [ ];
        result = [ ];

        if (num < 0)
        {
            num = -num;
            isNeg = true;
        }

        while (num > 0)
        {
            powers.unshift(renderMod1000(num % 1000, useAnd));
            num = Math.floor(num / 1000);
        }

        p = powers.length - 2;
        for (i = 0; i < powers.length; i++)
        {
            if (powers[i])
            {
                result.push(p >= 0 ? powers[i] + " " + powerWords[p--]
                                   : powers[i]);
            }
        }

        resultStr = result.join(", ");

        return isNeg ? (negativeWord + " " + resultStr)
                     : resultStr;
    }

    private static function renderMod1000(number:Number, useAnd:Boolean):String
    {
        var hundreds:Number = Math.floor(number / 100);
        var tens:Number = number % 100;

        var hundredStr:String;

        if (hundreds > 0)
        {
            hundredStr = unitWords[hundreds] + " hundred";
            if (tens > 0)
            {
                return useAnd ? (hundredStr + " and " + renderMod100(tens))
                              : (hundredStr + " " + renderMod100(tens));
            }
            else
            {
                return hundredStr;
            }
        }
        else
        {
            return tens > 0 ? renderMod100(tens) : "";
        }
    }

    private static function renderMod100(tens:Number):String
    {
        var units:Number;

        if (tens < 10)
        {
            return unitWords[tens];
        }
        else if (tens < 20)
        {
            return teenWords[tens - 10];
        }
        else
        {
            units = tens % 10;
            tens = Math.floor(tens / 10);

            if (units == 0)
            {
                return tenWords[tens];
            }
            else
            {
                return tenWords[tens] + "-" + unitWords[units];
            }
        }
    }
}
}
