package test.yellcorp.tools.StringConstants
{
import asunit.framework.TestSuite;


public class StringConstantsTest extends TestSuite
{
    public function StringConstantsTest()
    {
        super();
        addTest(new NameGeneratorTest());
        addTest(new MultiNameGeneratorTest());
    }
}
}
