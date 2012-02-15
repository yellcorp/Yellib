package test.yellcorp.lib.lex.ParseUtil
{
import asunit.framework.TestSuite;


public class ParseUtilTestSuite extends TestSuite
{
    public function ParseUtilTestSuite()
    {
        super();
        addTest(new ParseUtilNumberMatchTest());
    }
}
}
