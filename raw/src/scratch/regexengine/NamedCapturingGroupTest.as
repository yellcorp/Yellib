package scratch.regexengine
{
import flash.display.Sprite;


public class NamedCapturingGroupTest extends Sprite
{
    public function NamedCapturingGroupTest()
    {
        testUniqueCapturingGroupNames();
        testReusedCapturingGroupNames();
    }

    private function testUniqueCapturingGroupNames():void
    {
        trace("NamedCapturingGroupTest.testUniqueCapturingGroupNames()");
        var rex:RegExp = /(?P<letters>[a-z]+)|(?P<digits>[0-9]+)/;

        test(rex, "abc", "letters", "abc");
        test(rex, "123", "digits", "123");
        test(rex, "abc123", "letters", "abc");
        test(rex, "123abc", "digits", "123");
    }

    private function testReusedCapturingGroupNames():void
    {
        trace("NamedCapturingGroupTest.testReusedCapturingGroupNames()");
        var rex:RegExp = /(?P<group>[a-z]+)|(?P<group>[0-9]+)/;

        test(rex, "abc", "group", "abc");
        test(rex, "123", "group", "123");
        test(rex, "abc123", "group", "abc");
        test(rex, "123abc", "group", "123");
    }

    private function test(r:RegExp, str:String, name:String, expect:String):void
    {
        var match:* = r.exec(str);

        if (!match)
        {
            trace("FAIL: match returned nothing");
        }
        else
        {
            if (match[name] == expect)
            {
                trace("PASS");
            }
            else
            {
                trace("FAIL: expected match." + name + " == '" + expect +
                      "', got '" + match[name] + "'");
            }
        }
    }
}
}
