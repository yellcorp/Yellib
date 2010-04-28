package test.yellcorp.geom.Vector2
{
import asunit.framework.TestCase;

import org.yellcorp.geom.Vector2;


public class BaseVector2TestCase extends TestCase
{
    public static const TEST_FLOAT_TOLERANCE:Number = 1e-5;

    public function BaseVector2TestCase(testMethod:String = null)
    {
        super(testMethod);
    }

    public static function assertVectorEquals(message:String, expect:Vector2, actual:Vector2):void
    {
        assertEquals(message, expect.x, actual.x);
        assertEquals(message, expect.y, actual.y);
    }

    public static function assertVectorEqualsXY(message:String, expectX:Number, expectY:Number, actual:Vector2):void
    {
        assertEquals(message, expectX, actual.x);
        assertEquals(message, expectY, actual.y);
    }

    public static function assertVectorEqualsFloat(message:String, expect:Vector2, actual:Vector2):void
    {
        assertEqualsFloat(message, expect.x, actual.x, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expect.y, actual.y, TEST_FLOAT_TOLERANCE);
    }

    public static function assertVectorEqualsFloatXY(message:String, expectX:Number, expectY:Number, actual:Vector2):void
    {
        assertEqualsFloat(message, expectX, actual.x, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expectY, actual.y, TEST_FLOAT_TOLERANCE);
    }

    public static function makeCombinations(members:Array):Array
    {
        var i:int;
        var j:int;
        var combos:Array = [ ];

        for (i = 0; i < members.length; i++)
        {
            for (j = 0; j < members.length; j++)
            {
                combos.push(new Vector2(members[i], members[j]));
            }
        }
        return combos;
    }
}
}
