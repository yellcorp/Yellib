package test.yellcorp.format.geo
{
import asunit.framework.TestCase;

import org.yellcorp.format.geo.GeoFormat;


public class GeoFormatTest extends TestCase
{
    public function GeoFormatTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testLiterals():void
    {
        assertEquals("", GeoFormat.format("", 0));
        assertEquals(" ", GeoFormat.format(" ", 0));
        assertEquals("%", GeoFormat.format("%%", 0));
        assertEquals(" %", GeoFormat.format(" %%", 0));
        assertEquals("% ", GeoFormat.format("%% ", 0));
        assertEquals(" % ", GeoFormat.format(" %% ", 0));

        assertEquals("\u00b0", GeoFormat.format("%*", 0));
        assertEquals("\u2032", GeoFormat.format("%'", 0));
        assertEquals("\u2033", GeoFormat.format("%''", 0));
        assertEquals("\u2033'", GeoFormat.format("%'''", 0));
        assertEquals("%'", GeoFormat.format("%%'", 0));
        assertEquals("%''", GeoFormat.format("%%''", 0));
        assertEquals("%'''", GeoFormat.format("%%'''", 0));
    }

    public function testSigns():void
    {
        assertEquals("-", GeoFormat.format("%-", -1));
        assertEquals("", GeoFormat.format("%-", 0));
        assertEquals("", GeoFormat.format("%-", 1));

        assertEquals("-", GeoFormat.format("%+", -1));
        assertEquals("+", GeoFormat.format("%+", 0));
        assertEquals("+", GeoFormat.format("%+", 1));

        assertEquals("w", GeoFormat.format("%o", -1));
        assertEquals("e", GeoFormat.format("%o", 0));
        assertEquals("e", GeoFormat.format("%o", 1));

        assertEquals("W", GeoFormat.format("%O", -1));
        assertEquals("E", GeoFormat.format("%O", 0));
        assertEquals("E", GeoFormat.format("%O", 1));

        assertEquals("s", GeoFormat.format("%a", -1));
        assertEquals("n", GeoFormat.format("%a", 0));
        assertEquals("n", GeoFormat.format("%a", 1));

        assertEquals("S", GeoFormat.format("%A", -1));
        assertEquals("N", GeoFormat.format("%A", 0));
        assertEquals("N", GeoFormat.format("%A", 1));
    }

    public function testNumeric():void
    {
        var second:Number = 1 / 3600;

        assertEquals("1", GeoFormat.format("%d", -1));
        assertEquals("0", GeoFormat.format("%d", 0));
        assertEquals("1", GeoFormat.format("%d", 1));

        assertEquals("0", GeoFormat.format("%m", -1));
        assertEquals("0", GeoFormat.format("%m", 0));
        assertEquals("0", GeoFormat.format("%m", 1));

        assertEquals("30", GeoFormat.format("%m", -1.5));
        assertEquals("30", GeoFormat.format("%m", 0.5));
        assertEquals("30", GeoFormat.format("%m", 1.5));

        assertEquals("15", GeoFormat.format("%m", -1.25));
        assertEquals("15", GeoFormat.format("%m", 0.25));
        assertEquals("15", GeoFormat.format("%m", 1.25));

        assertEquals("0", GeoFormat.format("%s", -1));
        assertEquals("0", GeoFormat.format("%s", 0));
        assertEquals("0", GeoFormat.format("%s", 1));

        assertEquals("0", GeoFormat.format("%s", -1.5));
        assertEquals("0", GeoFormat.format("%s", 0.5));
        assertEquals("0", GeoFormat.format("%s", 1.5));

        assertEquals("1", GeoFormat.format("%s", second));
        assertEquals("1", GeoFormat.format("%s", -second));
        assertEquals("1", GeoFormat.format("%s", 1 + second));
        assertEquals("1", GeoFormat.format("%s", -(1 + second)));

        assertEquals("59", GeoFormat.format("%s", 1 - second));
        assertEquals("59", GeoFormat.format("%s", -(1 - second)));
    }

    public function testPrecision():void
    {
        var minute1_75:Number = 1.75 / 60;
        var second1_75:Number = 1.75 / 3600;

        assertEquals("1", GeoFormat.format("%.0m", minute1_75));
        assertEquals("1.8", GeoFormat.format("%.1m", minute1_75));
        assertEquals("1.75", GeoFormat.format("%.2m", minute1_75));
        assertEquals("1.750", GeoFormat.format("%.3m", minute1_75));

        assertEquals("2", GeoFormat.format("%.0s", second1_75));
        assertEquals("1.8", GeoFormat.format("%.1s", second1_75));
        assertEquals("1.75", GeoFormat.format("%.2s", second1_75));
        assertEquals("1.750", GeoFormat.format("%.3s", second1_75));

        assertEquals("1", GeoFormat.format("%.0m", -minute1_75));
        assertEquals("1.8", GeoFormat.format("%.1m", -minute1_75));
        assertEquals("1.75", GeoFormat.format("%.2m", -minute1_75));
        assertEquals("1.750", GeoFormat.format("%.3m", -minute1_75));

        assertEquals("2", GeoFormat.format("%.0s", -second1_75));
        assertEquals("1.8", GeoFormat.format("%.1s", -second1_75));
        assertEquals("1.75", GeoFormat.format("%.2s", -second1_75));
        assertEquals("1.750", GeoFormat.format("%.3s", -second1_75));
    }

    public function testUsage():void
    {
        var deg1_1_1_75:Number = 1 + 1/60 + 1.75/3600;

        assertEquals("1\u00b0 1\u2032 1.75000\u2033 n",
            GeoFormat.format("%d%* %m%' %.5s%'' %a", deg1_1_1_75));

        assertEquals("1\u00b0 1\u2032 1.750\u2033 S",
            GeoFormat.format("%d%* %m%' %.3s%'' %A", -deg1_1_1_75));

        assertEquals("1\u00b0 1\u2032 1.8\u2033 E",
            GeoFormat.format("%d%* %m%' %.1s%'' %O", deg1_1_1_75));

        assertEquals("1\u00b0 1\u2032 2\u2033 w",
            GeoFormat.format("%d%* %m%' %s%'' %o", -deg1_1_1_75));

        assertEquals("+1 d 1.0291666667 m",
            GeoFormat.format("%+%d d %.10m m", deg1_1_1_75));

        assertEquals("-1 d 1.02917 m",
            GeoFormat.format("%+%d d %.5m m", -deg1_1_1_75));

        assertEquals("-1 d 1.03 m",
            GeoFormat.format("%-%d d %.2m m", -deg1_1_1_75));
    }
}
}
