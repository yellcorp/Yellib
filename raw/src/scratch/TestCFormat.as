package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.format.CFormat;
import org.yellcorp.format.cformat.TestFormatTemplate;


public class TestCFormat extends ConsoleApp
{
    public function TestCFormat() {
        super();
        TestFormatTemplate.run();
        //testASRendering();
        testSprintf();
    }

    private function testASRendering():void
    {
        var e:int;
        var v:Number;

        for (e = -10; e <= 10; e++)
        {
            v = 5*Math.pow(10, e);
            writeln(e, " ", v.toFixed(6), " ", v.toExponential(6));
        }
    }

    private function testSprintf():void {
        writeln(CFormat.sprintf("123456 Blah %% %s", "STRING"));
        writeln(CFormat.sprintf("%#08X", 65535));
        writeln(CFormat.sprintf("%+-5d", 23));
        writeln(CFormat.sprintf("%s %s %s", "one", "two", "three"));
        writeln(CFormat.sprintf("%1$s %2$s %0$s", "one", "two", "three"));
        writeln(CFormat.sprintf("%1$s %1$s %1$s", "one", "two", "three"));
        writeln(CFormat.sprintf("%s", Math.PI));
        writeln(CFormat.sprintf("Tricky: %*.*e", Math.PI, 12, 3));
        writeln(CFormat.sprintf("Conversion to string: %s", new Date()));
    }
}
}
