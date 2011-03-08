package test.yellcorp.format.printf
{
import asunit.textui.TestRunner;


public class PrintfTestRun extends TestRunner
{
    public function PrintfTestRun()
    {
        super();
        start(FormatTest, null, TestRunner.SHOW_TRACE);
    }
}
}
