package test.yellcorp.lib.core.RegExpUtil
{
import asunit.framework.TestCase;


public class BaseRegExpTestCase extends TestCase
{
    protected static function assertRegExpsEqual(failMessage:String, a:RegExp, b:RegExp):void
    {
        assertNotNull(failMessage + " first RegExp is null", a);
        assertNotNull(failMessage + " second RegExp is null", a);
        assertEquals(failMessage + " sources differ", a.source, b.source);
        assertTrue(failMessage+ " flags differ", a.global == b.global &&
        	a.ignoreCase == b.ignoreCase &&
        	a.dotall == b.dotall &&
        	a.multiline == b.multiline &&
        	a.extended == b.extended);
    }
}
}
