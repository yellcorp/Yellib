package test.yellcorp.lib.format.printf
{
import asunit.framework.TestSuite;


public class PrintfSuite extends TestSuite
{
    public function PrintfSuite()
    {
        super();
        addTest(new FormatTest());
        addTest(new ParserTest());
        addTest(new DateTest());
    }
}
}
