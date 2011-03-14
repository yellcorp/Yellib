package test.yellcorp.lib.format.printf
{
import asunit.framework.TestCase;

import org.yellcorp.lib.format.FormatStringError;
import org.yellcorp.lib.format.printf.Printf;


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
        assertEquals("11", Printf.sprintf("%1$s", "11"));
        assertEquals("11", Printf.sprintf("%1$s", "11", "22"));

        assertEquals("1122", Printf.sprintf("%1$s%2$s", "11", "22"));
        assertEquals("2211", Printf.sprintf("%2$s%1$s", "11", "22"));
        assertEquals("22_11", Printf.sprintf("%2$s_%1$s", "11", "22"));

        // taken from java.util.Formatter docs
        assertEquals("b a a b", Printf.sprintf("%2$s %s %<s %s", "a", "b", "c", "d"));

        assertEquals("22_11", Printf.sprintf("%2$s_%s", "11", "22", "33"));
        assertEquals("11_11_11", Printf.sprintf("%s_%<s_%<s", "11"));
        assertEquals("11_11_22", Printf.sprintf("%s_%<s_%s", "11", "22", "33"));
        assertEquals("11_11_33_22_33", Printf.sprintf("%s_%<s_%3$s_%s_%s", "11", "22", "33"));

        // error if walking off either end of the array
        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%s_%s", "11");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%<s", "11");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%0$s %1$s", "11");
        });

        assertThrows(FormatStringError, function ():void {
            Printf.sprintf("%1$s %2$s", "11");
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
