package test.yellcorp.format.printf
{
import asunit.framework.TestCase;

import org.yellcorp.format.printf.format.CommonFormatOptions;
import org.yellcorp.format.printf.format.FloatFormatOptions;
import org.yellcorp.format.printf.format.Format;
import org.yellcorp.format.printf.format.GeneralFormatOptions;
import org.yellcorp.format.printf.format.HexFloatFormatOptions;
import org.yellcorp.format.printf.format.IntegerFormatOptions;
import org.yellcorp.format.printf.format.SignSet;


public class FormatTest extends TestCase
{
    public function FormatTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testUtil():void
    {
        assertEquals("0", Format.padNumber(0, 0));
        assertEquals("0", Format.padNumber(0, 1));
        assertEquals("00", Format.padNumber(0, 2));

        assertEquals("1", Format.padNumber(1, 0));
        assertEquals("1", Format.padNumber(1, 1));
        assertEquals("01", Format.padNumber(1, 2));

        assertEquals("-1", Format.padNumber(-1, 0));
        assertEquals("-1", Format.padNumber(-1, 1));
        assertEquals("-01", Format.padNumber(-1, 2));
    }

    public function testGeneral():void
    {
        var g:GeneralFormatOptions;

        g = new GeneralFormatOptions();

        assertEquals("", Format.formatGeneral("", g));
        assertEquals("a", Format.formatGeneral("a", g));
        assertEquals("undefined", Format.formatGeneral(undefined, g));

        g.minWidth = 3;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals("undefined", Format.formatGeneral(undefined, g));
        assertEquals("  0", Format.formatGeneral("0", g));
        assertEquals(" ab", Format.formatGeneral("ab", g));
        assertEquals("abc", Format.formatGeneral("abc", g));
        assertEquals("abcde", Format.formatGeneral("abcde", g));

        g.leftJustify = true;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals("undefined", Format.formatGeneral(undefined, g));
        assertEquals("0  ", Format.formatGeneral("0", g));
        assertEquals("ab ", Format.formatGeneral("ab", g));
        assertEquals("abc", Format.formatGeneral("abc", g));
        assertEquals("abcde", Format.formatGeneral("abcde", g));

        g.maxWidth = 4;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals("unde", Format.formatGeneral(undefined, g));
        assertEquals("0  ", Format.formatGeneral("0", g));
        assertEquals("ab ", Format.formatGeneral("ab", g));
        assertEquals("abc", Format.formatGeneral("abc", g));
        assertEquals("abcd", Format.formatGeneral("abcde", g));

        g.leftJustify = false;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals("ined", Format.formatGeneral(undefined, g));
        assertEquals("  0", Format.formatGeneral("0", g));
        assertEquals(" ab", Format.formatGeneral("ab", g));
        assertEquals("abc", Format.formatGeneral("abc", g));
        assertEquals("bcde", Format.formatGeneral("abcde", g));

        g.maxWidth = 2;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals(" ed", Format.formatGeneral(undefined, g));
        assertEquals("  0", Format.formatGeneral("0", g));
        assertEquals(" ab", Format.formatGeneral("ab", g));
        assertEquals(" bc", Format.formatGeneral("abc", g));
        assertEquals(" de", Format.formatGeneral("abcde", g));

        g.leftJustify = true;
        assertEquals("   ", Format.formatGeneral("", g));
        assertEquals("un ", Format.formatGeneral(undefined, g));
        assertEquals("0  ", Format.formatGeneral("0", g));
        assertEquals("ab ", Format.formatGeneral("ab", g));
        assertEquals("ab ", Format.formatGeneral("abc", g));
        assertEquals("ab ", Format.formatGeneral("abcde", g));

        g = new GeneralFormatOptions();
        g.uppercase = true;

        assertEquals("", Format.formatGeneral("", g));
        assertEquals(" ", Format.formatGeneral(" ", g));
        assertEquals("A", Format.formatGeneral("a", g));
        assertEquals("UNDEFINED", Format.formatGeneral(undefined, g));
    }

    public function testChar():void
    {
        var c:CommonFormatOptions;

        var jpka:String = String.fromCharCode(0x304B);

        c = new CommonFormatOptions();

        assertEquals("?", Format.formatChar(null, c));
        assertEquals("?", Format.formatChar(undefined, c));
        assertEquals("a", Format.formatChar("a", c));
        assertEquals("t", Format.formatChar("truncated", c));
        assertEquals("b", Format.formatChar(0x62, c));

        // Japanese Hiragana KA
        assertEquals(jpka, Format.formatChar(0x304B, c));
        assertEquals(jpka, Format.formatChar(jpka, c));

        c.minWidth = 4;
        assertEquals("   t", Format.formatChar("truncated", c));
        assertEquals("   b", Format.formatChar(0x62, c));

        assertEquals("   " + jpka, Format.formatChar(0x304B, c));
        assertEquals("   " + jpka, Format.formatChar(jpka, c));

        c.leftJustify = true;
        assertEquals("t   ", Format.formatChar("truncated", c));
        assertEquals("b   ", Format.formatChar(0x62, c));

        c = new CommonFormatOptions();
        c.uppercase = true;
        assertEquals("?", Format.formatChar(null, c));
        assertEquals("?", Format.formatChar(undefined, c));
        assertEquals("A", Format.formatChar("a", c));
        assertEquals("T", Format.formatChar("truncated", c));
        assertEquals("B", Format.formatChar(0x62, c));
    }

    public function testInteger():void
    {
        var i:IntegerFormatOptions;

        i = new IntegerFormatOptions();

        assertEquals("NaN", Format.formatInteger(undefined, i));
        assertEquals("0", Format.formatInteger(null, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("0", Format.formatInteger(0, i));
        assertEquals("0", Format.formatInteger("0", i));
        assertEquals("1", Format.formatInteger(1, i));
        assertEquals("1", Format.formatInteger(1.2, i));
        assertEquals("2", Format.formatInteger(1.5, i));
        assertEquals("-1", Format.formatInteger(-1, i));
        assertEquals("-1", Format.formatInteger(-1.2, i));
        assertEquals("-1", Format.formatInteger(-1.5, i));
        assertEquals("-2", Format.formatInteger(-1.6, i));

        i.signs.positive.lead = "+";
        assertEquals("NaN", Format.formatInteger(undefined, i));
        assertEquals("+Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("+0", Format.formatInteger(0, i));
        assertEquals("+1", Format.formatInteger(1, i));
        assertEquals("-1", Format.formatInteger(-1, i));

        i = new IntegerFormatOptions();
        i.paddingChar = " ";
        i.minWidth = 5;
        assertEquals("  NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("    0", Format.formatInteger(0, i));
        assertEquals("    1", Format.formatInteger(1, i));
        assertEquals("   -1", Format.formatInteger(-1, i));
        assertEquals("1000000", Format.formatInteger(1000000, i));
        assertEquals("-100000", Format.formatInteger(-100000, i));

        i.minDigits = 3;
        i.minWidth = 6;
        assertEquals("   NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("   000", Format.formatInteger(0, i));
        assertEquals("   001", Format.formatInteger(1, i));
        assertEquals("  -001", Format.formatInteger(-1, i));
        assertEquals("  1000", Format.formatInteger(1000, i));
        assertEquals(" -1000", Format.formatInteger(-1000, i));
        assertEquals("1000000", Format.formatInteger(1000000, i));
        assertEquals("-100000", Format.formatInteger(-100000, i));

        i.minDigits = 1;
        i.minWidth = 10;
        i.paddingChar = "0";
        assertEquals("       NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("  Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals(" -Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("0000000000", Format.formatInteger(0, i));
        assertEquals("0000000001", Format.formatInteger(1, i));
        assertEquals("-000000001", Format.formatInteger(-1, i));
        assertEquals("0001000000", Format.formatInteger(1000000, i));
        assertEquals("-000100000", Format.formatInteger(-100000, i));

        i.leftJustify = true;
        assertEquals("NaN       ", Format.formatInteger(Number.NaN, i));
        assertEquals("0000000000", Format.formatInteger(null, i));
        assertEquals("Infinity  ", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity ", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("0000000000", Format.formatInteger(0, i));
        assertEquals("0000000001", Format.formatInteger(1, i));
        assertEquals("-000000001", Format.formatInteger(-1, i));
        assertEquals("0001000000", Format.formatInteger(1000000, i));
        assertEquals("-000100000", Format.formatInteger(-100000, i));

        i.leftJustify = false;
        i.paddingChar = "/";
        assertEquals("///////NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("/////////0", Format.formatInteger(null, i));
        assertEquals("//Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("/-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("/////////0", Format.formatInteger(0, i));
        assertEquals("/////////1", Format.formatInteger(1, i));
        assertEquals("////////-1", Format.formatInteger(-1, i));
        assertEquals("///1000000", Format.formatInteger(1000000, i));
        assertEquals("///-100000", Format.formatInteger(-100000, i));

        i = new IntegerFormatOptions();
        i.grouping = true;
        assertEquals("NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("0", Format.formatInteger(0, i));
        assertEquals("1", Format.formatInteger(1, i));
        assertEquals("100", Format.formatInteger(100, i));
        assertEquals("1,000", Format.formatInteger(1000, i));
        assertEquals("10,000", Format.formatInteger(10000, i));
        assertEquals("100,000", Format.formatInteger(1e5, i));
        assertEquals("1,000,000", Format.formatInteger(1e6, i));
        assertEquals("10,000,000", Format.formatInteger(1e7, i));
        assertEquals("100,000,000", Format.formatInteger(1e8, i));
        assertEquals("1,000,000,000", Format.formatInteger(1e9, i));
        assertEquals("-100", Format.formatInteger(-100, i));
        assertEquals("-1,000", Format.formatInteger(-1000, i));
        assertEquals("-10,000", Format.formatInteger(-10000, i));
        assertEquals("-100,000", Format.formatInteger(-1e5, i));
        assertEquals("-1,000,000", Format.formatInteger(-1e6, i));
        assertEquals("-10,000,000", Format.formatInteger(-1e7, i));
        assertEquals("-100,000,000", Format.formatInteger(-1e8, i));
        assertEquals("-1,000,000,000", Format.formatInteger(-1e9, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));

        i.minWidth = 8;
        assertEquals("  10,000", Format.formatInteger(10000, i));
        assertEquals(" 100,000", Format.formatInteger(1e5, i));
        assertEquals("1,000,000", Format.formatInteger(1e6, i));
        assertEquals("10,000,000", Format.formatInteger(1e7, i));
        assertEquals("100,000,000", Format.formatInteger(1e8, i));
        assertEquals(" -10,000", Format.formatInteger(-10000, i));
        assertEquals("-100,000", Format.formatInteger(-1e5, i));
        assertEquals("-1,000,000", Format.formatInteger(-1e6, i));
        assertEquals("-10,000,000", Format.formatInteger(-1e7, i));
        assertEquals("-100,000,000", Format.formatInteger(-1e8, i));

        i.minWidth = 10;
        i.paddingChar = "0";
        assertEquals("000010,000", Format.formatInteger(10000, i));
        assertEquals("000100,000", Format.formatInteger(1e5, i));
        assertEquals("01,000,000", Format.formatInteger(1e6, i));
        assertEquals("10,000,000", Format.formatInteger(1e7, i));
        assertEquals("100,000,000", Format.formatInteger(1e8, i));
        assertEquals("-00010,000", Format.formatInteger(-10000, i));
        assertEquals("-00100,000", Format.formatInteger(-1e5, i));
        assertEquals("-1,000,000", Format.formatInteger(-1e6, i));
        assertEquals("-10,000,000", Format.formatInteger(-1e7, i));
        assertEquals("-100,000,000", Format.formatInteger(-1e8, i));

        i = new IntegerFormatOptions();
        i.signs = new SignSet("+", "", "(", ")");
        assertEquals("NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("+Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("(Infinity)", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("+0", Format.formatInteger(0, i));
        assertEquals("+1", Format.formatInteger(1, i));
        assertEquals("(1)", Format.formatInteger(-1, i));

        i.minWidth = 6;
        assertEquals("   NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("+Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("(Infinity)", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("    +0", Format.formatInteger(0, i));
        assertEquals("    +1", Format.formatInteger(1, i));
        assertEquals("   (1)", Format.formatInteger(-1, i));
        assertEquals("+10000", Format.formatInteger(10000, i));
        assertEquals("(1000)", Format.formatInteger(-1000, i));
        assertEquals("+1000000", Format.formatInteger(1000000, i));
        assertEquals("(100000)", Format.formatInteger(-100000, i));

        i = new IntegerFormatOptions();
        i.base = 16;
        assertEquals("NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("0", Format.formatInteger(0, i));
        assertEquals("1", Format.formatInteger(1, i));
        assertEquals("-1", Format.formatInteger(-1, i));
        assertEquals("f", Format.formatInteger(15, i));
        assertEquals("-f", Format.formatInteger(-15, i));
        assertEquals("100", Format.formatInteger(256, i));
        assertEquals("-100", Format.formatInteger(-256, i));

        i.radixPrefix = "0x";
        assertEquals("NaN", Format.formatInteger(Number.NaN, i));
        assertEquals("Infinity", Format.formatInteger(Number.POSITIVE_INFINITY, i));
        assertEquals("-Infinity", Format.formatInteger(Number.NEGATIVE_INFINITY, i));
        assertEquals("0x0", Format.formatInteger(0, i));
        assertEquals("0x1", Format.formatInteger(1, i));
        assertEquals("-0x1", Format.formatInteger(-1, i));
        assertEquals("0xf", Format.formatInteger(15, i));
        assertEquals("-0xf", Format.formatInteger(-15, i));
        assertEquals("0x100", Format.formatInteger(256, i));
        assertEquals("-0x100", Format.formatInteger(-256, i));

        i.minWidth = 7;
        assertEquals("   -0xf", Format.formatInteger(-15, i));
        assertEquals("  0x100", Format.formatInteger(256, i));
        assertEquals(" -0x100", Format.formatInteger(-256, i));
        assertEquals("0x1a2b3c", Format.formatInteger(0x1A2B3C, i));

        i.minDigits = 4;
        assertEquals("-0x0100", Format.formatInteger(-256, i));
        assertEquals("0x1a2b3c", Format.formatInteger(0x1A2B3C, i));

        i.paddingChar = "0";
        assertEquals("-0x000f", Format.formatInteger(-15, i));
        assertEquals("0x00100", Format.formatInteger(256, i));
        assertEquals("-0x0100", Format.formatInteger(-256, i));

        i = new IntegerFormatOptions();
        i.base = 16;
        i.grouping = true;
        assertEquals("1", Format.formatInteger(1, i));
        assertEquals("1ab", Format.formatInteger(0x1ab, i));
        assertEquals("1,abc", Format.formatInteger(0x1abc, i));
        assertEquals("1a,bcd", Format.formatInteger(0x1abcd, i));

        i.radixPrefix = "0x";
        assertEquals("0x1", Format.formatInteger(1, i));
        assertEquals("0x1ab", Format.formatInteger(0x1ab, i));
        assertEquals("0x1,abc", Format.formatInteger(0x1abc, i));
        assertEquals("0x1a,bcd", Format.formatInteger(0x1abcd, i));

        i = new IntegerFormatOptions();
        i.base = 8;
        i.radixPrefix = "0";
        assertEquals("0", Format.formatInteger(0, i)); // watch out for this one
        assertEquals("07", Format.formatInteger(7, i));
        assertEquals("010", Format.formatInteger(8, i));
        assertEquals("-07", Format.formatInteger(-7, i));
        assertEquals("-010", Format.formatInteger(-8, i));
    }

    public function testFixed():void
    {
        var f:FloatFormatOptions = new FloatFormatOptions();
        assertEquals("NaN", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("0.000000", Format.formatFixed(0, f));
        assertEquals("1.000000", Format.formatFixed(1, f));
        assertEquals("-1.000000", Format.formatFixed(-1, f));
        assertEquals("3.141593", Format.formatFixed(Math.PI, f));

        f.fracWidth = 3;
        assertEquals("NaN", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("0.000", Format.formatFixed(0, f));
        assertEquals("1.000", Format.formatFixed(1, f));
        assertEquals("-1.000", Format.formatFixed(-1, f));
        assertEquals("3.142", Format.formatFixed(Math.PI, f));

        f.minWidth = 7;
        assertEquals("    NaN", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("  0.000", Format.formatFixed(0, f));
        assertEquals("  1.000", Format.formatFixed(1, f));
        assertEquals(" -1.000", Format.formatFixed(-1, f));
        assertEquals(" 20.000", Format.formatFixed(20, f));
        assertEquals("3000.000", Format.formatFixed(3000, f));
        assertEquals("  3.142", Format.formatFixed(Math.PI, f));

        f.leftJustify = true;
        assertEquals("NaN    ", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("0.000  ", Format.formatFixed(0, f));
        assertEquals("1.000  ", Format.formatFixed(1, f));
        assertEquals("-1.000 ", Format.formatFixed(-1, f));
        assertEquals("20.000 ", Format.formatFixed(20, f));
        assertEquals("3000.000", Format.formatFixed(3000, f));
        assertEquals("3.142  ", Format.formatFixed(Math.PI, f));

        f.paddingChar = "0";
        assertEquals("NaN    ", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("000.000", Format.formatFixed(0, f));
        assertEquals("001.000", Format.formatFixed(1, f));
        assertEquals("-01.000", Format.formatFixed(-1, f));
        assertEquals("020.000", Format.formatFixed(20, f));
        assertEquals("3000.000", Format.formatFixed(3000, f));
        assertEquals("003.142", Format.formatFixed(Math.PI, f));

        f = new FloatFormatOptions();
        f.fracWidth = 0;
        assertEquals("NaN", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("0", Format.formatFixed(0, f));
        assertEquals("1", Format.formatFixed(1, f));
        assertEquals("-1", Format.formatFixed(-1, f));
        assertEquals("3", Format.formatFixed(Math.PI, f));

        f.forceDecimalSeparator = true;
        assertEquals("NaN", Format.formatFixed(Number.NaN, f));
        assertEquals("Infinity", Format.formatFixed(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatFixed(Number.NEGATIVE_INFINITY, f));
        assertEquals("0.", Format.formatFixed(0, f));
        assertEquals("1.", Format.formatFixed(1, f));
        assertEquals("-1.", Format.formatFixed(-1, f));
        assertEquals("3.", Format.formatFixed(Math.PI, f));

        f = new FloatFormatOptions();
        f.grouping = true;
        f.fracWidth = 4;
        assertEquals("30,000.1234", Format.formatFixed(30000.1234, f));
    }

    public function testExponential():void
    {
        var f:FloatFormatOptions = new FloatFormatOptions();
        f.fracWidth = 3;

        assertEquals("NaN", Format.formatExponential(Number.NaN, f));
        assertEquals("Infinity", Format.formatExponential(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatExponential(Number.NEGATIVE_INFINITY, f));
        assertEquals("1.000", Format.formatExponential(1, f));
        assertEquals("1.200e+01", Format.formatExponential(12, f));
        assertEquals("1.230e+02", Format.formatExponential(123, f));
        assertEquals("3.210e-03", Format.formatExponential(0.00321, f));

        f.uppercase = true;
        assertEquals("3.210E-03", Format.formatExponential(0.00321, f));

        f.uppercase = false;
        f.exponentWidth = 3;
        assertEquals("3.210e-003", Format.formatExponential(0.00321, f));

        f.exponentDelimiter = " x 10^";
        assertEquals("3.210 x 10^-003", Format.formatExponential(0.00321, f));
    }

    public function testPrecision():void
    {
        var f:FloatFormatOptions = new FloatFormatOptions();
        f.fracWidth = 4;

        assertEquals("NaN", Format.formatPrecision(Number.NaN, f));
        assertEquals("Infinity", Format.formatPrecision(Number.POSITIVE_INFINITY, f));
        assertEquals("-Infinity", Format.formatPrecision(Number.NEGATIVE_INFINITY, f));
        assertEquals("1.000", Format.formatPrecision(1, f));
        assertEquals("12.00", Format.formatPrecision(12, f));
        assertEquals("123.0", Format.formatPrecision(123, f));
        assertEquals("1234", Format.formatPrecision(1234, f));
        assertEquals("1.235e+04", Format.formatPrecision(12345, f));
        assertEquals("1.235e+05", Format.formatPrecision(123456, f));
        assertEquals("4.321e-05", Format.formatPrecision(0.000043215, f));
        assertEquals("4.321e-04", Format.formatPrecision(0.00043215, f));

        // not sure what's going on here with the last digit, but
        // it's flash's internals, not mine
        assertEquals("0.004321", Format.formatPrecision(0.0043215, f));
        assertEquals("0.04322", Format.formatPrecision(0.043215, f));
        assertEquals("0.4321", Format.formatPrecision(0.43215, f));
        assertEquals("4.322", Format.formatPrecision(4.3215, f));
    }

    public function testHexFloat():void
    {
        var h:HexFloatFormatOptions;

        h = new HexFloatFormatOptions();

        assertEquals("NaN", Format.formatHexFloat(Number.NaN, h));
        assertEquals("Infinity", Format.formatHexFloat(Number.POSITIVE_INFINITY, h));
        assertEquals("-Infinity", Format.formatHexFloat(Number.NEGATIVE_INFINITY, h));
        assertEquals("0x0.0p0", Format.formatHexFloat(0, h));
        assertEquals("0x1.0p0", Format.formatHexFloat(1, h));
        assertEquals("0x1.8p1", Format.formatHexFloat(3, h));
        assertEquals("-0x1.4p2", Format.formatHexFloat(-5, h));
        assertEquals("0x1.0p-3", Format.formatHexFloat(.125, h));
        assertEquals("-0x1.0p0", Format.formatHexFloat(-1, h));
        assertEquals("0x1.fffffffffffffp1023", Format.formatHexFloat(Number.MAX_VALUE, h));
        assertEquals("0x0.0000000000001p-1022", Format.formatHexFloat(Number.MIN_VALUE, h));

        h.fracWidth = 3;
        assertEquals("0x0.000p0", Format.formatHexFloat(0, h));
        assertEquals("0x1.000p0", Format.formatHexFloat(1, h));
        assertEquals("0x1.800p1", Format.formatHexFloat(3, h));
        assertEquals("-0x1.400p2", Format.formatHexFloat(-5, h));
        assertEquals("0x1.000p-3", Format.formatHexFloat(.125, h));
        assertEquals("0x1.fffp1023", Format.formatHexFloat(Number.MAX_VALUE, h));
        assertEquals("0x0.000p-1022", Format.formatHexFloat(Number.MIN_VALUE, h));

        h.exponentSigns.positive.lead = "+";
        assertEquals("0x1.fffp+1023", Format.formatHexFloat(Number.MAX_VALUE, h));
    }
}
}
