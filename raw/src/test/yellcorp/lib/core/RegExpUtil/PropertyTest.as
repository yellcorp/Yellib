package test.yellcorp.lib.core.RegExpUtil
{
import org.yellcorp.lib.core.RegExpUtil;

public class PropertyTest extends BaseRegExpTestCase
{
    private var input:RegExp;
    private var expected:RegExp;
    
    override protected function setUp():void
    {
        input = /^abc$/;
        expected = /^abc$/gimsx;
    }
    
    override protected function tearDown():void
    {
        input = expected = null;
    }
       
    public function testInitialism():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, {
            g: true, i: true, s: true, m: true, x: true });
            
        assertRegExpsEqual("Unequal after setting all initialisms", 
                           result, expected);
    }
       
    public function testInitialismNoCase():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, {
            G: true, I: true, S: true, M: true, X: true });
            
        assertRegExpsEqual("Unequal after setting all initialisms " + 
                           "with wrong case", result, expected);
    }
       
    public function testPropertyNames():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, {
            global: true, ignoreCase: true, dotall: true, 
            multiline: true, extended: true });
            
        assertRegExpsEqual("Unequal after setting all properties", 
                           result, expected);
    }
       
    public function testPropertyNamesNoCase():void
    {
        var result:RegExp = RegExpUtil.changeFlags(input, {
            GLOBAL: true, IGNORECASE: true, DOTALL: true, 
            MULTILINE: true, EXTENDED: true });
            
        assertRegExpsEqual("Unequal after setting all properties " +
                           "with wrong letter case", result, expected);
    }
}
}
