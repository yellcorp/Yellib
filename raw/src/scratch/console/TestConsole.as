package scratch.console
{
import org.yellcorp.lib.env.ConsoleApp;


[SWF(backgroundColor="#FFFFFF", frameRate="60", width="640", height="480")]
public class TestConsole extends ConsoleApp
{
    public function TestConsole()
    {
        super();
        var i:int;

        for (i = 0; i < 40; i++)
        {
            writeln("Line " + i);
        }
    }
}
}
