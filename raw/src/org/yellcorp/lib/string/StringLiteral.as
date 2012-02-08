package org.yellcorp.lib.string
{
import org.yellcorp.lib.core.StringUtil;


/**
 * Utilities for turning Strings into their AS3 literal representations.
 * Useful for debugging, code generation, text interchange.
 */
public class StringLiteral
{
    private static var _escapeChars:RegExp;
    private static function get escapeChars():RegExp
    {
        if (!_escapeChars)
        {
            _escapeChars = new RegExp(
            "[" +
                // Cc "Other, control"
                // c0 control codes
                "\\x00-\\x1f" +

                // backslash
                "\\\\" +

                // DEL and c1 control codes
                "\\x7f-\\x9f" +

                // Cf "Other, format"
                "\u00ad" +
                "\u0600-\u0603" +
                "\u06dd" +
                "\u070f" +
                "\u17b4" +
                "\u17b5" +
                "\u200b-\u200f" +
                "\u202a-\u202e" +

                "\u2060-\u2063" +

                // U+2064 Invisible Plus

                // Doesn't match - including this char in both this
                // expression and the test against it causes the test
                // to fail.

                // Unique in the 2060-2064 range as it was introduced in
                // Unicode version 5.1.0

                // So probably too new

                //"\u2064" +

                "\u206a-\u206f" +
                "\ufeff" +
                "\ufff9-\ufffb" +

                // Zl "Seperator, Line"
                "\u2028" +

                // Zp "Seperator, Paragraph"
                "\u2029" +

                // Cs "Other, Surrogate"
                // These are UTF-16 surrogates and can't be matched.
                //"\ud800-\udfff" +

                // BMP Private Use Area
                "\ue000-\uf8ff" +
            "]", "g");
        }
        return _escapeChars;
    }

    private static var _standardSequences:Object;
    private static function get standardSequences():Object
    {
        if (!_standardSequences)
        {
            _standardSequences = { };
            _standardSequences["\b"] = "\\b";
            _standardSequences["\t"] = "\\t";
            _standardSequences["\n"] = "\\n";
            _standardSequences["\f"] = "\\f";
            _standardSequences["\r"] = "\\r";
            _standardSequences["\\"] = "\\\\";
        }
        return _standardSequences;
    }

    /**
     * Return a string with special characters escaped.
     */
    public static function escape(text:String):String
    {
        return text ? text.replace(escapeChars, getEscapeSequence) : "";
    }

    /**
     * Returns a quoted string with special characters and delimiting
     * quotes escaped.
     */
    public static function quote(text:String, quoteChar:String = '"'):String
    {
        if (!quoteChar || quoteChar.length != 1)
        {
            throw new ArgumentError("quoteChar must be a String of length 1");
        }

        if (text)
        {
            return quoteChar +
                escape(text).replace(quoteChar, "\\" + quoteChar) +
                quoteChar;
        }
        else
        {
            return quoteChar + quoteChar;
        }
    }

    /**
     * Returns the escape sequence for a given character.
     */
    public static function getEscapeSequence(char:String, ... ignored):String
    {
        var sequence:String = standardSequences[char];

        if (!sequence)
        {
            sequence = "\\u" + StringUtil.padLeft(
                char.charCodeAt(0).toString(16), 4, "0");
        }
        return sequence;
    }
}
}
