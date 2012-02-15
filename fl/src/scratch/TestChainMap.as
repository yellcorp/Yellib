package scratch
{
import org.yellcorp.lib.collections.ChainMap;
import org.yellcorp.lib.env.ConsoleApp;


public class TestChainMap extends ConsoleApp
{
    public function TestChainMap()
    {
        super();
        testChainMap();
    }

    private function testChainMap():void
    {
        var user:ChainMap;
        var defaults:ChainMap;

        user = new ChainMap({a: 'A', b: 'B', c: 'C', d: 'D'});
        defaults = new ChainMap({b: 'defaultB', c: 'defaultC', d: 'defaultD', e: 'defaultE'});

        user.parent = defaults;
        dumpMap(user);

        delete user['b'];
        dumpMap(user);

        user['z'] = 'Z';
        dumpMap(user);
    }

    private function dumpMap(m:*):void
    {
        var k:*;

        for (k in m)
        {
            writeln(k + ":" + m[k]);
        }
        writeln("----------");
    }
}
}
