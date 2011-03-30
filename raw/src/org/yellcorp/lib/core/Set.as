package org.yellcorp.lib.core
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


/**
 * This class represents a set: A collection of elements in which all
 * elements are unique and order is not defined. Null elements are not
 * permitted. Element uniqueness is the same criteria as
 * keys in a flash.utils.Dictionary, that is, strict equality (===).
 *
 * This class extends flash.utils.Proxy to support
 * <code>for each...in</code> iteration, but as there are no keys,
 * <code>for...in</code> iteration is not supported, and neither is []
 * access.
 */
public class Set extends Proxy
{
    private var dict:Dictionary;
    private var _length:uint;

    private var _currentLoop:Array;

    /**
     * Creates a new Set.
     *
     * @param initialElements The initial elements of the set. This can be
     *                        any object that supports
     *                        <code>for each...in</code> iteration,
     *                        including other Set instances. If this value
     *                        is <code>null</code>, an empty Set is created.
     */
    public function Set(initialElements:* = null)
    {
        clear();

        if (initialElements)
        {
            addIterable(initialElements);
        }
    }

    /**
     * Clears the set.
     */
    public function clear():void
    {
        dict = new Dictionary();
        _length = 0;
    }

    /**
     * Tests whether the Set contains an element.
     *
     * @param query  The object to test for membership. This is checked
     *               using strict equality (===).
     *
     * @return <code>true</code> if this Set contains an element equal to
     *         <code>query</code>.
     */
    public function contains(query:*):Boolean
    {
        return query != null && dict[query] != null;
    }

    /**
     * Adds an element to the Set.  This has no effect if the element
     * already exists in the Set.
     *
     * @param newElement  The element to add.
     */
    public function add(newElement:*):void
    {
        if (newElement == null)
        {
            throw new ArgumentError("Sets cannot contain null elements");
        }

        if (dict[newElement] == null)
        {
            dict[newElement] = newElement;
            _length++;
        }
    }

    /**
     * Adds a number of elements from another collection to the Set.  If
     * an element from the other collection already exists in this Set,
     * that element is ignored.
     *
     * @param iterable  The source of elements to add. This can be any
     *                  object that supports <code>for each...in</code>
     *                  iteration, for example Objects, Dictionaries, Arrays
     *                  and other Sets. If an Object or Dictionary is passed
     *                  in, only its values are added as elements.
     */
    public function addIterable(iterable:*):void
    {
        var item:*;
        if (this !== iterable)
        {
            for each (item in iterable)
            {
                add(item);
            }
        }
    }

    /**
     * Removes an element from the Set, if it exists.
     *
     * @param element  The element to remove.
     * @return <code>true</code> if the element existed and has been
     *         removed, <code>false</code> otherwise.
     */
    public function remove(element:*):Boolean
    {
        var wasPresent:Boolean = contains(element);

        if (wasPresent)
        {
            delete dict[element];
            _length--;
        }
        return wasPresent;
    }

    /**
     * Removes a number of elements from the Set.
     *
     * @param iterable  The source of elements to remove. This can be any
     *                  object that supports <code>for each...in</code>
     *                  iteration. If an element in <code>iterable</code>
     *                  does not exist in this Set, it is skipped.
     */
    public function removeIterable(iterable:*):void
    {
        var item:*;
        if (this === iterable)
        {
            clear();
        }
        else
        {
            for each (item in iterable)
            {
                remove(item);
            }
        }
    }

    /**
     * Removes some element from the Set and returns it.  Exactly which
     * element is returned is not defined, as the Set is unordered. This can
     * be used to destructively iterate over a Set's elements.
     *
     * @return An element from the Set, or <code>null</code> if the Set is
     *         empty.
     */
    public function pop():*
    {
        var item:*;
        if (_length == 0)
        {
            return null;
        }
        for each (item in dict)
        {
            break;
        }
        delete dict[item];
        return item;
    }

    /**
     * Tests whether another Set is equal to this one.  Two sets are equal
     * if every element in one set is also present in the other.
     *
     * @param other  The Set to compare with.
     * @return <code>true</code> if both Sets are equal. <code>false</code>
     *         otherwise.
     */
    public function equals(other:Set):Boolean
    {
        return other && _length === other._length && testSubset(other);
    }

