package scratch.proxy.testkeys
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


public class CustomDictionary extends Proxy
{
    private var store:Dictionary;
    private var loopKeys:Array;
    private var loopValues:Array;

    public function CustomDictionary()
    {
        store = new Dictionary();
    }

    override flash_proxy function deleteProperty(key:*):Boolean
    {
        return delete store[key];
    }

    override flash_proxy function getProperty(key:*):*
    {
        return store[key];
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        return store.hasOwnProperty(key);
    }

    override flash_proxy function setProperty(key:*, value:*):void
    {
        store[key] = value;
    }

    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            loopKeys = [ ];
            loopValues = [ ];
            for (var k:* in store)
            {
                loopKeys.push(k);
                loopValues.push(store[k]);
            }
        }

        if (index < loopKeys.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    override flash_proxy function nextName(index:int):String
    {
        return loopKeys[index - 1];
    }

    override flash_proxy function nextValue(index:int):*
    {
        return loopValues[index - 1];
    }
}
}
