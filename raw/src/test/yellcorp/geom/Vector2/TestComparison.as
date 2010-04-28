package test.yellcorp.geom.Vector2
{
import org.yellcorp.geom.Vector2;


public class TestComparison extends BaseVector2TestCase
{
    private static const TEST_EPSILON:Number = 1e-3;

    public function TestComparison(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testEqualAbsent():void
    {
        var a:Vector2;
        var b:Vector2;

        assertTrue("both null are equal", Vector2.isEqual(a, b));
        assertFalse("both null not close", Vector2.isClose(a, b, TEST_EPSILON));
    }

    public function testEqualOneMissing():void
    {
        var a:Vector2;
        var b:Vector2;

        a = new Vector2();

        assertFalse("b null not equal", Vector2.isEqual(a, b));
        assertFalse("b null not close", Vector2.isClose(a, b, TEST_EPSILON));

        a = null;
        b = new Vector2();

        assertFalse("a null not equal", Vector2.isEqual(a, b));
        assertFalse("a null not close", Vector2.isClose(a, b, TEST_EPSILON));
    }

    public function testEqual():void
    {
        var a:Vector2 = new Vector2();
        var b:Vector2 = new Vector2();
        var x:Vector2 = new Vector2(1, 1);
        var n:Vector2 = new Vector2(Number.NaN, Number.NaN);

        assertTrue("same object equal", Vector2.isEqual(a, a));
        assertTrue("same object close", Vector2.isEqual(a, a));

        assertTrue("same value equal", Vector2.isEqual(a, b));
        assertTrue("same value close", Vector2.isEqual(a, b));

        assertFalse("different value not equal", Vector2.isEqual(a, x));

        assertFalse("vector NaN not equal", Vector2.isEqual(n, n));
    }

    public function testClose():void
    {
        var v:Vector2 = new Vector2(1, 1);
        var n:Vector2 = new Vector2(1 - TEST_EPSILON / 3, 1 + TEST_EPSILON / 3);
        var xf:Vector2 = new Vector2(1 - TEST_EPSILON * 2, 1 + TEST_EPSILON / 3);
        var yf:Vector2 = new Vector2(1 - TEST_EPSILON / 3, 1 + TEST_EPSILON * 2);
        var f:Vector2 = new Vector2(1 - TEST_EPSILON * 2, 1 + TEST_EPSILON * 2);

        assertTrue("is close " + v + ", " + n + ", " + TEST_EPSILON, Vector2.isClose(v, n, TEST_EPSILON));
        assertTrue("is close " + n + ", " + v + ", " + TEST_EPSILON, Vector2.isClose(n, v, TEST_EPSILON));

        assertFalse("x is not close " + v + ", " + xf + ", " + TEST_EPSILON, Vector2.isClose(v, xf, TEST_EPSILON));
        assertFalse("y is not close " + v + ", " + yf + ", " + TEST_EPSILON, Vector2.isClose(v, yf, TEST_EPSILON));
        assertFalse("neither close " + v + ", " + f + ", " + TEST_EPSILON, Vector2.isClose(v, f, TEST_EPSILON));
    }
}
}
