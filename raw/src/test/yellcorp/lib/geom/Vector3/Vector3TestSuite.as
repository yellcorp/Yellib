package test.yellcorp.lib.geom.Vector3
{
import asunit.framework.TestSuite;


public class Vector3TestSuite extends TestSuite
{
    public function Vector3TestSuite()
    {
        super();
        addTest(new TestObject());
        addTest(new TestComparison());
        addTest(new TestBoolean());
        addTest(new TestScalar());
        addTest(new TestMutators());
        addTest(new TestSetters());
    }
}
}
