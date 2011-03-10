package test.yellcorp.sequence
{
import asunit.textui.TestRunner;


public class SetTestRun extends TestRunner
{
    public function SetTestRun()
    {
        super();
        start(SetTest, null, TestRunner.SHOW_TRACE);
    }
}
}
