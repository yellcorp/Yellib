package test.yellcorp.lib.geom.Vector3
{
import org.yellcorp.lib.geom.Vector3;


public class TestSetters extends BaseVector3TestCase
{
    public function TestSetters(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testAdd():void
    {
        var t:Vector3 = new Vector3(1, -1, 0);

        var u:Vector3 = new Vector3(12, -4, 10);
        var v:Vector3 = new Vector3(-9, 3, 17);

        t.setAdd(u, v);

        assertVectorEqualsXYZ("Set add", 3, -1, 27, t);
    }

    public function testSubtract():void
    {
        var t:Vector3 = new Vector3(1, -1, 0);

        var u:Vector3 = new Vector3(12, -4, 10);
        var v:Vector3 = new Vector3(-9, 3, 17);

        t.setSubtract(u, v);

        assertVectorEqualsXYZ("Set subtract", 21, -7, -7, t);
    }

    public function testCross():void
    {
        var t:Vector3 = new Vector3(1, -1, 0);

        var u:Vector3 = new Vector3(12, -4, 10);
        var v:Vector3 = new Vector3(-9, 3, 17);

        t.setCross(u, v);

        assertVectorEqualsXYZ("Set cross",
            u.y * v.z - u.z * v.y,
            u.z * v.x - u.x * v.z,
            u.x * v.y - u.y * v.x,
            t);
    }

    public function testNegative():void
    {
        var t:Vector3 = new Vector3(1, -1, 0);

        var u:Vector3 = new Vector3(12, -4, 10);

        t.setNegative(u);

        assertVectorEqualsXYZ("Set negative", -12, 4, -10, t);
    }

    public function testScale():void
    {
        var t:Vector3 = new Vector3(1, -1, 0);

        var u:Vector3 = new Vector3(12, -4, 10);

        t.setScale(u, 4.5);

        assertVectorEqualsXYZ("Set scale", 54, -18, 45, t);
    }

    public function testNormalize():void
    {
        var testVectors:Array = makeCombinations([1, -1, 2, -2, Math.PI, -Math.PI]);
        var target:Vector3 = new Vector3();

        function testNormalizeSingle(v:Vector3):void
        {
            target.setNormalize(v);
            assertEqualsFloat("normalize", 1, target.norm(), TEST_FLOAT_TOLERANCE);
        }

        for each (var v:Vector3 in testVectors)
        {
            testNormalizeSingle(v);
        }
    }
}
}
