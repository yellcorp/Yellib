package test.yellcorp.lib.binary
{
import asunit.textui.TestRunner;


public class Base64TestRun extends TestRunner
{
    public function Base64TestRun()
    {
        super();
        start(Base64Test, null, SHOW_TRACE);
    }
}
}
