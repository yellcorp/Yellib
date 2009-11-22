package org.yellcorp.map
{
import flash.utils.Dictionary;


public class MultiMap
{
    private var dict:Dictionary;

    public function MultiMap()
    {
        clear();
    }

    public function clear():void
    {
        dict = new Dictionary();
    }

    public function push(key:*, ... values):uint
    {
        var list:Array = getList(key);
        if (!list)
        {
            list = setList(key, [ ]);
        }
        return list.push.apply(list, values);
    }

    public function pop(key:*):*
    {
        return dict[key] ? getList(key).pop() : null;
    }

    public function unshift(key:*, ... values):uint
    {
        var list:Array = getList(key);
        if (!list)
        {
            list = setList(key, [ ]);
        }
        return list.unshift.apply(list, values);
    }

    public function shift(key:*):*
    {
        return dict[key] ? getList(key).shift() : null;
    }

    public function hasList(key:*):Boolean
    {
        return dict[key] is Array;
    }

    public function getList(key:*):Array
    {
        return dict[key] as Array;
    }

    public function getListNew(key:*):Array
    {
        var list:Array = dict[key] as Array;
        if (!list)
        {
            return setList(key, [ ]);
        }
        else
        {
            return list;
        }
    }

    public function setList(key:*, newList:Array):Array
    {
        dict[key] = newList;
        return newList;
    }

    public function deleteList(key:*):Boolean
    {
        return delete dict[key];
    }

    public function getKeys():Array
    {
        var key:*;
        var keyList:Array;

        keyList = [ ];

        for (key in dict)
        {
            keyList.push(key);
        }

        return keyList;
    }
}
}
