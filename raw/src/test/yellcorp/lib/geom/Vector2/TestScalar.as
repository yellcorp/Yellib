package test.yellcorp.lib.geom.Vector2
{
import org.yellcorp.lib.geom.Vector2;


public class TestScalar extends BaseVector2TestCase
{
    public function TestScalar(testMethod:String = null)
    {
        super(testMethod);
    }
    public function testUnitMag():void
    {
        testMag("Unit magnitude", 0, 1);
    }

    public function testZeroMag():void
    {
        testMag("Zero magnitude", 0, 0);
    }

    public function testQuantityMag():void
    {
        testMag("5 magnitude", 3, 4);
    }

    public function testDot():void
    {
        var v:Vector2 = new Vector2(13, 9);
        var w:Vector2 = new Vector2(21, 4);

        assertEquals("Dot", v.x * w.x + v.y * w.y, v.dot(w));
    }

    private static function testMag(message:String, basis0:Number, basis1:Number):void
    {
        var magSquared:Number = basis0 * basis0 + basis1 * basis1;
        var mag:Number = Math.sqrt(magSquared);
        var invmag:Number = Math.pow(magSquared, -.5);

        var testVectors:Array = [
            new Vector2(basis0, basis1),
            new Vector2(basis1, basis0),
            new Vector2(-basis0, basis1),
            new Vector2(-basis1, basis0),
            new Vector2(basis0, -basis1),
            new Vector2(basis1, -basis0),
            new Vector2(-basis0, -basis1),
            new Vector2(-basis1, -basis0)
        ];

        for each (var v:Vector2 in testVectors)
        {
            assertEqualsFloat(message, magSquared, v.normSquared(), TEST_FLOAT_TOLERANCE);
            assertEqualsFloat(message, mag, v.norm(), TEST_FLOAT_TOLERANCE);

            if (isFinite(invmag))
            {
                assertEqualsFloat(message, invmag, v.normReciprocal(), TEST_FLOAT_TOLERANCE);
            }
            else
            {
                assertFalse(message + " (should not be finite)", isFinite(v.normReciprocal()));
            }
        }
    }
}
}
