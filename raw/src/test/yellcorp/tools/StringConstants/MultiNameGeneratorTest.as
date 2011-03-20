package test.yellcorp.tools.StringConstants
{
import asunit.framework.Assert;
import asunit.framework.TestCase;

import org.yellcorp.tools.StringConstants;

import flash.utils.Dictionary;


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
        var allKeys:Dictionary;
        var k:*;

        if (a === b)
        {
            return;
        }
        else
        {
            allKeys = new Dictionary();
            for (k in a)  {  allKeys[a] = true;  }
            for (k in b)  {  allKeys[b] = true;  }

            for (k in allKeys)
            {
                Assert.assertEquals(a[k], b[k]);
            }
        }
    }
}

}
