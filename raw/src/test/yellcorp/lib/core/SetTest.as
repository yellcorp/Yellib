package test.yellcorp.lib.core
{
import asunit.framework.TestCase;

import org.yellcorp.lib.core.Set;


public class SetTest extends TestCase
{
    public function SetTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testSimple():void
    {
        var s:Set = new Set();

        assertEquals(0, s.length);
        assertFalse(s.contains("a"));

        assertThrows(ArgumentError, function ():void {
            s.add(null);
        });

        assertThrows(ArgumentError, function ():void {
            s.add(undefined);
        });

        s.add("a");
        assertEquals(1, s.length);
        assertTrue(s.contains("a"));

        s.remove("a");
        assertFalse(s.contains("a"));
        assertEquals(0, s.length);

        s.add("a");
        s.clear();
        assertEquals(0, s.length);

        s.add("a");
        s.add("a");
        s.add("b");
        assertEquals(2, s.length);

        s.remove("a");
        assertEquals(1, s.length);
    }

    public function testEquality():void
    {
        var a:Set = new Set();
        var b:Set = new Set();

        assertTrue(a.equals(b));
        assertTrue(b.equals(a));

        a.add("a");
        assertFalse(a.equals(b));
        assertFalse(b.equals(a));

        b.add("b");
        assertFalse(a.equals(b));
        assertFalse(b.equals(a));

        a.add("b");
        b.add("a");
        assertTrue(a.equals(b));
        assertTrue(b.equals(a));

        b.remove("b");
        assertFalse(a.equals(b));
        assertFalse(b.equals(a));
    }

    public function testAddIter():void
    {
        var s:Set = new Set();
        var a:Array = charray("abcde");

        s.addIterable(a);
        assertEqualsArraysIgnoringOrder(a, s.toArray());
    }

    public function testRemove():void
    {
        var s:Set = charset("abcde");
        assertTrue(s.remove("a"));
        assertFalse(s.contains("a"));
        assertFalse(s.remove("a"));
        assertFalse(s.remove("z"));
    }

    public function testRemoveIter():void
    {
        var s:Set = charset("abcdef");
        var b:Array = charray("def");

        s.removeIterable(b);
        assertEqualsArraysIgnoringOrder(charray("abc"), s.toArray());
    }

    public function testPop():void
    {
        var s:Set = charset("a");
        assertEquals("a", s.pop());
        assertNull(s.pop());

        s = charset("ab");
        var m:* = s.pop();

        if (m == "a")
        {
            assertEquals("b", s.pop());
        }
        else if (m == "b")
        {
            assertEquals("a", s.pop());
        }
        else
        {
            fail("Somehow got " + m + " from set");
        }
        assertNull(s.pop());
    }

    public function testRelationships():void
    {
        var a:Set = charset("abcdef");
        var b:Set = charset("abc");
        var c:Set = charset("def");

        assertTrue(a.isSubsetOf(a));
        assertTrue(a.isSupersetOf(a));

        assertTrue(b.isSubsetOf(a));
        assertTrue(c.isSubsetOf(a));
        assertTrue(a.isSupersetOf(b));
        assertTrue(a.isSupersetOf(c));

        assertFalse(a.isSubsetOf(b));
        assertFalse(a.isSubsetOf(c));
        assertFalse(b.isSupersetOf(a));
        assertFalse(c.isSupersetOf(a));

        assertFalse(c.isSubsetOf(b));
        assertFalse(c.isSupersetOf(b));

        assertFalse(b.isSubsetOf(c));
        assertFalse(b.isSupersetOf(c));
    }

    public function testClone():void
    {
        var a:Set = charset("abcdef");
        var b:Set = a.clone();

        assertTrue(a.equals(b));
        assertNotSame(a, b);
        b.add("z");
        assertFalse(a.equals(b));
        assertFalse(a.contains("z"));
    }

    public function testOperations():void
    {
        var a:Set = charset("abcd");
        var b:Set = charset("cdef");

        var u:Set = charset("abcdef");
        var i:Set = charset("cd");
        var d:Set = charset("ab");
        var x:Set = charset("abef");

        assertSetsEqual(u, Set.union(a, b));
        assertSetsEqual(i, Set.intersection(a, b));
        assertSetsEqual(d, Set.difference(a, b));
        assertSetsEqual(x, Set.symmetricDifference(a, b));
    }

    public function testEmptyIteration():void
    {
        var count:int = 0;
        var s:Set = new Set();
        var e:*;
        var a:Array = [ ];

        for each (e in s)
        {
            count++;
            a.push(e);
        }
        assertEquals(0, count);
    }

    public function testAliasing():void
    {
        var s:Set;
        var ref:Set;
        var empty:Set;

        s = charset("abcde");
        ref = s.clone();
        empty = new Set();

        assertTrue(s.equals(ref));
        assertTrue(s.equals(s));
        assertTrue(s.isSubsetOf(s));
        assertTrue(s.isSupersetOf(s));

        s.addIterable(s);
        assertTrue(s.equals(ref));

        s.removeIterable(s);
        assertEquals(0, s.length);

        s.addIterable(ref);
        assertTrue(s.equals(ref));

        assertSetsEqual(Set.union(s, s), s);
        assertSetsEqual(Set.intersection(s, s), s);
        assertSetsEqual(Set.difference(s, s), empty);
        assertSetsEqual(Set.symmetricDifference(s, s), empty);
    }

    public function testZeroSet():void
    {
        var s:Set;
        var ref:Set;
        var empty:Set;

        s = charset("abcde");
        ref = s.clone();
        empty = new Set();

        s.addIterable(empty);
        assertSetsEqual(s, ref);

        s.removeIterable(empty);
        assertSetsEqual(s, ref);

        assertTrue(s.isSupersetOf(empty));
        assertFalse(s.isSubsetOf(empty));

        assertFalse(empty.isSupersetOf(s));
        assertTrue(empty.isSubsetOf(s));

        assertSetsEqual(Set.union(s, empty), s);
        assertSetsEqual(Set.union(empty, s), s);
        assertSetsEqual(Set.intersection(empty, s), empty);
        assertSetsEqual(Set.intersection(s, empty), empty);
        assertSetsEqual(Set.difference(empty, s), empty);
        assertSetsEqual(Set.difference(s, empty), s);
        assertSetsEqual(Set.symmetricDifference(empty, s), s);
        assertSetsEqual(Set.symmetricDifference(s, empty), s);
    }

    public function testIteration():void
    {
        var count:int = 0;
        var s:Set = charset("abcde");
        var e:*;
        var a:Array = [ ];

        for each (e in s)
        {
            count++;
            a.push(e);
        }
        assertEquals(5, count);
        assertEqualsArraysIgnoringOrder(charray("abcde"), s.toArray());
    }

    private static function assertSetsEqual(a:Set, b:Set):void
    {
        assertTrue(a.equals(b));
    }

    private static function charray(string:String):Array
    {
        return string.split("");
    }

    private static function charset(string:String):Set
    {
        return new Set(charray(string));
    }
}
}
