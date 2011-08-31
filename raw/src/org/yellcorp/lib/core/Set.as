package org.yellcorp.lib.core
{
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;


/**
 * A collection of elements in which all elements are unique and order is
 * not defined.  Null elements are not permitted.  Element uniqueness is
 * decided by strict equality (<code>===</code>).
 *
 * This documentation refers to <em>iterables</em>.  This is shorthand for
 * any object that contains zero or more values and supports iteration over
 * them using <code>for each&#x2026;in</code>.  This includes Arrays,
 * Vectors, and the values of dynamic Objects and Dictionaries.  The Set
 * class itself is iterable, although because there are no keys, neither
 * <code>for&#x2026;in</code> iteration, nor <code>[]</code> access are
 * supported.
 */
public class Set extends Proxy
{
    private var dict:Dictionary;
    private var _length:uint;

    private var _currentLoop:Array;

    /**
     * Creates a new Set.
     *
     * @param initialElements An iterable containing the initial elements of
     *                        the new Set.  If this value is omitted or
     *                        <code>null</code>, an empty Set is created.
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
     * Clears the Set.
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
     *               using strict equality (<code>===</code>).
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
     * @throws ArgumentError If the element is <code>null</code>.
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
     * Adds a number of elements from another iterable to the Set.  If
     * an element from the other iterable already exists in this Set,
     * that element is ignored.
     *
     * @param iterable  An iterable containing elements to add.
     * @throws ArgumentError If one of the elements is <code>null</code>.
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
     * Removes a number of elements from the Set.  If an element in the
     * iterable is not in the Set, it is ignored.
     *
     * @param iterable  An iterable containing elements to remove.
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
     * Removes an element from the Set and returns it.  The element that
     * is returned is not defined, as the Set is unordered.  This can
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
     * Tests whether the Set is equal to another one.  Two sets are equal
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
     * Tests if the Set is a subset of, or equal to, another.  A set X is
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
     * Tests if the Set is a superset of, or equal to, another.  A set X is
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
     * Creates a shallow copy of the Set.
     *
     * @return A new set with identical elements to this one.
     */
    public function clone():Set
    {
        return new Set(this);
    }

    /**
     * Returns a new Array containing each element in the Set. The order
     * in which the elements appear in the Array is not defined.
     *
     * @return A new Array containing the Set's elements.
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
     * @return The String representation of the Set.
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
     * element that is a member of <code>v</code>, <code>w</code>, or both.
     */
    public static function union(v:Set, w:Set):Set
    {
        var newSet:Set = v.clone();

        if (v !== w)
        {
            newSet.addIterable(w.dict);
        }

        return newSet;
    }

    /**
     * Returns the difference of two Sets. That is, a new Set containing
     * each element in <code>v</code> that is not also in <code>w</code>.
     */
    public static function difference(v:Set, w:Set):Set
    {
        var differenceResult:Set;

        if (v === w || v.length == 0)
        {
            return new Set();
        }
        else if (w.length == 0)
        {
            return v.clone();
        }
        else
        {
            differenceResult = new Set();
            for each (var e:* in v.dict)
            {
                if (!w.contains(e))
                {
                    differenceResult.add(e);
                }
            }
            return differenceResult;
        }
    }

    /**
     * Returns the intersection of two Sets. That is, a new Set containing
     * each element that is a member of both <code>v</code> and
     * <code>w</code>.
     */
    public static function intersection(v:Set, w:Set):Set
    {
        var intersectionResult:Set;
        var swap:Set;

        if (v === w)
        {
            return v.clone();
        }

        if (v.length > w.length)
        {
            swap = v;
            v = w;
            w = swap;
        }

        intersectionResult = new Set();
        for each (var e:* in v.dict)
        {
            if (w.contains(e))
            {
                intersectionResult.add(e);
            }
        }
        return intersectionResult;
    }

    /**
     * Returns the symmetric difference of two Sets. That is, a new Set
     * containing each element that is is a member of <code>v</code> or
     * <code>w</code>, but without elements that are members of both.
     */
    public static function symmetricDifference(v:Set, w:Set):Set
    {
        var item:*;
        var symDiffResult:Set;

        if (v === w)
        {
            return new Set();
        }
        else if (v.length == 0)
        {
            return w.clone();
        }
        else if (w.length == 0)
        {
            return v.clone();
        }
        else
        {
            symDiffResult = v.clone();
            for each (item in w.dict)
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
