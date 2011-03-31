package scratch.proxy.testkeys
{
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.getQualifiedClassName;


public class TestProxyKeys extends Sprite
{
    public function TestProxyKeys()
    {
        var cd:CustomDictionary = new CustomDictionary();

        cd[new Point(0, 1)] = "0,1";
        cd[new Point(1, 2)] = "1,2";

        for (var k:* in cd)
        {
            trace(getQualifiedClassName(k) + ": " + k);
        }
    }
}
}
