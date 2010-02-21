package test.yellcorp.format
{
import asunit.textui.TestRunner;


public class TemplateTestRun extends TestRunner
{
    public function TemplateTestRun()
    {
        super();
        start(TemplateTest, null, SHOW_TRACE);
    }
}
}
