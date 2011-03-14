package test.yellcorp.lib.geom.Vector3
{
import asunit.textui.TestRunner;


public class Vector3TestRun extends TestRunner
{
    public function Vector3TestRun()
    {
        super();
        start(Vector3TestSuite, null, TestRunner.SHOW_TRACE);
    }
}
}
