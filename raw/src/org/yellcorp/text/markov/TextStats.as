package org.yellcorp.text.markov
{
public class TextStats
{
    private var _windowSize:int;
    private var root:Object;

    public function TextStats(rootNode:Object, windowSize:int)
    {
        _windowSize = windowSize;
        root = copyTree(rootNode, windowSize - 1);
    }

    public function get windowSize():int
    {
        return _windowSize;
    }

    public function getVector(indices:Array):Object
    {
        var i:int;
        var node:Object;
        var index:String;
        if (indices.length != _windowSize - 1)
        {
            throw new ArgumentError("indices must be equal to (windowSize - 1)");
        }
        node = root;
        for (i = 0; i < _windowSize - 1; i++)
        {
            index = indices[i] || "NUL";
            node = node[index];
        }
        return node;
    }

    private static function copyTree(node:Object, level:int):Object
    {
        if (level == 0)
        {
            return copyLeafLevel(node);
        }
        else
        {
            return copyLevel(node, level);
        }
    }

    private static function copyLevel(node:Object, level:int):Object
    {
        var key:String;
        var copy:Object = { };

        for (key in node)
        {
            copy[key] = copyTree(node[key], level - 1);
        }
        return copy;
    }

    private static function copyLeafLevel(node:Object):Object
    {
        var key:String;
        var copy:Object = { };
        var sum:Number = 0;

        for (key in node)
        {
            sum += node[key];
        }
        for (key in node)
        {
            copy[key] = node[key] / sum;
        }
        return copy;
    }

    public static function choose(weightVec:Object, weight:Number):String
    {
        var key:String;
        var acc:Number = 0;

        for (key in weightVec)
        {
            acc += weightVec[key];
            if (acc > weight)
            {
                return key;
            }
        }
        return key;
    }
}
}
