package test.yellcorp.geom.Vector2
{
import asunit.framework.TestSuite;
import asunit.textui.TestRunner;


public class Vector2TestRun extends TestRunner
{
    public function Vector2TestRun()
    {
        super();
        var s:TestSuite = new TestSuite();
        s.addTest(new TestObject());
        s.addTest(new TestComparison());
        s.addTest(new TestBoolean());
        s.addTest(new TestScalar());
        s.addTest(new TestMutators());
        s.addTest(new TestSetters());

        doRun(s, SHOW_TRACE);
    }
}
}
