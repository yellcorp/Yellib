package org.yellcorp.lib.collections
{
import flash.utils.flash_proxy;


public class BaseAutoMap extends BaseMap
{
    public function BaseAutoMap(initialContents:* = null)
    {
        super(initialContents);
    }

    override flash_proxy function getProperty(name:*):*
    {
        var value:*;

        if (!store.hasOwnProperty(name))
        {
            value = createDefaultValue(name);
            if (value !== undefined)
            {
                store[name] = value;
            }
            return value;
        }
        else
        {
            return store[name];
        }
    }

    protected function createDefaultValue(name:*):*
    {
        return undefined;
    }
}
}
