package test.yellcorp.lib.format.template
{
import asunit.framework.TestCase;

import org.yellcorp.lib.format.template.Template;
import org.yellcorp.lib.format.template.TemplateFormatStringError;


public class TemplateTest extends TestCase
{
    public function TemplateTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testEmpty():void
    {
        assertEquals("Empty string", "", Template.format("", null));
    }

    public function testNoTokens():void
    {
        var testString:String = "No tokens";
        assertEquals(testString, Template.format(testString, null));
    }

    public function testSimpleSingle():void
    {
        assertEquals("Single numeric token",
                     "value",
                     Template.format("{0}", [ "value" ]));

        assertEquals("Single string token",
                     "value",
                     Template.format("{key}", { key: "value" }));

        assertEquals("Token at end",
                     "1234ABCD",
                     Template.format("1234{0}", [ "ABCD" ]));

        assertEquals("Token at start",
                     "ABCD1234",
                     Template.format("{0}1234", [ "ABCD" ]));
    }

    public function testSimpleMultiple():void
    {
        assertEquals("Repeated numeric key",
                     "12341234",
                     Template.format("{0}{0}", [ "1234", "ABCD" ]));

        assertEquals("Differing numeric key",
                     "ABCD1234",
                     Template.format("{1}{0}", [ "1234", "ABCD" ]));

        assertEquals("Differing numeric key",
                     "1234ABCD",
                     Template.format("{0}{1}", [ "1234", "ABCD" ]));

        assertEquals("Differing string key",
                     "1234ABCD",
                     Template.format("{aa}{bb}", { aa: "1234", bb: "ABCD" }));

        assertEquals("Tokens at start, middle and end",
                     "AA start BB CC end DD",
                     Template.format("{0} start {1} {2} end {3}",
                                     [ "AA", "BB", "CC", "DD"]));
    }

    public function testDotEval():void
    {
        assertEquals("Array/Array",
                     "ABCD",
                     Template.format("{0.0}", [["ABCD"]]));

        assertEquals("Object/Object",
                     "ABCD",
                     Template.format("{a.a}", {a: {a: "ABCD"}}));

        assertEquals("Array/Object",
                     "ABCD",
                     Template.format("{0.a}", [ {a: "ABCD"} ]));

        assertEquals("Object/Array",
                     "ABCD",
                     Template.format("{a.0}", {a: ["ABCD"]}));

        assertEquals("DotEval Sanity",
                     "ABCD1234EFGH5678",
                     Template.format("{a.a}{a.b}{b.a}{b.b}",
                                     {a: {a: "ABCD",
                                           b: "1234" },
                                      b: {a: "EFGH",
                                            b: "5678" }}));

        assertEquals("Deep",
                     "YES",
                     Template.format("{0.a.1.b}",
                                     [
                                       {
                                            a: [
                                              {a: "WRONG B"},
                                              {b: "YES"}
                                            ]
                                       },
                                       {
                                            a: [
                                              {a: "WRONG A"},
                                              {b: "WRONG A"}
                                            ]
                                       }
                                     ] ));

        assertEquals("Early undefined",
                     "PASS",
                     Template.format("{1.0.0}", [[["FAIL"]]], "PASS"));

        assertEquals("Middle undefined",
                     "PASS",
                     Template.format("{0.1.0}", [[["FAIL"]]], "PASS"));

        assertEquals("Late undefined",
                     "PASS",
                     Template.format("{0.0.1}", [[["FAIL"]]], "PASS"));

        assertEquals("Overrun",
                     "PASS",
                     Template.format("{0.0.0.1}", [[["FAIL"]]], "PASS"));
    }

    public function testStringCast():void
    {
        var now:Date = new Date();
        var expectString:String = "Date is " + now;
        assertEquals("String cast",
                     expectString,
                     Template.format("Date is {0}", [ now ]));
    }

    public function testUnresolved():void
    {
        assertEquals("Default unresolved",
                     "ABCD  1234 ",
                     Template.format("{aa} {bb} {cc} {dd}",
                                     {aa: "ABCD",
                                      cc: "1234"}));
        assertEquals("Specified unresolved",
                     "ABCD [unresolved] 1234 [unresolved]",
                     Template.format("{aa} {bb} {cc} {dd}",
                                     {aa: "ABCD",
                                      cc: "1234"},
                                     "[unresolved]"));
    }

    public function testUniqueEscape():void
    {
        assertEquals("Simple Escape",
                     "{0}",
                     Template.format("\\{0}", null));
        assertEquals("Escape followed by token",
                     "{0}ABCD",
                     Template.format("\\{0}{0}", ["ABCD"]));
        assertEquals("Token followed by escape",
                     "ABCD{0}",
                     Template.format("{0}\\{0}", ["ABCD"]));
    }

    public function testDoubledEscape():void
    {
        assertEquals("Simple Escape",
                     "{0}",
                     Template.format("{{0}", null, null, "{", "}", "{"));
        assertEquals("Escape followed by token",
                     "{0}ABCD",
                     Template.format("{{0}{0}", ["ABCD"], null, "{", "}", "{"));
        assertEquals("Token followed by escape",
                     "ABCD{0}",
                     Template.format("{0}{{0}", ["ABCD"], null, "{", "}", "{"));
    }

    public function testCustomSequences():void
    {
        assertEquals("Multi-char open",
                     "ABCD ABCD $(0) ABCD",
                     Template.format("$(0) $(0) \\$(0) $(0)", ["ABCD"], null, "$(", ")"));

        assertEquals("Multi-char both",
                     "ABCD ABCD [[0]] ABCD",
                     Template.format("[[0]] [[0]] \\[[0]] [[0]]", ["ABCD"], null, "[[", "]]"));

        assertEquals("Identical both",
                     "ABCD ABCD %0% ABCD",
                     Template.format("%0% %0% \\%0\\% %0%", ["ABCD"], null, "%", "%"));

        assertEquals("Identical all",
                     "ABCD ABCD %0% ABCD",
                     Template.format("%0% %0% %%0%% %0%", ["ABCD"], null, "%", "%", "%"));

        assertEquals("Identical multi-char both",
                     "ABCD ABCD $$0$$ ABCD",
                     Template.format("$$0$$ $$0$$ \\$$0\\$$ $$0$$", ["ABCD"], null, "$$", "$$"));

        assertEquals("Escape by doubling first char of multi-char open",
                     "ABCD ABCD $(0) ABCD",
                     Template.format("$(0) $(0) $$(0) $(0)", ["ABCD"], null, "$(", ")", "$"));

        assertEquals("Escape by implicit doubling of single char",
                     "ABCD ABCD <0> ABCD",
                     Template.format("<0> <0> <<0>> <0>", ["ABCD"], null, "<", ">", ""));

        assertEquals("Escape by implicit doubling of first char of multi-char",
                     "ABCD ABCD $(0) ABCD",
                     Template.format("$(0) $(0) $$(0)) $(0)", ["ABCD"], null, "$(", ")", ""));
    }

    public function testMisuse():void
    {
        assertEquals("Ignore closer without open",
                     "ABCD 0}",
                     Template.format("{0} 0}", [ "ABCD" ]));

        // parser jumps to the next closing character it can see - in this
        // case the property is interpreted as "0 {0"
        assertEquals("Repeated open",
                     "start [unresolved] close",
                     Template.format("start {0 {0} close", [ "ABCD" ], "[unresolved]"));
    }

    public function testError():void
    {
        assertThrows(TemplateFormatStringError,
            function ():void {
                Template.format("{0} {0", [ "ABCD" ]);
            }
        );

        assertThrows(ArgumentError,
                     function ():void
                     {
                         Template.format("", null, null, "(", ")", "$$");
                     });
    }
}
}
