package org.yellcorp.sequence {
import flash.utils.Dictionary;


public class Set {
    private var dict:Dictionary;
    private var _length:uint;

    public function Set(initialMembers:* = null)
    {
        clear();

        if (initialMembers)
            addIterable(initialMembers);
    }

    public function clear():void
    {
        dict = new Dictionary();
        _length = 0;
    }

    public function contains(member:*):Boolean
    {
        return member != null && dict[member] != null;
    }

    public function equals(other:Set):Boolean
    {
        var item:*;

        if (_length != other._length) return false;

        for each (item in dict)
            if (!other.contains(item)) return false;

        return true;
    }

    public function add(newMember:*):void
    {
        if (newMember == null)
            throw new ArgumentError("Sets cannot contain null members");

        if (dict[newMember] == null) {
            dict[newMember] = newMember;
            _length++;
        }
    }

    public function addIterable(iterable:*):void
    {
        var item:*;
        if (iterable is Set) iterable = Set(iterable).dict;
        for each (item in iterable)
            add(item);
    }

    public function remove(member:*):Boolean
    {
        var wasPresent:Boolean = contains(member);

        if (wasPresent) {
            delete dict[member];
            _length--;
        }

        return wasPresent;
    }

    public function pop():*
    {
        var item:*;
        if (_length == 0) return null;
        for each (item in dict) break;
        delete dict[item];
        return item;
    }

    public function removeIterable(iterable:*):void
    {
        var item:*;
        if (iterable is Set) iterable = Set(iterable).dict;
        for each (item in iterable)
            remove(item);
    }

    public function isSubsetOf(test:Set):Boolean
    {
        var item:*;

        for each (item in dict)
            if (!test.contains(item))
                return false;

        return true;
    }

    public function isSupersetOf(test:Set):Boolean
    {
        return test.isSubsetOf(this);
    }

    public function clone():Set
    {
        var newSet:Set = new Set();
        newSet.addIterable(dict);
        return newSet;
    }

    public function toArray():Array
    {
        var item:*;
        var i:int = 0;
        var result:Array = new Array(_length);

        for each (item in dict)
            result[i++] = item;

        return result;
    }

    public function toString():String
    {
        return "[Set "+toArray().toString()+"]";
    }

    public function get length():uint
    {
        return _length;
    }

    public static function union(left:Set, right:Set):Set
    {
        var newSet:Set = left.clone();
        newSet.addIterable(right.dict);
        return newSet;
    }

    public static function difference(left:Set, right:Set):Set
    {
        var newSet:Set = left.clone();
        newSet.removeIterable(right.dict);
        return newSet;
    }

    public static function intersection(left:Set, right:Set):Set
    {
        var item:*;
        var newSet:Set = new Set();

        for each (item in left.dict)
            if (right.contains(item))
                newSet.add(item);

        return newSet;
    }

    public static function symmetricDifference(left:Set, right:Set):Set
    {
        var item:*;
        var newSet:Set = left.clone();

        for each (item in right.dict)
            if (!newSet.remove(item))
                newSet.add(item);

        return newSet;
    }
}
}
