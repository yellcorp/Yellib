package scratch.regexengine.regextest
{
import scratch.regexengine.charrender.CharRenderer;


public interface RegexTest
{
    function isCodepointSupported(codepoint:uint):Boolean;
    function getRegex(codepoint:uint, renderer:CharRenderer):RegExp;
    function get name():String;
}
}
