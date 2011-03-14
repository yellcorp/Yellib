package test.yellcorp.lib.geom.Vector2
{
import org.yellcorp.lib.geom.Vector2;


public class TestMutators extends BaseVector2TestCase
{
    public function TestMutators(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testAdd():void
    {
        var u:Vector2 = new Vector2(1, 2);
        var v:Vector2 = u.clone();
        var w:Vector2 = new Vector2(-3, -8);
        u.add(w);
        assertVectorEqualsXY("add", v.x + w.x, v.y + w.y, u);
    }

    public function testSubtract():void
    {
        var u:Vector2 = new Vector2(-2, 7);
        var v:Vector2 = u.clone();
        var w:Vector2 = new Vector2(1, -9);
        u.subtract(w);
        assertVectorEqualsXY("subtract", v.x - w.x, v.y - w.y, u);
    }

    public function testNegate():void
    {
        var u:Vector2 = new Vector2(1, -1);
        var v:Vector2 = u.clone();
        u.negate();
        assertVectorEqualsXY("negate", -v.x, -v.y, u);
    }

    public function testScale():void
    {
        var u:Vector2 = new Vector2(5, -7);
        var v:Vector2 = u.clone();
        var s:Number = 2;
        u.scale(s);
        assertVectorEqualsXY("scale", v.x * s, v.y * s, u);
    }

    public function testNormalizeZero():void
    {
        var v:Vector2 = new Vector2(0,0);
        v.normalize();
        assertFalse("normalized zero vector is not finite", v.isfinite());
        assertTrue(isNaN(v.x));
        assertTrue(isNaN(v.y));
    }

    public function testNormalize():void
    {
        var testVectors:Array = makeCombinations([1, -1, 2, -2, Math.PI, -Math.PI]);

        function testNormalizeSingle(v:Vector2):void
        {
            v.normalize();
            assertEqualsFloat("normalize", 1, v.magnitude(), TEST_FLOAT_TOLERANCE);
        }

        for each (var v:Vector2 in testVectors)
        {
            testNormalizeSingle(v);
        }
    }
}
}