    /**
     * Tests if this Set is a subset of, or equal to, another.  A set X is
     * a subset of Y if all the elements in X are also in Y.
     *
     * @param test  The other set to test against.
     * @return <code>true</code> if this Set is a subset of, or equal to
     *         <code>test</code>
     */
    public function isSubsetOf(other:Set):Boolean
    {
        return other && _length <= other._length && testSubset(other);
    }

    private function testSubset(other:Set):Boolean
    {
        var item:*;

        if (this === other)
        {
            return true;
        }
        else
        {
            for each (item in dict)
            {
                if (!other.contains(item))
                {
                    return false;
                }
            }
            return true;
        }
    }

    /**
     * Tests if this Set is a superset of, or equal to, another.  A set X is
     * a superset of Y if all the elements in Y are also in X.
     *
     * @param test  The other set to test against.
     * @return <code>true</code> if this Set is a superset of, or equal to
     *         <code>test</code>
     */
    public function isSupersetOf(other:Set):Boolean
    {
        return other.isSubsetOf(this);
    }

    /**
     * Creates a shallow copy of this set.
     *
     * @return A new set with identical elements to this one.
     */
    public function clone():Set
    {
        return new Set(this);
    }

    /**
     * Returns a new Array containing each element in this Set. The order
     * in which the elements appear in the Array is not defined.
     *
     * @return A new Array containing this Set's elements.
     */
    public function toArray():Array
    {
        var item:*;
        var i:int = 0;
        var result:Array = new Array(_length);

        for each (item in dict)
        {
            result[i++] = item;
        }

        return result;
    }

    /**
     * Returns a String representation of the Set.  This is the String
     * <code>"[Set "</code>, followed by a comma-separated list of each
     * element's string representation, followed by <code>"]"</code>
     *
     * @return The String representation of this Set.
     */
    public function toString():String
    {
        return "[Set " + toArray().toString() + "]";
    }

    /**
     * The number of elements in the Set.
     */
    public function get length():uint
    {
        return _length;
    }

    // proxy implementation
    /**
     * @private
     */
    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index < _length)
        {
            if (index == 0)
            {
                _currentLoop = toArray();
            }
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    /**
     * @private
     */
    override flash_proxy function nextValue(index:int):*
    {
        return _currentLoop[index - 1];
    }

    /**
     * Returns the union of two Sets. That is, a new Set containing each
     * element that is a member of <code>a</code>, <code>b</code>, or both.
     */
    public static function union(a:Set, b:Set):Set
    {
        var newSet:Set = a.clone();

        if (a !== b)
        {
            newSet.addIterable(b.dict);
        }

        return newSet;
    }

    /**
     * Returns the difference of two Sets. That is, a new Set containing
     * each element in <code>a</code> that is not also in <code>b</code>.
     */
    public static function difference(a:Set, b:Set):Set
    {
        var differenceResult:Set;

        if (a === b || a.length == 0)
        {
            return new Set();
        }
        else if (b.length == 0)
        {
            return a.clone();
        }
        else
        {
            differenceResult = new Set();
            for each (var e:* in a.dict)
            {
                if (!b.contains(e))
                {
                    differenceResult.add(e);
                }
            }
            return differenceResult;
        }
    }

    /**
     * Returns the intersection of two Sets. That is, a new Set containing
     * each element that is a member of both <code>a</code> and
     * <code>b</code>.
     */
    public static function intersection(a:Set, b:Set):Set
    {
        var intersectionResult:Set;
        var swap:Set;

        if (a === b)
        {
            return a.clone();
        }

        if (a.length > b.length)
        {
            swap = a;
            a = b;
            b = swap;
        }

        intersectionResult = new Set();
        for each (var e:* in a.dict)
        {
            if (b.contains(e))
            {
                intersectionResult.add(e);
            }
        }
        return intersectionResult;
    }

    /**
     * Returns the symmetric difference of two Sets. That is, a new Set
     * containing each element that is is a member of <code>a</code> or
     * <code>b</code>, but without elements that are members of both.
     */
    public static function symmetricDifference(a:Set, b:Set):Set
    {
        var item:*;
        var symDiffResult:Set;

        if (a === b)
        {
            return new Set();
        }
        else if (a.length == 0)
        {
            return b.clone();
        }
        else if (b.length == 0)
        {
            return a.clone();
        }
        else
        {
            symDiffResult = a.clone();
            for each (item in b.dict)
            {
                if (!symDiffResult.remove(item))
                {
                    symDiffResult.add(item);
                }
            }
        }

        return symDiffResult;
    }
}
}
