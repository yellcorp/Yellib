package test.yellcorp.string
{
import asunit.framework.TestCase;

import org.yellcorp.string.StringLiteral;
import org.yellcorp.string.StringUtil;


public class StringLiteralTest extends TestCase
{
    public function StringLiteralTest(testMethod:String = null)
    {
        super(testMethod);
    }

    private function testEquals(func:Function, tests:Array):void
    {
        for each (var a:Array in tests)
        {
            assertEquals(a[0], a[1], func(a[2]));
        }
    }

    public function testNull():void
    {
        testEquals(StringLiteral.escape,
        [
            ["Null",  "", null],
            ["Undef", "", undefined],
            ["Empty", "", ""]
        ]);
    }

    public function testUnchanged():void
    {
        testEquals(StringLiteral.escape,
        [
            ["1 char",  "a",   "a"],
            ["2 chars", "ab",  "ab"],
            ["3 chars", "a b", "a b"]
        ]);
    }

    public function testEscapeLookup():void
    {
        testEquals(StringLiteral.getEscapeSequence,
        [
            ["backspace",  "\\b", "\b"],
            ["tab",        "\\t", "\t"],
            ["newline",    "\\n", "\n"],
            ["form feed",  "\\f", "\f"],
            ["return",     "\\r", "\r"],
            ["backslash",  "\\\\", "\\"],
            ["null",       "\\u0000", String.fromCharCode(0x0000)],
            ["shy",        "\\u00ad", String.fromCharCode(0x00ad)],
        ]);
    }

    public function testStandardSequences():void
    {
        testEquals(StringLiteral.escape,
        [
            ["1 backspace",  "\\b", "\b"],
            ["1 tab",        "\\t", "\t"],
            ["1 newline",    "\\n", "\n"],
            ["1 form feed",  "\\f", "\f"],
            ["1 return",     "\\r", "\r"],
            ["1 backslash",  "\\\\", "\\"],
            ["just escapes", "\\t\\\\\\r\\n", "\t\\\r\n"],
            ["mix",          "\\tab\\\\c\\ndef", "\tab\\c\ndef"],
        ]);
    }

    public function testUnicodeSequences():void
    {
        var ranges:Array = [
            [ 0x0000, 0x0007 ],
            [ 0x000B ],
            [ 0x000E, 0x001F ],
            [ 0x007f, 0x009f ],
            [ 0x00ad ],
            [ 0x0600, 0x0603 ],
            [ 0x06dd ],
            [ 0x070f ],
            [ 0x17b4, 0x17b5 ],
            [ 0x200b, 0x200f ],
            [ 0x202a, 0x202e ],
            [ 0x2060, 0x2063 ],
            [ 0x206a, 0x206f ],
            [ 0xfeff ],
            [ 0xfff9, 0xfffb ],
            [ 0x2028, 0x2029 ],
            [ 0xe000, 0xf8ff ],
        ];

        var start:uint;
        var end:uint;
        var i:int;

        for each (var a:Array in ranges)
        {
            if (a.length == 1)
            {
                start = end = a[0];
            }
            else
            {
                start = a[0];
                end = a[1];
            }

            for (i = start; i <= end; i++)
            {
                assertEquals(
                    "Codepoint " + i.toString(16),
                    "\\u" + StringUtil.padLeft(i.toString(16), 4, "0"),
                    StringLiteral.escape(String.fromCharCode(i)));
            }
        }
    }

    public function testQuote():void
    {
        const DOUBLE:String = '"';
        const SINGLE:String = "'";

        assertEquals("double quote null",  '""', StringLiteral.quote(null, DOUBLE));
        assertEquals("double quote undef", '""', StringLiteral.quote(undefined, DOUBLE));
        assertEquals("double quote empty", '""', StringLiteral.quote("", DOUBLE));
        assertEquals("double quote no change", '"a"', StringLiteral.quote("a", DOUBLE));
        assertEquals("double quote escape", '"\\t"', StringLiteral.quote("\t", DOUBLE));
        assertEquals("double quote mix", '"\\tab\\u00ad\\\\c\\ndef"', StringLiteral.quote("\tab\u00ad\\c\ndef", DOUBLE));

        assertEquals("single quote empty", "''", StringLiteral.quote("", SINGLE));

        assertEquals("double quote single quote", DOUBLE + SINGLE + DOUBLE, StringLiteral.quote(SINGLE, DOUBLE));
        assertEquals("single quote double quote", SINGLE + DOUBLE + SINGLE, StringLiteral.quote(DOUBLE, SINGLE));
        assertEquals("double quote double quote", '"\\""', StringLiteral.quote(DOUBLE, DOUBLE));
        assertEquals("single quote single quote", "'\\''", StringLiteral.quote(SINGLE, SINGLE));
        assertEquals("double quote mix", "\"\\tab\\u00ad\\\\c\\nd'\\\"ef\"", StringLiteral.quote("\tab\u00ad\\c\nd'\"ef", DOUBLE));
        assertEquals("single quote mix", "'\\tab\\u00ad\\\\c\\nd\\'\"ef'", StringLiteral.quote("\tab\u00ad\\c\nd'\"ef", SINGLE));
    }
}
}
