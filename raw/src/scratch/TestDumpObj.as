package scratch
{
import org.yellcorp.debug.DebugUtil;
import org.yellcorp.env.ConsoleApp;


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
