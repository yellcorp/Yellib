package scratch.debugconsole
{
import org.yellcorp.lib.debug.console.DebugConsole;
import org.yellcorp.lib.env.ResizableStage;


public class TestDebugConsole extends ResizableStage
{
    private var d:DebugConsole;

    public function TestDebugConsole()
    {
        super();
        d = new DebugConsole(360, 240, new TestDebugConsoleSkin());
        addChild(d.view);
    }
}
}
