package test.yellcorp.tools.StringConstants
{
import asunit.textui.TestRunner;

import org.yellcorp.tools.StringConstants;


public class StringConstantsTestRun extends TestRunner
{
    public function StringConstantsTestRun()
    {
        start(StringConstantsTest, null, SHOW_TRACE);
        trace(StringConstants.valuesToCode([
            "complete", "httpError", "ioError", "enterFrame"
        ]).join("\n"));
    }
}
}
