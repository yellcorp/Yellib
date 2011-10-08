package test.yellcorp.lib.core.RegExpUtil
{
import asunit.framework.TestSuite;

public class RegExpUtilTestSuite extends TestSuite
{
    public function RegExpUtilTestSuite()
    {
        super();
        addTest(new BasicTest());
        addTest(new IdempotenceTest());
        addTest(new NullTest());
        addTest(new PropertyTest());
    }
}
}
