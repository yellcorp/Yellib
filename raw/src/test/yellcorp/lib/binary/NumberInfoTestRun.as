package test.yellcorp.lib.binary
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
