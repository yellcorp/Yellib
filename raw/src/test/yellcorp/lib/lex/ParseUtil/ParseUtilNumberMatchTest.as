package test.yellcorp.lib.lex.ParseUtil
{
import asunit.framework.TestCase;

import org.yellcorp.lib.lex.ParseUtil;


public class ParseUtilNumberMatchTest extends TestCase
{
    private var pattern:RegExp;

    public function ParseUtilNumberMatchTest(testMethod:String = null)
    {
        super(testMethod);
    }

    protected override function setUp():void
    {
        pattern = ParseUtil.getNumberPattern();
        trace(pattern.source);
    }

    protected override function tearDown():void
    {
        pattern = null;
    }

    public function testMatchFloat():void
    {
        testMatch("infinity");
        testMatch("Infinity");
        testMatch("INFINITY");
        testMatch("-infinity");
        testMatch("+infinity");
        testMatch("123.");
        testMatch("-123.");
        testMatch("+123.");
        testMatch("123.4");
        testMatch("12.34");
        testMatch("-12.34");
        testMatch(".0123");
        testMatch("-.0123");
        testMatch("0123");
        testMatch("-0123");

        testMatch("123.e5");
        testMatch("123.e05");
        testMatch("123.e+5");
        testMatch("123.e+05");
        testMatch("123.e-5");
        testMatch("123.e-05");
        testMatch("123.E5");
        testMatch("123.E05");
        testMatch("123.E+5");
        testMatch("123.E+05");
        testMatch("123.E-5");
        testMatch("123.E-05");
        testMatch("-123.");
        testMatch("+123.");
        testMatch("123.4e5");
        testMatch("12.34e5");
        testMatch("-12.34e-5");
        testMatch(".0123e5");
        testMatch("-.0123e5");
        testMatch("0123e5");
        testMatch("-0123e5");
    }

    public function testRejectFloat():void
    {
        testReject("");
        testReject("a");
        testReject("abcdef");
        testReject("zyxw");
        testReject(String.fromCharCode(0x2603));
        testReject("+Infinitude");
        testReject("-123.G");
        testReject("-123.3ee2");
        testReject("-123.3f02");
        testReject("-123.3e0A");

        testReject("-12.34e-5 ");
        testReject(" -12.34e-5");
        testReject("junk-12.34e-5");
        testReject("-12.34e-5junk");
    }

    public function testMatchHex():void
    {
        testMatch("0x1");
        testMatch("0xA");
        testMatch("0x11");
        testMatch("0x1A");
        testMatch("0xA1");
        testMatch("0xAA");
    }

    private function testMatch(string:String):void
    {
        assertTrue(string, pattern.test(string));
    }

    private function testReject(string:String):void
    {
        assertFalse(string, pattern.test(string));
    }
}
}
