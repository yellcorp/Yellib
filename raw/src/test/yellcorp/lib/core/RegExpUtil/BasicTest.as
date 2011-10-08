package test.yellcorp.lib.core.RegExpUtil
{
import org.yellcorp.lib.core.RegExpUtil;

public class BasicTest extends BaseRegExpTestCase
{
    public function testSet():void
    {
        var input:RegExp =    /^abc$/g;
        var expected:RegExp = /^abc$/gi;
        var result:RegExp = RegExpUtil.changeFlags(input, { i: true });
        assertRegExpsEqual("Unequal after setting i", result, expected);
    }
    
    public function testUnset():void
    {
        var input:RegExp =    /^abc$/gi;
        var expected:RegExp = /^abc$/i;
        var result:RegExp = RegExpUtil.changeFlags(input, { g: false });
        assertRegExpsEqual("Unequal after unsetting g", result, expected);
    }
    
    public function testChange():void
    {
        var input:RegExp =    /^abc$/g;
        var expected:RegExp = /^abc$/i;
        var result:RegExp = RegExpUtil.changeFlags(input, { g: false, i: true });
        assertRegExpsEqual("Unequal after g=false, i=true", result, expected);
    }
}
}
