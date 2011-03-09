package test.yellcorp.format.printf
{
import asunit.framework.TestCase;

import org.yellcorp.format.FormatStringError;
import org.yellcorp.format.printf.Printf;


public class ParserTest extends TestCase
{
    public function ParserTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testSanity():void
    {
        assertEquals("", Printf.sprintf(""));
        assertEquals(" ", Printf.sprintf(" "));
    }

    public function testTokenizer():void
    {
        assertEquals("abc", Printf.sprintf("%s", "abc"));
        assertEquals("0abc", Printf.sprintf("0%s", "abc"));
        assertEquals("abc1", Printf.sprintf("%s1", "abc"));
        assertEquals("abc2def", Printf.sprintf("%s2%s", "abc", "def"));
        assertEquals("3abc4def5", Printf.sprintf("3%s4%s5", "abc", "def"));

        // error if malformed
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%", "0");
        });
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%z", "0");
        });
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("hi %$1d hi", 0);
        });
    }

    public function testPosition():void
    {
        assertEquals("00", Printf.sprintf("%0$s", "00"));
        assertEquals("00", Printf.sprintf("%0$s", "00", "11"));

        assertEquals("0011", Printf.sprintf("%0$s%1$s", "00", "11"));
        assertEquals("1100", Printf.sprintf("%1$s%0$s", "00", "11"));
        assertEquals("11_00", Printf.sprintf("%1$s_%0$s", "00", "11"));

        assertEquals("00", Printf.sprintf("%0$s", "00"));
        assertEquals("11_22", Printf.sprintf("%1$s_%s", "00", "11", "22"));
        assertEquals("00_00_00", Printf.sprintf("%s_%<s_%<s", "00"));
        assertEquals("00_00_11", Printf.sprintf("%s_%<s_%s", "00", "11", "22"));
        assertEquals("11_11_22", Printf.sprintf("%1$s_%<s_%s", "00", "11", "22"));

        // error if walking off either end of the array
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%s_%s", "00");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%<s", "00");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%0$s %1$s", "00");
        });
    }

    public function testFlags():void
    {
        assertEquals("  A", Printf.sprintf("%3s", "A"));
        assertEquals("A  ", Printf.sprintf("%-3s", "A"));
        assertEquals("abc", Printf.sprintf("%x", 0xabc));
        assertEquals("0xabc", Printf.sprintf("%#x", 0xabc));
        assertEquals("0XABC", Printf.sprintf("%#X", 0xabc));
        assertEquals("10", Printf.sprintf("%o", 8));
        assertEquals("010", Printf.sprintf("%#o", 8));
        assertEquals("0", Printf.sprintf("%#o", 0));
        assertEquals("01", Printf.sprintf("%#o", 1));
        assertEquals("3.", Printf.sprintf("%#.0f", 3.4));
        assertEquals("4.", Printf.sprintf("%#.0f", 3.6));
        assertEquals("+5", Printf.sprintf("%+d", 5));
        assertEquals(" 5", Printf.sprintf("% d", 5));
        assertEquals("005", Printf.sprintf("%03d", 5));
        assertEquals("1,000", Printf.sprintf("%,d", 1000));
        assertEquals("(5)", Printf.sprintf("%(d", -5));

        // error if flag is specified more than once
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%++d" , 5);
        });
    }

    public function testWidth():void
    {
        assertEquals("", Printf.sprintf("%0s", ""));
        assertEquals("A", Printf.sprintf("%0s", "A"));
        assertEquals("A", Printf.sprintf("%1s", "A"));
        assertEquals(" A", Printf.sprintf("%2s", "A"));
        assertEquals("AAA", Printf.sprintf("%2s", "AAA"));
        assertEquals("AAA", Printf.sprintf("%3s", "AAA"));
        assertEquals(" AAA", Printf.sprintf("%4s", "AAA"));

        assertEquals("   A", Printf.sprintf("%4c", 0x41));
        assertEquals("  40", Printf.sprintf("%4d", 40));
        assertEquals("  40.0", Printf.sprintf("%6.1f", 40));
        assertEquals("0040.0", Printf.sprintf("%06.1f", 40));
    }

    public function testPrecision():void
    {
        assertEquals("   abc", Printf.sprintf("%6.6s", "abc"));
        assertEquals("abcdef", Printf.sprintf("%6.6s", "abcdef"));
        assertEquals("bcdefg", Printf.sprintf("%6.6s", "abcdefg"));
        assertEquals("   efg", Printf.sprintf("%6.3s", "abcdefg"));

        assertEquals("abc   ", Printf.sprintf("%-6.6s", "abc"));
        assertEquals("abcdef", Printf.sprintf("%-6.6s", "abcdef"));
        assertEquals("abcdef", Printf.sprintf("%-6.6s", "abcdefg"));
        assertEquals("abc   ", Printf.sprintf("%-6.3s", "abcdefg"));

        assertEquals("ab", Printf.sprintf("%.3s", "ab"));
        assertEquals("efg", Printf.sprintf("%.3s", "abcdefg"));
        assertEquals("abc", Printf.sprintf("%-.3s", "abcdefg"));

        assertEquals("   000", Printf.sprintf("%6.3d", 0));
        assertEquals("   005", Printf.sprintf("%6.3d", 5));
        assertEquals("  1000", Printf.sprintf("%6.3d", 1000));
        assertEquals("1000003", Printf.sprintf("%6.3d", 1000003));

        assertEquals("   00a", Printf.sprintf("%6.3x", 0xa));
        assertEquals(" 0x00a", Printf.sprintf("%#6.3x", 0xa));

        assertEquals("3.142", Printf.sprintf("%.3f", Math.PI));
        assertEquals("1.000", Printf.sprintf("%.3e", 1));
        assertEquals("1.200e+01", Printf.sprintf("%.3e", 12));
        assertEquals("3.210e-03", Printf.sprintf("%.3e", 0.00321));

        // check errors for .nn out of range
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%.21e", 0);
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%.21f", 0);
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%.22g", 0);
        });
    }

    public function testConversion():void
    {
        assertEquals("%", Printf.sprintf("%%"));
        assertEquals("  %", Printf.sprintf("%3%"));
        assertEquals("%  ", Printf.sprintf("%-3%"));

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%0$%", "Not used");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%s %<%", "Used");
        });

        assertEquals("\n", Printf.sprintf("%n"));
    }
}
}
