package org.yellcorp.map
{
public class TreeMapUtil
{
    public static function evaluate(root:Object, ... properties):*
    {
        return evaluateA(root, properties);
    }

    public static function evaluateA(root:Object, properties:Array):*
    {
        var pi:int = 0;
        var nextProp:*;
        while (pi < properties.length)
        {
            nextProp = properties[pi++];
            if (root.hasOwnProperty(nextProp))
            {
                root = root[nextProp];
            }
            else
            {
                return null;
            }
        }
        return root;
    }

    public static function store(root:Object, value:*, ... properties):void
    {
        storeA(root, value, properties);
    }

    public static function storeA(root:Object, value:*, properties:Array):void
    {
        var pi:int = 0;
        var len:int = properties.length - 1;
        var nextProp:*;
        while (pi < len)
        {
            nextProp = properties[pi++];
            if (root.hasOwnProperty(nextProp))
            {
                root = root[nextProp];
            }
            else
            {
                root = root[nextProp] = { };
            }
        }
        root[properties[pi]] = value;
    }
}
}
