package org.yellcorp.text
{
public class EnglishUtil
{
    private static var unitWords:Array = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    private static var teenWords:Array = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];
    private static var tenWords:Array = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
    private static var powerWords:Array = ["thousand", "million", "billion", "trillion", "quadrillion", "quintillion"];

    /**
     * Formats a list as part of an English sentence.  Accepts
     * <code>clauses</code> as an Array of Strings, inserts
     * <code>conj</code> between the last pair, and joins the rest with
     * <code>punct</code>, which defaults to a comma and space.
     *
     * @param clauses An array of strings
     * @param conj    String to insert between the last pair in <code>clauses</code>
     * @param punct   String to insert between all other pairs.
     * @return        The formatted String
     */
    public static function joinList(clauses:Array, conj:String, punct:String = ", "):String
    {
        if (!clauses)
        {
            return "";
        }
        else if (clauses.length <= 2)
        {
            return clauses.join(conj);
        }
        else
        {
            return clauses.slice(0, -1).join(punct) + conj + clauses[clauses.length - 1];
        }
    }

    /**
     * Spells an integer as a natural language English phrase.
     *
     * @param num The integer to spell.
     * @param negativeWord The prefix used to refer to a number less than
     *                     zero. Typically "negative" or "minus".
     *                     @default"negative".
     * @param useAnd If <code>true</code>, insert the word 'and' between
     *               hundreds units and tens/ones, in line with typical
     *               British English usage.  If <code>false</code>, omit
     *               'and' in line with typical American English usage.
     */
    // TODO: 'and' not quite right - what about 'one million and one?'

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
