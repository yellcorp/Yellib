package scratch
{
import org.yellcorp.lib.debug.DumpUtil;
import org.yellcorp.lib.env.ConsoleApp;


public class TestDumpObj extends ConsoleApp
{
    public var testVar:Object = {
        a: 1,
        b: 2,
        c: [ 3, 4, 5, 6 ],
        d: new Date()
    };

    public function TestDumpObj()
    {
        super();
        run();
    }

    private function run():void
    {
        trace(DumpUtil.dumpObject(this, 2));
    }
}
}
