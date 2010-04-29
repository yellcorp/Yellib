package test.yellcorp.geom.Vector3
{
import asunit.framework.TestCase;

import org.yellcorp.geom.Vector3;


public class BaseVector3TestCase extends TestCase
{
    public static const TEST_FLOAT_TOLERANCE:Number = 1e-5;

    public function BaseVector3TestCase(testMethod:String = null)
    {
        super(testMethod);
    }

    public static function assertVectorEquals(message:String, expect:Vector3, actual:Vector3):void
    {
        message += " expect=" + expect + " actual=" + actual;
        assertEquals(message, expect.x, actual.x);
        assertEquals(message, expect.y, actual.y);
        assertEquals(message, expect.z, actual.z);
    }

    public static function assertVectorEqualsXYZ(message:String, expectX:Number, expectY:Number, expectZ:Number, actual:Vector3):void
    {
        message += " expect=[" + expectX + ", " + expectY + ", " + expectZ + "] actual=" + actual;
        assertEquals(message, expectX, actual.x);
        assertEquals(message, expectY, actual.y);
        assertEquals(message, expectZ, actual.z);
    }

    public static function assertVectorEqualsFloat(message:String, expect:Vector3, actual:Vector3):void
    {
        message += " expect=" + expect + " actual=" + actual;
        assertEqualsFloat(message, expect.x, actual.x, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expect.y, actual.y, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expect.z, actual.z, TEST_FLOAT_TOLERANCE);
    }

    public static function assertVectorEqualsFloatXYZ(message:String, expectX:Number, expectY:Number, expectZ:Number, actual:Vector3):void
    {
        message += " expect=[" + expectX + ", " + expectY + ", " + expectZ + "] actual=" + actual;
        assertEqualsFloat(message, expectX, actual.x, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expectY, actual.y, TEST_FLOAT_TOLERANCE);
        assertEqualsFloat(message, expectZ, actual.z, TEST_FLOAT_TOLERANCE);
    }

    public static function makeCombinations(members:Array):Array
    {
        var i:int;
        var j:int;
        var k:int;
        var combos:Array = [ ];

        for (i = 0;i < members.length;i++)
        {
            for (j = 0;j < members.length;j++)
            {
                for (k = 0;k < members.length;k++)
                {
                    combos.push(new Vector3(members[i], members[j], members[k]));
                }
            }
        }
        return combos;
    }
}
}
