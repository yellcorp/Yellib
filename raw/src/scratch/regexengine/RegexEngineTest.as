package scratch.regexengine
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.debug.DumpUtil;

import scratch.regexengine.charrender.ASCIIEscaper;
import scratch.regexengine.charrender.CharRenderer;
import scratch.regexengine.charrender.LiteralRenderer;
import scratch.regexengine.regextest.CharClass;
import scratch.regexengine.regextest.Literal;
import scratch.regexengine.regextest.RegexTest;
import scratch.regexengine.regextest.WideClass;

import flash.display.Sprite;


public class RegexEngineTest extends Sprite
{
    private var charResults:Object;
    private var rangeResults:Object;

    public function RegexEngineTest()
    {
        charResults = { };
        rangeResults = { };

        // non-printing unicode codepoints
        var ranges:Array = [
            [ 0x0061, 0x007a ], // lowercase a-z included for sanity
            [ 0x0000, 0x001f ],
            [ 0x007f, 0x009f ],
            [ 0x00ad ],
            [ 0x0600, 0x0603 ],
            [ 0x06dd ],
            [ 0x070f ],
            [ 0x17b4, 0x17b5 ],
            [ 0x200b, 0x200f ],
            [ 0x202a, 0x202e ],
            [ 0x2060, 0x2064 ],
            [ 0x206a, 0x206f ],
            [ 0xfeff ],
            [ 0xfff9, 0xfffb ],
            [ 0x2028, 0x2029 ],
            // [ 0xd800, 0xdfff ],
            [ 0xe000, 0xf8ff ],
        ];

        for each (var range:Array in ranges)
        {
            if (range.length == 1)
            {
                testRegexChar(range[0]);
            }
            else
            {
                testRegexRange(range[0], range[1]);
            }
        }

        trace("test complete");

        trace(DumpUtil.dumpObject(rangeResults));
        // printRangeResults();
        printCharResults();
        trace("dump complete");
    }

    private function printCharResults():void
    {
        var codepoints:Array = MapUtil.getKeys(charResults);
        codepoints.sort();

        for each (var cp:String in codepoints)
        {
            printCharResult(cp, charResults[cp]);
        }
    }

    private function printCharResult(codepoint:String, results:Object):void
    {
        var result:String;
        var print:Boolean = false;
        var testNames:Array;
        var testName:String;
        var columns:Array = [ codepoint ];

        for each (result in results)
        {
            if (result == "fail")
            {
                print = true;
                break;
            }
        }

        if (print)
        {
            testNames = MapUtil.getKeys(results);
            testNames.sort();
            for each (testName in testNames)
            {
                columns.push(testName + ":" + results[testName]);
            }
            trace(columns.join(","));
        }
    }

    private function testRegexRange(first:uint, last:uint):void
    {
        for (var i:uint = first; i <= last; i++)
        {
            testRegexChar(i);
        }

        testRegexRangeWith(first, last, new LiteralRenderer());
        testRegexRangeWith(first, last, new ASCIIEscaper());
    }

    private function testRegexRangeWith(first:uint, last:uint, renderer:CharRenderer):void
    {
        var re:RegExp;
        var testString:String;
        var cp:uint;

        if (renderer.isCodepointSupported(first) &&
            renderer.isCodepointSupported(last))
        {
            re = new RegExp(
                "[" +
                renderer.getRegexToken(first) +
                "-" +
                renderer.getRegexToken(last) +
                "]");

            for (cp = first; cp <= last; cp++)
            {
                testString = String.fromCharCode(cp);
                if (!re.test(testString))
                {
                    recordRangeResult(first, last, cp, renderer, "fail");
                    break;
                }
            }
        }
    }

    public function testRegexChar(codepoint:uint):void
    {
        var testers:Array = [
            new CharClass(),
            new Literal(),
            new WideClass()
        ];

        var renderers:Array = [
            new LiteralRenderer(),
            new ASCIIEscaper()
        ];

        var cRenderer:CharRenderer;
        var cTester:RegexTest;

        var testRegex:RegExp;
        var testString:String;
        var resultString:String;
        var expectedString:String = "ABC_DEF_GHI";

        for each (cRenderer in renderers)
        {
            if (cRenderer.isCodepointSupported(codepoint))
            {
                for each (cTester in testers)
                {
                    if (cTester.isCodepointSupported(codepoint))
                    {
                        testString = "ABC" +
                                String.fromCharCode(codepoint) +
                                "DEF" +
                                String.fromCharCode(codepoint) +
                                "GHI";

                        testRegex = cTester.getRegex(codepoint, cRenderer);

                        resultString = testString.replace(testRegex, "_");

                        if (resultString == expectedString)
                        {
                            recordCharResult(codepoint, cTester, cRenderer, "pass");
                        }
                        else
                        {
                            trace("Fail: " + testRegex.source + " " + resultString);
                            recordCharResult(codepoint, cTester, cRenderer, "fail");
                        }
                    }
                    else
                    {
                        recordCharResult(codepoint, cTester, cRenderer, "test:na");
                    }
                }
            }
            else
            {
                recordCharResult(codepoint, null, cRenderer, "char:na");
            }
        }
    }

    private function recordCharResult(codepoint:uint, tester:RegexTest, renderer:CharRenderer, result:String):void
    {
        var cpName:String = formatCodepoint(codepoint);
        var cpResults:Object = charResults[cpName];
        var testName:String;

        if (tester)
        {
            testName = tester.name + "/" + renderer.name;
        }
        else
        {
            testName = "/" + renderer.name;
        }

        if (!cpResults)
        {
            cpResults = charResults[cpName] = { };
        }

        cpResults[testName] = result;
    }

    private function recordRangeResult(first:uint, last:uint, cp:uint, renderer:CharRenderer, result:String):void
    {
        var rangeName:String = formatCodepoint(first) + "-" + formatCodepoint(last);
        var cpName:String = formatCodepoint(cp);

        var thisRangeResults:Object = rangeResults[rangeName];
        var rendererResults:Object;

        if (!thisRangeResults)
        {
            thisRangeResults = rangeResults[rangeName] = { };
        }

        rendererResults = thisRangeResults[renderer.name];
        if (!rendererResults)
        {
            rendererResults = thisRangeResults[renderer.name] = { };
        }
        rendererResults[cpName] = result;
    }

    private static function formatCodepoint(c:uint):String
    {
        return "U+" + StringUtil.padLeft(c.toString(16), 4, "0");
    }
}
}
