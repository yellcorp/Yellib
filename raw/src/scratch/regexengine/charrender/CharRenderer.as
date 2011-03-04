package scratch.regexengine.charrender
{
public interface CharRenderer
{
    function isCodepointSupported(codepoint:uint):Boolean;
    function getRegexToken(codepoint:uint):String;
    function get name():String;
}
}
