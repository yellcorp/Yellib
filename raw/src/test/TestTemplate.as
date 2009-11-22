package test
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.format.Template;


public class TestTemplate extends ConsoleApp
{
    public function TestTemplate()
    {
        super();
        run();
    }

    private function run():void
    {
        test(Template.format(""));
        test(Template.format("No tokens"));
        test(Template.format("Numeric token with array {0} end", ["value"]));
        test(Template.format("{0}", ["Test with token only"]));
        test(Template.format("Named token with object {test} end", { test:"YEST" }));
        test(Template.format("{test}", { test:"Named token only" }));
        test(Template.format("Path token all numeric {0.0} end", [["value"]]));
        test(Template.format("Path token names {name.first} end", {name:{first:"PASS"}}));
        test(Template.format("Invalid reference string should end here{1}", ["FAIL"]));
        test(Template.format("Invalid reference string should end here{no}", { fail:"FAIL" }));
        test(Template.format("Escaped delimiter {{open close}} and {0}", ["TOKEN"]));
        test(Template.format("Invalid unclosed {error", ["FAIL"]));
        test(Template.format("{0}{1}", ["Multiple ", "tokens"]));
        test(Template.format("Reordered {1} and {0} {2.name}", ["mixed", "tokens", { name:'types' }]));
        test(Template.format("Non-string {0}", [new Date()]));
    }

    private function test(s:String):void
    {
        writeln('"', s, '"');
    }
}
}
