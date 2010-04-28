package test.yellcorp.geom.Vector3
{
import org.yellcorp.geom.Vector3;


public class TestSetters extends BaseVector3TestCase
{
    public function TestSetters(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testAdd():void
    {
        var t:Vector2 = new Vector2(1, -1);

        var u:Vector2 = new Vector2(12, -4);
        var v:Vector2 = new Vector2(-9, 3);

        t.setAdd(u, v);

        assertVectorEqualsXY("Set add", 3, -1, t);
    }

    public function testSubtract():void
    {
        var t:Vector2 = new Vector2(1, -1);

        var u:Vector2 = new Vector2(12, -4);
        var v:Vector2 = new Vector2(-9, 3);

        t.setSubtract(u, v);

        assertVectorEqualsXY("Set subtract", 21, -7, t);
    }

    public function testNegative():void
    {
        var t:Vector2 = new Vector2(1, -1);

        var u:Vector2 = new Vector2(12, -4);

        t.setNegative(u);

        assertVectorEqualsXY("Set negative", -12, 4, t);
    }

    public function testScale():void
    {
        var t:Vector2 = new Vector2(1, -1);

        var u:Vector2 = new Vector2(12, -4);

        t.setScale(u, 4.5);

        assertVectorEqualsXY("Set scale", 54, -18, t);
    }

    public function testNormalize():void
    {
        var testVectors:Array = makeCombinations([1, -1, 2, -2, Math.PI, -Math.PI]);
        var target:Vector2 = new Vector2();

        function testNormalizeSingle(v:Vector2):void
        {
            target.setNormalize(v);
            assertEqualsFloat("normalize", 1, target.magnitude(), TEST_FLOAT_TOLERANCE);
        }

        for each (var v:Vector2 in testVectors)
        {
            testNormalizeSingle(v);
        }
    }
}
}
