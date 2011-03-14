package test.yellcorp.lib.geom.Vector3
{
import org.yellcorp.lib.geom.Vector3;


public class TestObject extends BaseVector3TestCase
{
    public function TestObject(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testCtor():void
    {
        assertVectorEqualsXYZ("Default arg ctor", 0, 0, 0, new Vector3());
        assertVectorEqualsXYZ("Supplied arg ctor", -0.5, 1, 2, new Vector3(-.5, 1, 2));
    }

    public function testClone():void
    {
        var v:Vector3 = new Vector3(2, 3, 5);
        var w:Vector3 = v.clone();
        assertNotSame("Clone creates new object", v, w);
        assertVectorEquals("Clone created same values", v, w);
    }

    public function testClear():void
    {
        var v:Vector3 = new Vector3(10, 10, 10);
        v.clear();
        assertVectorEqualsXYZ("Clear sets xyz to 0", 0, 0, 0, v);
    }

    public function testSetValues():void
    {
        var v:Vector3 = new Vector3(1, 2, 3);
        v.setValues(2, 4, 6);
        assertVectorEqualsXYZ("setValues", 2, 4, 6, v);
    }
}
}
