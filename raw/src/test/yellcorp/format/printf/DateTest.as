package test.yellcorp.format.printf
{
import asunit.framework.TestCase;

import org.yellcorp.format.DateFormatUtil;
import org.yellcorp.format.printf.Printf;


public class DateTest extends TestCase
{
    public function DateTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testDate():void
    {
        // 2 March 2006, 15:16:17.891
        var date:Date = new Date(2006, 2, 2, 15, 16, 17, 891);

        var formattedTimezone:String =
            DateFormatUtil.formatTimezoneOffset(date.timezoneOffset);

        // test zero padded
        assertEquals("15", Printf.sprintf("%tH", date));
        assertEquals("03", Printf.sprintf("%tI", date));

        // test not zero padded
        assertEquals("15", Printf.sprintf("%tk", date));
        assertEquals("3", Printf.sprintf("%tl", date));

        // test zero padded
        assertEquals("16", Printf.sprintf("%tM", date));

        // test zero padded
        assertEquals("17", Printf.sprintf("%tS", date));
        assertEquals("891", Printf.sprintf("%tL", date));
        assertEquals("891000000", Printf.sprintf("%tN", date));

        // test AM
        assertEquals("pm", Printf.sprintf("%tp", date));

        assertEquals(formattedTimezone, Printf.sprintf("%tz", date));
        assertEquals("1141312578", Printf.sprintf("%ts", date));
        assertEquals("1141312577891", Printf.sprintf("%tQ", date));

        assertEquals("March", Printf.sprintf("%tB", date));
        assertEquals("Mar", Printf.sprintf("%tb", date));
        assertEquals("Thursday", Printf.sprintf("%tA", date));
        assertEquals("Thu", Printf.sprintf("%ta", date));
        assertEquals("20", Printf.sprintf("%tC", date));
        assertEquals("2006", Printf.sprintf("%tY", date));
        assertEquals("06", Printf.sprintf("%ty", date));
        assertEquals("061", Printf.sprintf("%tj", date));
        assertEquals("03", Printf.sprintf("%tm", date));
        assertEquals("02", Printf.sprintf("%td", date));
        assertEquals("2", Printf.sprintf("%te", date));

        assertEquals("15:16", Printf.sprintf("%tR", date));
        assertEquals("15:16:17", Printf.sprintf("%tT", date));
        assertEquals("03:16:17 PM", Printf.sprintf("%tr", date));
        assertEquals("03/02/06", Printf.sprintf("%tD", date));
        assertEquals("2006-03-02", Printf.sprintf("%tF", date));
        assertEquals("Thu Mar 02 15:16:17 " + formattedTimezone + " 2006",
            Printf.sprintf("%tc", date));
    }
}
}
