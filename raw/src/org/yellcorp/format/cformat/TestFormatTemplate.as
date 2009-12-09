package org.yellcorp.format.cformat
{
import org.yellcorp.format.NumberFormatUtil;


public class TestFormatTemplate
{
    public static function run():Boolean
    {
        testForcePrecision();
        testLeadingZeros();
        testGroupNumberString();
        return true;
    }

    private static function testForcePrecision():void
    {
        testString(CFormatTemplate.forceMinPrecision("1", 2), "1.00");
        testString(CFormatTemplate.forceMinPrecision("1.1", 2), "1.10");
        testString(CFormatTemplate.forceMinPrecision("10.1", 2), "10.10");
        testString(CFormatTemplate.forceMinPrecision("10.12345", 2), "10.12345");
    }

    private static function testGroupNumberString():void
    {
        testString(NumberFormatUtil.groupNumberStr(""), "");
        testString(NumberFormatUtil.groupNumberStr("1"), "1");
        testString(NumberFormatUtil.groupNumberStr("1.0"), "1.0");
        testString(NumberFormatUtil.groupNumberStr("1.0000"), "1.0000");
        testString(NumberFormatUtil.groupNumberStr("123"), "123");
        testString(NumberFormatUtil.groupNumberStr("123.0000"), "123.0000");
        testString(NumberFormatUtil.groupNumberStr("1234"), "1,234");
        testString(NumberFormatUtil.groupNumberStr("1234.0000"), "1,234.0000");
        testString(NumberFormatUtil.groupNumberStr("12345678"), "12,345,678");
        testString(NumberFormatUtil.groupNumberStr("12345678.0000"), "12,345,678.0000");
    }

    private static function testLeadingZeros():void
    {
        testString(CFormatTemplate.addLeadingZeros("1", 2), "01");
        testString(CFormatTemplate.addLeadingZeros("1", 1), "1");
        testString(CFormatTemplate.addLeadingZeros("1", 0), "1");
        testString(CFormatTemplate.addLeadingZeros("1", -1), "1");

        testString(CFormatTemplate.addLeadingZeros("123", 5), "00123");
        testString(CFormatTemplate.addLeadingZeros("123", 3), "123");
        testString(CFormatTemplate.addLeadingZeros("123", 1), "123");
        testString(CFormatTemplate.addLeadingZeros("123", 0), "123");
        testString(CFormatTemplate.addLeadingZeros("123", -1), "123");
    }

    private static function testString(result:String, expect:String):Boolean
    {
        if (result == expect)
        {
            trace("pass");
            return true;
        }
        else
        {
            trace("FAIL got=\"" + result + "\" expect=\"" + expect + "\"");
            return false;
        }
    }
}
}
