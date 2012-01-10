package test.yellcorp.lib.collections
{
import asunit.textui.TestRunner;


public class LinkedSetTestRun extends TestRunner
{
    public function LinkedSetTestRun()
    {
        super();
        start(LinkedSetTest, null, SHOW_TRACE);
    }
}
}
