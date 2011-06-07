package org.yellcorp.lib.serial.util
{
import org.yellcorp.lib.core.MapUtil;


public class MapMap
{
    private var store:Object;

    public function MapMap()
    {
        clear();
    }

    public function clear():void
    {
        store = { };
    }

    public function getValue(a:*, b:*):*
    {
        if (store.hasOwnProperty(a))
        {
            return store[a][b];
        }
        else
        {
            return undefined;
        }
    }

    public function setValue(a:*, b:*, value:*):void
    {
        if (!store.hasOwnProperty(a))
        {
            store[a] = { };
        }
        store[a][b] = value;
    }

    public function hasValue(a:*, b:*):Boolean
    {
        return store.hasOwnProperty(a) && store[a].hasOwnProperty(b);
    }

    public function deleteValue(a:*, b:*):Boolean
    {
        var result:Boolean;
        var aMap:* = store[a];

        if (aMap)
        {
            result = delete aMap[b];
            if (MapUtil.isEmpty(aMap))
            {
                delete store[a];
            }
            return result;
        }
        else
        {
            return false;
        }
    }
}
}
