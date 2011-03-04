package scratch.regexengine.regextest
{
import scratch.regexengine.charrender.CharRenderer;


public class Literal implements RegexTest
{
    public function getRegex(codepoint:uint, renderer:CharRenderer):RegExp
    {
        return new RegExp(renderer.getRegexToken(codepoint), "g");
    }

    public function isCodepointSupported(codepoint:uint):Boolean
    {
        return true;
    }

    public function get name():String
    {
        return "1l";
    }
}
}
