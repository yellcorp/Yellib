package test.yellcorp.format.printf
{
import asunit.framework.TestCase;

import org.yellcorp.format.printf.FormatError;
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
        assertEquals("00_00_11", Printf.sprintf("%s_%<s_%s", "00", "11", "22"));
        assertEquals("11_11_22", Printf.sprintf("%1$s_%<s_%s", "00", "11", "22"));

        assertThrows(FormatError, function ():void {
            Printf.sprintf("%s_%s", "00");
        });
    }
}
}
