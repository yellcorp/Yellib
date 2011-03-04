package scratch.regexengine.charrender
{
public class LiteralRenderer implements CharRenderer
{
    public function isCodepointSupported(codepoint:uint):Boolean
    {
        return true;
    }

    public function getRegexToken(codepoint:uint):String
    {
        return String.fromCharCode(codepoint);
    }

    public function get name():String
    {
        return "li";
    }
}
}
