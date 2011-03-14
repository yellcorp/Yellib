package scratch
{
import org.yellcorp.lib.debug.DebugUtil;
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
        trace(DebugUtil.dumpObject(this, 2));
    }
}
}
