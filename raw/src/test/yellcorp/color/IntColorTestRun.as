package test.yellcorp.color
{
import asunit.textui.TestRunner;


public class IntColorTestRun extends TestRunner
{
    public function IntColorTestRun()
    {
        super();
        start(IntColorTest, null, SHOW_TRACE);
    }
}
}
