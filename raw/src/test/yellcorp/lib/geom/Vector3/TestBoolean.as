package test.yellcorp.lib.geom.Vector3
{
import org.yellcorp.lib.geom.Vector3;


public class TestBoolean extends BaseVector3TestCase
{
    public function TestBoolean(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testZero():void
    {
        function testSingleIsZero(v:Vector3):void
        {
            if (v.x === 0 && v.y === 0 && v.z === 0)
            {
                assertTrue(v.toString() + " should be zero", v.isZero());
            }
            else
            {
                assertFalse(v.toString() + " should not be zero", v.isZero());
            }
        }

        var testVectors:Array = makeCombinations(
            [ 0, 1, -1,
              Number.POSITIVE_INFINITY,
              Number.NEGATIVE_INFINITY,
              Number.NaN ]);

        for each (var v:Vector3 in testVectors)
        {
            testSingleIsZero(v);
        }
    }

    public function testFinite():void
    {
        function testSingleIsFinite(v:Vector3):void
        {
            if (isFinite(v.x) && isFinite(v.y) && isFinite(v.z))
            {
                assertTrue(v.toString() + " should be finite", v.isfinite());
            }
            else
            {
                assertFalse(v.toString() + " should not be finite", v.isfinite());
            }
        }

        var vectors:Array = makeCombinations(
            [ 0, 1, -1,
              Number.POSITIVE_INFINITY,
              Number.NEGATIVE_INFINITY,
              Number.NaN ]);

        for each (var v:Vector3 in vectors)
        {
            testSingleIsFinite(v);
        }
    }

    public function testNearZero():void
    {
        var epsilon:Number = 0.001;
        var near:Number = epsilon * .5;
        var notNear:Number = epsilon * 2;

        function testSingleIsNearZero(v:Vector3):void
        {
            if (!v.isfinite())
            {
                assertFalse(v.toString() + " should not be near", v.isNearZero(epsilon));
            }
            else if (Math.abs(v.x) < epsilon && Math.abs(v.y) < epsilon && Math.abs(v.z) < epsilon)
            {
                assertTrue(v.toString() + " should be near", v.isNearZero(epsilon));
            }
            else
            {
                assertFalse(v.toString() + " should not be near", v.isNearZero(epsilon));
            }
        }

        var vectors:Array = makeCombinations(
            [ 0, near, -near, notNear, -notNear,
              Number.POSITIVE_INFINITY,
              Number.NEGATIVE_INFINITY,
              Number.NaN ]);

        for each (var v:Vector3 in vectors)
        {
            testSingleIsNearZero(v);
        }
    }
}
}
