package test.yellcorp.geom.Vector3
{
import org.yellcorp.geom.Vector3;


public class TestMutators extends BaseVector3TestCase
{
    public function TestMutators(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testAdd():void
    {
        var u:Vector3 = new Vector3(1, 2, 3);
        var v:Vector3 = u.clone();
        var w:Vector3 = new Vector3(-3, -8, -1);
        u.add(w);
        assertVectorEqualsXYZ("add", v.x + w.x, v.y + w.y, v.z + w.z, u);
    }

    public function testSubtract():void
    {
        var u:Vector3 = new Vector3(-2, 7, 12);
        var v:Vector3 = u.clone();
        var w:Vector3 = new Vector3(1, -9, 9031);
        u.subtract(w);
        assertVectorEqualsXYZ("subtract", v.x - w.x, v.y - w.y, v.z - w.z, u);
    }

    public function testNegate():void
    {
        var u:Vector3 = new Vector3(1, -1, 2);
        var v:Vector3 = u.clone();
        u.negate();
        assertVectorEqualsXYZ("negate", -v.x, -v.y, -v.z, u);
    }

    public function testScale():void
    {
        var u:Vector3 = new Vector3(5, -7, 19);
        var v:Vector3 = u.clone();
        var s:Number = 2;
        u.scale(s);
        assertVectorEqualsXYZ("scale", v.x * s, v.y * s, v.z* s, u);
    }

    public function testCross():void
    {
        var u:Vector3 = new Vector3(-2, 7, 12);
        var v:Vector3 = u.clone();
        var w:Vector3 = new Vector3(1, -9, 9031);
        u.cross(w);
        assertVectorEqualsXYZ("cross",
            v.y * w.z - v.z * w.y,
            v.z * w.x - v.x * w.z,
            v.x * w.y - v.y * w.x,
            u);
    }

    public function testNormalizeZero():void
    {
        var v:Vector3 = new Vector3(0,0,0);
        v.normalize();
        assertFalse("normalized zero vector is not finite", v.isfinite());
        assertTrue(isNaN(v.x));
        assertTrue(isNaN(v.y));
        assertTrue(isNaN(v.z));
    }

    public function testNormalize():void
    {
        var testVectors:Array = makeCombinations([1, -1, 2, -2, Math.PI, -Math.PI]);

        function testNormalizeSingle(v:Vector3):void
        {
            v.normalize();
            assertEqualsFloat("normalize", 1, v.magnitude(), TEST_FLOAT_TOLERANCE);
        }

        for each (var v:Vector3 in testVectors)
        {
            testNormalizeSingle(v);
        }
    }
}
}
