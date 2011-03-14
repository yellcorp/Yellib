package test.yellcorp.lib.geom.Vector2
{
import asunit.textui.TestRunner;


public class Vector2TestRun extends TestRunner
{
    public function Vector2TestRun()
    {
        super();
        start(Vector2TestSuite, null, TestRunner.SHOW_TRACE);
    }
}
}
