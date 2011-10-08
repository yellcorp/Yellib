package test.yellcorp.lib.core.RegExpUtil
{
import org.yellcorp.lib.core.RegExpUtil;

public class NullTest extends BaseRegExpTestCase
{
    private var input:RegExp;
    private var expected:RegExp;
    
    override protected function setUp():void
    {
        input = /^abc$/;
        expected = /^abc$/;
    }
    
    override protected function tearDown():void
    {
        input = expected = null;
    }
       
    public function testEmpty():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, { });
        assertRegExpsEqual("Unequal after setting empty", result, expected);
    }
       
    public function testNull():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, null);
        assertRegExpsEqual("Unequal after setting null", result, expected);
    }
       
    public function testInvalid():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, { 
            a: true, b: false, chipolata: 7 });
        assertRegExpsEqual("Unequal after setting invalid flags", result, expected);
    }
}
}
