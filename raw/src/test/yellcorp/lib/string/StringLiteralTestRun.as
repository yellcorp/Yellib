package test.yellcorp.lib.string
{
import asunit.textui.TestRunner;


public class StringLiteralTestRun extends TestRunner
{
    public function StringLiteralTestRun()
    {
        super();
        start(StringLiteralTest, null, TestRunner.SHOW_TRACE);
    }
}
}
