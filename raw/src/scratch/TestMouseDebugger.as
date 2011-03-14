package scratch
{
import org.yellcorp.lib.debug.MouseDebugger;
import org.yellcorp.lib.env.ConsoleApp;

import flash.display.Sprite;


public class TestMouseDebugger extends ConsoleApp
{
    private var canvas:Sprite;
    private var mdb:MouseDebugger;

    public function TestMouseDebugger()
    {
        super();
        writeln("TestMouseDebugger");
        addChild(canvas = new Sprite());
        mdb = new MouseDebugger(canvas);
    }
}
}
