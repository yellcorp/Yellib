package scratch
{
import org.yellcorp.debug.MouseDebugger;
import org.yellcorp.env.ConsoleApp;

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
