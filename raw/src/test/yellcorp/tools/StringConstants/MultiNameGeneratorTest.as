package test.yellcorp.tools.StringConstants
{
import asunit.framework.Assert;
import asunit.framework.TestCase;

import org.yellcorp.tools.StringConstants;


public class MultiNameGeneratorTest extends TestCase
{
    public function MultiNameGeneratorTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testTrivial():void
    {
        assertEqualsMaps({ }, StringConstants.generateNames([ ]));

        assertEqualsMaps({ A: "a" }, StringConstants.generateNames([ "a" ]));
        assertEqualsMaps({ VALUE: "value" }, StringConstants.generateNames([ "value" ]));
    }

    public function testClash():void
    {
        assertEqualsMaps(
            {
                HTML_PARSER:  "htmlParser",
                HTML_PARSER2: "HTMLParser",
                HTML_PARSER3: "HTML_PARSER"
            },
            StringConstants.generateNames([
                "htmlParser", "HTMLParser", "HTML_PARSER"
            ]));
    }

    public static function assertEqualsMaps(a:*, b:*):void
    {
        var k:*;

        if (a === b)
        {
            return;
        }
        else
        {
            for (k in a)
            {
                assertEqualsMapKeys(a, b, k);
            }

            for (k in b)
            {
                assertEqualsMapKeys(b, a, k);
            }
        }
    }

    private static function assertEqualsMapKeys(a:*, b:*, k:*):void
    {
        if (a[k] !== b[k])
        {
            Assert.fail("Key <" + k + "> not equal. " +
                "Expected:<" + a[k] + "> but was:<" + b[k] + ">");
        }
    }
}
}
