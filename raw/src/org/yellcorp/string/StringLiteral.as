package org.yellcorp.string
{
public class StringLiteral
{
    private static const escapeChars:RegExp = new RegExp(
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
                // Can't be matched - these characters are seen by the
                // regex parser as ? (question mark 0x3F)
                //"\ud800-\udfff" +

                // BMP Private Use Area
                "\ue000-\uf8ff" +
            "]", "g");

    private static const standardSequences:Array = [ ];

    {
        standardSequences[0x08] = "\\b";
        standardSequences[0x09] = "\\t";
        standardSequences[0x0a] = "\\n";
        standardSequences[0x0c] = "\\f";
        standardSequences[0x0d] = "\\r";
        standardSequences[0x5c] = "\\\\";
    }

    public static function escape(text:String):String
    {
        return text ? text.replace(escapeChars, getEscapeSequence) : "";
    }

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

    public static function getEscapeSequence(char:String, ... ignored):String
    {
        var code:uint = char.charCodeAt(0);
        var sequence:String = standardSequences[code];

        if (!sequence)
        {
            sequence = "\\u" + StringUtil.padLeft(code.toString(16), 4, "0");
        }

        return sequence;
    }
}
}
