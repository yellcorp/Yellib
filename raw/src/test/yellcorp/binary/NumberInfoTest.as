package test.yellcorp.binary
{
import asunit.framework.TestCase;

import org.yellcorp.binary.NumberInfo;


public class NumberInfoTest extends TestCase
{
    public function NumberInfoTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testOne():void
    {
        var one:NumberInfo = new NumberInfo(1);

        assertEquals("1 not negative", false, one.negative);
        assertEquals("1 exponent = 0", 0, one.exponent);
        assertEquals("1 not zero", false, one.zero);
        assertEquals("1 not subnormal", false, one.subnormal);
        assertEquals("1 not infinity", false, one.infinity);
        assertEquals("1 not NaN", false, one.nan);
        assertEquals("1 as string", "0x1.0p0", one.toRoundTripString());
    }

    public function testTwo():void
    {
        var two:NumberInfo = new NumberInfo(2);

        assertEquals("2 not negative", false, two.negative);
        assertEquals("2 exponent = 1", 1, two.exponent);
        assertEquals("2 not zero", false, two.zero);
        assertEquals("2 not subnormal", false, two.subnormal);
        assertEquals("2 not infinity", false, two.infinity);
        assertEquals("2 not NaN", false, two.nan);
        assertEquals("2 as string", "0x1.0p1", two.toRoundTripString());
    }

    public function testThree():void
    {
        var three:NumberInfo = new NumberInfo(3);

        assertEquals("3 not negative", false, three.negative);
        assertEquals("3 exponent = 1", 1, three.exponent);
        assertEquals("3 not zero", false, three.zero);
        assertEquals("3 not subnormal", false, three.subnormal);
        assertEquals("3 not infinity", false, three.infinity);
        assertEquals("3 not NaN", false, three.nan);
        assertEquals("3 as string", "0x1.8p1", three.toRoundTripString());
    }

    public function testHalf():void
    {
        var half:NumberInfo = new NumberInfo(.5);

        assertEquals("0.5 not negative", false, half.negative);
        assertEquals("0.5 exponent = -1", -1, half.exponent);
        assertEquals("0.5 not zero", false, half.zero);
        assertEquals("0.5 not subnormal", false, half.subnormal);
        assertEquals("0.5 not infinity", false, half.infinity);
        assertEquals("0.5 not NaN", false, half.nan);
        assertEquals("0.5 as string", "0x1.0p-1", half.toRoundTripString());
    }

    public function testNegativeOne():void
    {
        var negOne:NumberInfo = new NumberInfo(-1);

        assertEquals("-1 is negative", true, negOne.negative);
        assertEquals("-1 exponent = 0", 0, negOne.exponent);
        assertEquals("-1 not zero", false, negOne.zero);
        assertEquals("-1 not subnormal", false, negOne.subnormal);
        assertEquals("-1 not infinity", false, negOne.infinity);
        assertEquals("-1 not NaN", false, negOne.nan);
        assertEquals("-1 as string", "-0x1.0p0", negOne.toRoundTripString());
    }

    public function testMin():void
    {
        var min:NumberInfo = new NumberInfo(Number.MIN_VALUE);

        assertEquals("min not negative", false, min.negative);
        assertEquals("min not zero", false, min.zero);
        assertEquals("min is subnormal", true, min.subnormal);
        assertEquals("min not infinity", false, min.infinity);
        assertEquals("min not NaN", false, min.nan);
        assertEquals("min as string", "0x0.0000000000001p-1022", min.toRoundTripString());
    }

    public function testMax():void
    {
        var max:NumberInfo = new NumberInfo(Number.MAX_VALUE);

        assertEquals("max not negative", false, max.negative);
        assertEquals("max exponent = BIAS", NumberInfo.BIAS, max.exponent);
        assertEquals("max not zero", false, max.zero);
        assertEquals("max not subnormal", false, max.subnormal);
        assertEquals("max not infinity", false, max.infinity);
        assertEquals("max not NaN", false, max.nan);
        assertEquals("max as string", "0x1.fffffffffffffp1023", max.toRoundTripString());
    }

    public function testZero():void
    {
        var zero:NumberInfo = new NumberInfo(0);

        assertEquals("0 not negative", false, zero.negative);
        assertEquals("0 is zero", true, zero.zero);
        assertEquals("0 not subnormal", false, zero.subnormal);
        assertEquals("0 not infinity", false, zero.infinity);
        assertEquals("0 not NaN", false, zero.nan);
        assertEquals("0 as string", "0x0.0p0", zero.toRoundTripString());
    }

    public function testNaN():void
    {
        var nan:NumberInfo = new NumberInfo(Number.NaN);

        assertEquals("nan not zero", false, nan.zero);
        assertEquals("nan not subnormal", false, nan.subnormal);
        assertEquals("nan not infinity", false, nan.infinity);
        assertEquals("nan is NaN", true, nan.nan);
        assertEquals("nan as string", "NaN", nan.toRoundTripString());
    }

    public function testInfinity():void
    {
        var inf:NumberInfo = new NumberInfo(Number.POSITIVE_INFINITY);

        assertEquals("+inf not negative", false, inf.negative);
        assertEquals("+inf not zero", false, inf.zero);
        assertEquals("+inf not subnormal", false, inf.subnormal);
        assertEquals("+inf is infinity", true, inf.infinity);
        assertEquals("+inf not NaN", false, inf.nan);
        assertEquals("+inf as string", "Infinity", inf.toRoundTripString());
    }

    public function testNegativeInfinity():void
    {
        var neginf:NumberInfo = new NumberInfo(Number.NEGATIVE_INFINITY);

        assertEquals("-inf is negative", true, neginf.negative);
        assertEquals("-inf not zero", false, neginf.zero);
        assertEquals("-inf not subnormal", false, neginf.subnormal);
        assertEquals("-inf is infinity", true, neginf.infinity);
        assertEquals("-inf not NaN", false, neginf.nan);
        assertEquals("-inf as string", "-Infinity", neginf.toRoundTripString());
    }
}
}
