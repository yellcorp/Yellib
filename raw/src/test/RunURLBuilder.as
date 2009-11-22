package test
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.url.URLBuilder;


public class RunURLBuilder extends ConsoleApp
{
    public function RunURLBuilder()
    {
        rfcTests();
        relTests();
    }

    public function relTests():void
    {
        var base:URLBuilder;
        var abs:URLBuilder;

        base = new URLBuilder("http://www.yellcorp.org/a/b/d.html");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/d.html?query#frag");
        trace(abs.toRelative(base));

        base = new URLBuilder("http://www.yellcorp.org/a/b/d.html?query");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/d.html#frag");
        trace(abs.toRelative(base));

        // careful - should come out as "./" (to clear query and
        // request directory default)
        base = new URLBuilder("http://www.yellcorp.org/path/?query");
        abs =  new URLBuilder("http://www.yellcorp.org/path/");
        trace(abs.toRelative(base));

        // should also be "./"
        base = new URLBuilder("http://www.yellcorp.org/a/b/d.html");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/");
        trace(abs.toRelative(base));

        base = new URLBuilder("http://www.yellcorp.org/a/b/c.html");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/d.html");
        trace(abs.toRelative(base));

        base = new URLBuilder("http://www.yellcorp.org/a/b/e/f/index.htm");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/g/h/default.htm");
        trace(abs.toRelative(base));

        base = new URLBuilder("http://www.yellcorp.org/a/b");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/d.html");
        trace(abs.toRelative(base));

        base = new URLBuilder("http://www.yellcorp.org/a/b/e/f/");
        abs =  new URLBuilder("http://www.yellcorp.org/a/b/d.html");
        trace(abs.toRelative(base));
    }

    public function rfcTests():void
    {
        var rel:URLBuilder;
        var base:URLBuilder;
        var result:URLBuilder;

        var testPairs:Array;
        var i:int;

        var baseStr:String;
        var relStr:String;
        var expectStr:String;

        baseStr = URLBuilderTest.getBaseURLString();
        base = new URLBuilder(baseStr);

        writeln(baseStr);
        writeln(base.toString());

        testPairs = URLBuilderTest.getTests();

        for (i = 0; i < testPairs.length; i += 2)
        {
            relStr = testPairs[i];
            expectStr = testPairs[i+1];

            writeln(relStr);
            rel = new URLBuilder(relStr);
            writeln(rel.toString());

            writeln(expectStr);
            result = rel.toAbsolute(base);
            writeln(result.toString());

            writeln("");
        }
    }
}
}
