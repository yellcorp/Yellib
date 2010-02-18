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
