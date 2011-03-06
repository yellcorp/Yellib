package test.yellcorp.binary
{
import asunit.textui.TestRunner;


public class NumberInfoTestRun extends TestRunner
{
    public function NumberInfoTestRun()
    {
        super();
        start(NumberInfoTest, null, SHOW_TRACE);
    }
}
}
