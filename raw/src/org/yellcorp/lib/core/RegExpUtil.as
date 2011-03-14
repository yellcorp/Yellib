package org.yellcorp.lib.core
{
public class RegExpUtil
{
    public static const REGEX_CHARS:RegExp = /([\^$.*+?|\\()[\]{}])/g;

    public static function createLiteralRegExp(literalString:String, flags:String = ""):RegExp
    {
        return new RegExp(escapeRegExp(literalString), flags);
    }

    public static function createAlternates(literalAlternates:Array, capturing:Boolean, flags:String = ""):RegExp
    {
        var escapedAlternates:Array;
        var expression:String;

        escapedAlternates = literalAlternates.map(escapeRegExp);
        expression = (capturing ? "(" : "(?:") + escapedAlternates.join("|") + ")";

        return new RegExp(expression, flags);
    }

    // the extra unused args here are to allow this
    // function to be passed to Array.map
    public static function escapeRegExp(literalString:String, index:* = null, array:* = null):String
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
        var copyFlags:Object = {g: true, i: true, s: true, m: true, x: true};
        var newFlags:Array = [ ];
        var i:int;
        var char:String;

        for (i = 0; i < flagsToSet.length; i++)
        {
            char = flagsToSet.charAt(i);
            if (copyFlags[char])
            {
                delete copyFlags[char];
                newFlags.push(char);
            }
        }

        for (i = 0; i < flagsToUnset.length; i++)
        {
            char = flagsToSet.charAt(i);
            if (copyFlags[char])
            {
                delete copyFlags[char];
            }
        }

        if (regExp.global     && copyFlags["g"]) newFlags.push("g");
        if (regExp.ignoreCase && copyFlags["i"]) newFlags.push("i");
        if (regExp.dotall     && copyFlags["s"]) newFlags.push("s");
        if (regExp.multiline  && copyFlags["m"]) newFlags.push("m");
        if (regExp.extended   && copyFlags["x"]) newFlags.push("x");

        return new RegExp(regExp.source, newFlags.join(""));
    }
}
}
