package test.yellcorp.format.printf
{
import asunit.textui.TestRunner;

import org.yellcorp.format.printf.Printf;


public class PrintfTestRun extends TestRunner
{
    public function PrintfTestRun()
    {
        super();
//            new ParserTest().testPosition();
//            Printf.sprintf("%s_%s", "00");
            start(FormatTest, null, TestRunner.SHOW_TRACE);
            start(ParserTest, null, TestRunner.SHOW_TRACE);
        }
    }
}
