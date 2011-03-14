package test.yellcorp.lib.geom.Vector2
{
import asunit.framework.TestSuite;


public class Vector2TestSuite extends TestSuite
{
    public function Vector2TestSuite()
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
