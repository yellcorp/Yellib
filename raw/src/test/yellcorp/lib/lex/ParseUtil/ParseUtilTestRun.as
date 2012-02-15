package test.yellcorp.lib.lex.ParseUtil
{
import asunit.textui.TestRunner;


public class ParseUtilTestRun extends TestRunner
{
    public function ParseUtilTestRun()
    {
        super();
        start(ParseUtilTestSuite, null, TestRunner.SHOW_TRACE);
    }
}
}
