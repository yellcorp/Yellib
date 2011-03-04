package scratch.regexengine.charrender
{
import org.yellcorp.string.StringUtil;


public class ASCIIEscaper implements CharRenderer
{
    public function isCodepointSupported(codepoint:uint):Boolean
    {
        return codepoint >= 0 && codepoint <= 0xFF;
    }

    public function getRegexToken(codepoint:uint):String
    {
        return "\\x" + StringUtil.padLeft(codepoint.toString(16), 2, "0");
    }

    public function get name():String
    {
        return "ax";
    }
}
}
