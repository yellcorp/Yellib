package test.yellcorp.lib.geom.Vector3
{
import org.yellcorp.lib.geom.Vector3;


public class TestComparison extends BaseVector3TestCase
{
    private static const TEST_EPSILON:Number = 1e-3;

    public function TestComparison(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testEqualAbsent():void
    {
        var a:Vector3;
        var b:Vector3;

        assertTrue("both null are equal", Vector3.isEqual(a, b));
        assertFalse("both null not close", Vector3.isClose(a, b, TEST_EPSILON));
    }

    public function testEqualOneMissing():void
    {
        var a:Vector3;
        var b:Vector3;

        a = new Vector3();

        assertFalse("b null not equal", Vector3.isEqual(a, b));
        assertFalse("b null not close", Vector3.isClose(a, b, TEST_EPSILON));

        a = null;
        b = new Vector3();

        assertFalse("a null not equal", Vector3.isEqual(a, b));
        assertFalse("a null not close", Vector3.isClose(a, b, TEST_EPSILON));
    }

    public function testEqual():void
    {
        var a:Vector3 = new Vector3();
        var b:Vector3 = new Vector3();
        var x:Vector3 = new Vector3(1, 1, 1);
        var n:Vector3 = new Vector3(Number.NaN, Number.NaN, Number.NaN);

        assertTrue("same object equal", Vector3.isEqual(a, a));
        assertTrue("same object close", Vector3.isClose(a, a, TEST_EPSILON));

        assertTrue("same value equal", Vector3.isEqual(a, b));
        assertTrue("same value close", Vector3.isClose(a, b, TEST_EPSILON));

        assertFalse("different value not equal", Vector3.isEqual(a, x));

        assertFalse("vector NaN not equal", Vector3.isEqual(n, n));
    }

    public function testClose():void
    {
        var v:Vector3 = new Vector3(1, 1, 1);
        var pn:Vector3 = new Vector3(1 + TEST_EPSILON / 3, 1 + TEST_EPSILON / 3, 1 + TEST_EPSILON / 3);
        var nn:Vector3 = new Vector3(1 - TEST_EPSILON / 3, 1 - TEST_EPSILON / 3, 1 - TEST_EPSILON / 3);
        var xf:Vector3 = new Vector3(1 - TEST_EPSILON * 2, 1 + TEST_EPSILON / 3, 1);
        var yf:Vector3 = new Vector3(1 - TEST_EPSILON / 3, 1 + TEST_EPSILON * 2, 1);
        var zf:Vector3 = new Vector3(1 - TEST_EPSILON / 3, 1 + TEST_EPSILON / 3, 1 - TEST_EPSILON * 2);
        var f:Vector3 = new Vector3(1 - TEST_EPSILON * 2, 1 + TEST_EPSILON * 2, 1 + TEST_EPSILON * 2);

        assertTrue("is close " + v + ", " + pn + ", " + TEST_EPSILON, Vector3.isClose(v, pn, TEST_EPSILON));
        assertTrue("is close " + pn + ", " + v + ", " + TEST_EPSILON, Vector3.isClose(pn, v, TEST_EPSILON));
        assertTrue("is close " + v + ", " + nn + ", " + TEST_EPSILON, Vector3.isClose(v, nn, TEST_EPSILON));
        assertTrue("is close " + nn + ", " + v + ", " + TEST_EPSILON, Vector3.isClose(nn, v, TEST_EPSILON));

        assertFalse("x is not close " + v + ", " + xf + ", " + TEST_EPSILON, Vector3.isClose(v, xf, TEST_EPSILON));
        assertFalse("y is not close " + v + ", " + yf + ", " + TEST_EPSILON, Vector3.isClose(v, yf, TEST_EPSILON));
        assertFalse("z is not close " + v + ", " + zf + ", " + TEST_EPSILON, Vector3.isClose(v, zf, TEST_EPSILON));
        assertFalse("none close " + v + ", " + f + ", " + TEST_EPSILON, Vector3.isClose(v, f, TEST_EPSILON));
    }
}
}
