package scratch.debugconsole
{
import org.yellcorp.debug.console.DebugConsole;
import org.yellcorp.env.ResizableStage;


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
