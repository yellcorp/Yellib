package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.map.ChainMap;


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
        dumpMap(user.toDictionary());

        user.deleteKey('b');
        dumpMap(user.toDictionary());

        user.setValue('z', 'Z');
        dumpMap(user.toDictionary());
    }

    private function dumpMap(m:Object):void
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
