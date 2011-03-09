package test.yellcorp.format
{
import asunit.framework.TestCase;

import org.yellcorp.format.NumberFormatUtil;


public class NumberFormatUtilTest extends TestCase
{
    public function NumberFormatUtilTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testPrimitive():void
    {
        assertEquals("", NumberFormatUtil.intersperse("", "", 0));
        assertEquals("", NumberFormatUtil.intersperse("", "!", 0));
        assertEquals("", NumberFormatUtil.intersperse("", "", 1));
        assertEquals("", NumberFormatUtil.intersperse("", "!", 1));
        assertEquals("a", NumberFormatUtil.intersperse("a", "", 0));
        assertEquals("abc", NumberFormatUtil.intersperse("abc", "", 0));
        assertEquals("abc", NumberFormatUtil.intersperse("abc", "!", 0));
        assertEquals("abc", NumberFormatUtil.intersperse("abc", "", 1));

        assertEquals("a!b!c", NumberFormatUtil.intersperse("abc", "!", 1));
        assertEquals("ab!c", NumberFormatUtil.intersperse("abc", "!", 2));
        assertEquals("a!bc", NumberFormatUtil.intersperse("abc", "!", -2));

        assertEquals("abc", NumberFormatUtil.intersperse("abc", "!", 4));
        assertEquals("abc", NumberFormatUtil.intersperse("abc", "!", -4));

        assertEquals("abc!d", NumberFormatUtil.intersperse("abcd", "!", 3));
        assertEquals("a!bcd", NumberFormatUtil.intersperse("abcd", "!", -3));
        assertEquals("abc!de", NumberFormatUtil.intersperse("abcde", "!", 3));
        assertEquals("ab!cde", NumberFormatUtil.intersperse("abcde", "!", -3));
        assertEquals("abc!def", NumberFormatUtil.intersperse("abcdef", "!", 3));
        assertEquals("abc!def", NumberFormatUtil.intersperse("abcdef", "!", -3));
        assertEquals("abc!def!g", NumberFormatUtil.intersperse("abcdefg", "!", 3));
        assertEquals("a!bcd!efg", NumberFormatUtil.intersperse("abcdefg", "!", -3));
    }

    public function testNoPointNoSep():void
    {
        assertEquals("0", NumberFormatUtil.groupNumber(0));
        assertEquals("123", NumberFormatUtil.groupNumber(123));
        assertEquals("-123", NumberFormatUtil.groupNumber(-123));
    }
    public function testSep():void
    {
        assertEquals("1,234", NumberFormatUtil.groupNumber(1234));
        assertEquals("-1,234", NumberFormatUtil.groupNumber(-1234));
        assertEquals("1,234,567", NumberFormatUtil.groupNumber(1234567));
        assertEquals("-1,234,567", NumberFormatUtil.groupNumber(-1234567));
    }
    public function testPoint():void
    {
        assertEquals("1.1", NumberFormatUtil.groupNumber(1.1));
        assertEquals("-1.1", NumberFormatUtil.groupNumber(-1.1));
        assertEquals("123.1", NumberFormatUtil.groupNumber(123.1));
        assertEquals("-123.1", NumberFormatUtil.groupNumber(-123.1));
        assertEquals("1,234.567", NumberFormatUtil.groupNumber(1234.567));
        assertEquals("-1,234.567", NumberFormatUtil.groupNumber(-1234.567));
        assertEquals("1,234,567.89", NumberFormatUtil.groupNumber(1234567.89));
        assertEquals("-1,234,567.89", NumberFormatUtil.groupNumber(-1234567.89));
        assertEquals("1,234.567123", NumberFormatUtil.groupNumber(1234.567123));
        assertEquals("-1,234.567123", NumberFormatUtil.groupNumber(-1234.567123));
        assertEquals("1,234,567.89123", NumberFormatUtil.groupNumber(1234567.89123));
        assertEquals("-1,234,567.89123", NumberFormatUtil.groupNumber(-1234567.89123));
    }
    public function testNonDefault():void
    {
        // european delimeters
        assertEquals("1.234.567,89123", NumberFormatUtil.groupNumber(1234567.89123, ",", "."));
        assertEquals("-1.234.567,89123", NumberFormatUtil.groupNumber(-1234567.89123, ",", "."));

        // japanese grouping
        assertEquals("-1,2345,6789.123456", NumberFormatUtil.groupNumber(-123456789.123456, ".", ",", 4));
    }
    public function testEdge():void
    {
        assertEquals("1,,234,,567..89123", NumberFormatUtil.groupNumber(1234567.89123, "..", ",,"));
        assertEquals("1234567.89123", NumberFormatUtil.groupNumber(1234567.89123, ".", ""));
        assertEquals("1,234,56789123", NumberFormatUtil.groupNumber(1234567.89123, "", ","));

        assertEquals("-123456789.123456", NumberFormatUtil.groupNumber(-123456789.123456, ".", ",", 0));
        assertEquals("-123456789.123456", NumberFormatUtil.groupNumber(-123456789.123456, ".", ",", int.MAX_VALUE));
        assertEquals("-123456789.123456", NumberFormatUtil.groupNumber(-123456789.123456, ".", ",", int.MIN_VALUE));
    }
}
}
