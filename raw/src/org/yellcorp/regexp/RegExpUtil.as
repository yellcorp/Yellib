package org.yellcorp.regexp
{

import org.yellcorp.array.ArrayUtil;


public class RegExpUtil
{
    public static const REGEX_CHARS:RegExp = /(\^|\$|\\|\.|\*|\+|\?|\(|\)|\[|\]|\{|\}|\|)/g;

    public static function createLiteralRegExp(literalString:String, flags:String = ""):RegExp
    {
        return new RegExp(escapeRegExp(literalString), flags);
    }

    public static function createAlternates(literalAlternates:Array, capturing:Boolean, flags:String = ""):RegExp
    {
        var escapedAlternates:Array;
        var expression:String;

        escapedAlternates = literalAlternates.map(ArrayUtil.simpleCallback(escapeRegExp));
        expression = (capturing ? "(" : "(?:") + escapedAlternates.join("|") + ")";

        return new RegExp(expression, flags);
    }

    public static function escapeRegExp(literalString:String):String
    {
        return literalString.replace(REGEX_CHARS, "\\$1");
    }

    /**
     * Returns a copy of the passed-in RegExp with modified flags.
     * Flags are expressed as a string of characters in the style of
     * the RegExp constructor or suffix after the trailing slash, like
     * PERL.  Flags are copied from the original RegExp unless they are
     * specified in either flagsToSet or flagsToUnset.  Unrecognized flags
     * are ignored.  If a flag is specified in both flagsToSet and
     * flagsToUnset, it will be set.
     *
     * @param regExp The RegExp to return a modified copy of
     * @param flagsToSet A string of flags to enable in the new copy
     * @param flagsToUnset A string of flags to disable in the new copy
     * @return A modified copy of the RegExp
     */
    public static function changeFlags(regExp:RegExp, flagsToSet:String, flagsToUnset:String = ""):RegExp
    {
        var unspecFlags:Object = {g: true, i: true, s: true, m: true, x: true};
        var newFlagString:String = "";
        var i:int;
        var char:String;
        var copy:Boolean;

        for (i = 0; i < flagsToSet.length; i++)
        {
            char = flagsToSet.charAt(i);
            if (unspecFlags[char])
            {
                delete unspecFlags[char];
                newFlagString += char;
            }
        }

        for (i = 0; i < flagsToUnset.length; i++)
        {
            char = flagsToSet.charAt(i);
            if (unspecFlags[char])
            {
                delete unspecFlags[char];
            }
        }

        for (char in unspecFlags)
        {
            copy = false;
            switch (char)
            {
                case 'g' : copy = regExp.global; break;
                case 'i' : copy = regExp.ignoreCase; break;
                case 's' : copy = regExp.dotall; break;
                case 'm' : copy = regExp.multiline; break;
                case 'x' : copy = regExp.extended; break;
            }
            if (copy) newFlagString += char;
        }

        return new RegExp(regExp.source, newFlagString);
    }
}
}
