package test.yellcorp.lib.core.RegExpUtil
{
import org.yellcorp.lib.core.RegExpUtil;

public class IdempotenceTest extends BaseRegExpTestCase
{
    private var input:RegExp;
    private var expected:RegExp;
    
    override protected function setUp():void
    {
        input = /^abc$/gi;
        expected = /^abc$/gi;
    }
    
    override protected function tearDown():void
    {
        input = expected = null;
    }
       
    public function testSetIdempotence():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, { g: true, i: true });
        assertRegExpsEqual("Unequal after setting existing g and i to true", result, expected);
    }
    
    public function testUnsetIdempotence():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, { m: false, x: false });
        assertRegExpsEqual("Unequal after setting nonexistent m and x to false", result, expected);
    }
}
}
