package test.yellcorp.lib.geom.Vector3
{
import org.yellcorp.lib.geom.Vector3;


public class TestScalar extends BaseVector3TestCase
{
    public function TestScalar(testMethod:String = null)
    {
        super(testMethod);
    }
    public function testUnitMag():void
    {
        testMag("Unit magnitude", 0, 1, 0);
    }

    public function testZeroMag():void
    {
        testMag("Zero magnitude", 0, 0, 0);
    }

    public function testQuantityMag():void
    {
        testMag("sqrt(50) magnitude", 3, 4, 5);
    }

    public function testDot():void
    {
        var v:Vector3 = new Vector3(13, 9, -32);
        var w:Vector3 = new Vector3(21, -4, 403);

        assertEquals("Dot", v.x * w.x + v.y * w.y + v.z * w.z, v.dot(w));
    }

    private static function testMag(message:String, basis0:Number, basis1:Number, basis2:Number):void
    {
        var magSquared:Number = basis0 * basis0 + basis1 * basis1 + basis2 * basis2;
        var mag:Number = Math.sqrt(magSquared);
        var invmag:Number = Math.pow(magSquared, -.5);

        // ugh whatever. permutations are hard
        var testVectors:Array = [
            new Vector3(basis0, basis1, basis2),
            new Vector3(basis1, basis0, basis2),
            new Vector3(-basis0, basis1, basis2),
            new Vector3(-basis1, basis0, basis2),
            new Vector3(basis0, -basis1, basis2),
            new Vector3(basis1, -basis0, basis2),
            new Vector3(-basis0, -basis1, basis2),
            new Vector3(-basis1, -basis0, basis2),

            new Vector3(basis0, basis1, -basis2),
            new Vector3(basis1, basis0, -basis2),
            new Vector3(-basis0, basis1, -basis2),
            new Vector3(-basis1, basis0, -basis2),
            new Vector3(basis0, -basis1, -basis2),
            new Vector3(basis1, -basis0, -basis2),
            new Vector3(-basis0, -basis1, -basis2),
            new Vector3(-basis1, -basis0, -basis2)
        ];

        for each (var v:Vector3 in testVectors)
        {
            assertEqualsFloat(message, magSquared, v.magSquared(), TEST_FLOAT_TOLERANCE);
            assertEqualsFloat(message, mag, v.magnitude(), TEST_FLOAT_TOLERANCE);

            if (isFinite(invmag))
            {
                assertEqualsFloat(message, invmag, v.magInverse(), TEST_FLOAT_TOLERANCE);
            }
            else
            {
                assertFalse(message + " (should not be finite)", isFinite(v.magInverse()));
            }
        }
    }
}
}
