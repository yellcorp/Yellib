package test.yellcorp.lib.core.RegExpUtil
{
import asunit.textui.TestRunner;


public class RegExpUtilTestRun extends TestRunner
{
    public function RegExpUtilTestRun()
    {
        super();
        start(RegExpUtilTestSuite, null, TestRunner.SHOW_TRACE);
    }
}
}
