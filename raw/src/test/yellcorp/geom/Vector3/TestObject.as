package test.yellcorp.geom.Vector3
{
import org.yellcorp.geom.Vector3;


public class TestObject extends BaseVector3TestCase
{
    public function TestObject(testMethod:String = null)
    {
        super(testMethod);
    }
    public function testCtor():void
    {
        assertVectorEqualsXY("Default arg ctor", 0, 0, new Vector2());
        assertVectorEqualsXY("Supplied arg ctor", 1, 2, new Vector2(1, 2));
    }
    public function testClone():void
    {
        var v:Vector2 = new Vector2(2, 3);
        var w:Vector2 = v.clone();
        assertNotSame("Clone creates new object", v, w);
        assertVectorEquals("Clone created same values", v, w);
    }
    public function testClear():void
    {
        var v:Vector2 = new Vector2(10, 10);
        v.clear();
        assertVectorEqualsXY("Clear sets x and y to 0", 0, 0, v);
    }
    public function testSetValues():void
    {
        var v:Vector2 = new Vector2(3,5);
        v.setValues(6, 9);
        assertVectorEqualsXY("setValues", 6, 9, v);
    }
}
}
