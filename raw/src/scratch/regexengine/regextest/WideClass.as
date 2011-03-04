package scratch.regexengine.regextest
{
import scratch.regexengine.charrender.CharRenderer;


public class WideClass implements RegexTest
{
    public function getRegex(codepoint:uint, renderer:CharRenderer):RegExp
    {
        var low:int =  codepoint > 2 ? codepoint - 2 : 0;
        var high:int = codepoint < 0xFFFD ? codepoint + 2 : 0xFFFF;

        return new RegExp("[" +
            renderer.getRegexToken(low) +
            "-" +
            renderer.getRegexToken(high) +
            "]", "g");
    }

    public function isCodepointSupported(codepoint:uint):Boolean
    {
        return true;
    }

    public function get name():String
    {
        return "wc";
    }
}
}
