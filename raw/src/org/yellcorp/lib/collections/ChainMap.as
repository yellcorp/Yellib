package org.yellcorp.lib.collections
{
import flash.utils.Dictionary;
import flash.utils.flash_proxy;


use namespace flash_proxy;

public class ChainMap extends BaseMap
{
    public var parent:ChainMap;

    public function ChainMap(initialContents:* = null, parent:ChainMap = null)
    {
        this.parent = parent;
        super(initialContents);
    }

    public function hasOwnKey(key:*):Boolean
    {
        return store.hasOwnProperty(key);
    }

    public function deleteAll(key:*):void
    {
        for (var node:ChainMap = this; node; node = node.parent)
        {
            if (node.store.hasOwnProperty(key))
            {
                delete node.store[key];
            }
        }
    }

    public function get ownKeys():Array
    {
        return super.keys;
    }

    public function get ownValues():Array
    {
        return super.values;
    }

    public override function get keys():Array
    {
        var kv:Array = [ ];
        evaluateEntries(kv, null);
        return kv;
    }

    public override function get values():Array
    {
        var vv:Array = [ ];
        evaluateEntries(vv, null);
        return vv;
    }

    override flash_proxy function getProperty(key:*):*
    {
        for (var node:ChainMap = this; node; node = node.parent)
        {
            if (node.store.hasOwnProperty(key))
            {
                return node.store[key];
            }
        }
        return undefined;
    }

    override flash_proxy function hasProperty(key:*):Boolean
    {
        for (var node:ChainMap = this; node; node = node.parent)
        {
            if (node.store.hasOwnProperty(key))
            {
                return true;
            }
        }
        return false;
    }

    protected override function startIteration():void
    {
        iterKeys = [ ];
        iterValues = [ ];
        evaluateEntries(iterKeys, iterValues);
    }

    private function evaluateEntries(keys:Array, values:Array):void
    {
        var flat:Dictionary = new Dictionary();
        var node:ChainMap;
        var k:*;

        for (node = this; node; node = node.parent)
        {
            for (k in node.store)
            {
                if (!flat.hasOwnProperty(k))
                {
                    flat[k] = node.store[k];
                }
            }
        }

        for (k in flat)
        {
            if (keys) keys.push(k);
            if (values) values.push(flat[k]);
        }
    }
}
}
