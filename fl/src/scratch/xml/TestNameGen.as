package scratch.xml
{
import org.yellcorp.lib.env.ConsoleApp;
import org.yellcorp.lib.xml.nso.NameGenerator;


public class TestNameGen extends ConsoleApp
{
    public function TestNameGen()
    {
        super();
        var ng:NameGenerator = new NameGenerator();
        for (var i:int = 0; i < 1000; i++)
        {
            writeln(ng.getNextName());
        }
    }
}
}
