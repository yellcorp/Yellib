package test.yellcorp.lib.collections
{
import asunit.framework.TestCase;

import org.yellcorp.lib.collections.LinkedSet;


public class LinkedSetTest extends TestCase
{
    public function LinkedSetTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testLinkedSet():void
    {
        var dset:LinkedSet = new LinkedSet();

        assertEquals(0, dset.length);
        assertNull(dset.front);
        assertNull(dset.back);

        dset.pushFront("A");
        assertEquals(1, dset.length);
        assertEquals("A", dset.front);
        assertEquals("A", dset.back);

        dset.pushFront("B");
        assertEquals(2, dset.length);
        assertEquals("B", dset.front);
        assertEquals("A", dset.back);

        dset.pushFront("A");
        assertEquals(2, dset.length);
        assertEquals("A", dset.front);
        assertEquals("B", dset.back);

        dset.pushBack("C");
        assertEquals(3, dset.length);
        assertEquals("A", dset.front);
        assertEquals("C", dset.back);

        assertEquals("C", dset.popBack());
        assertEquals(2, dset.length);
        assertEquals("A", dset.front);
        assertEquals("B", dset.back);

        assertEquals("A", dset.popFront());
        assertEquals(1, dset.length);
        assertEquals("B", dset.front);
        assertEquals("B", dset.back);

        dset.pushFront("A");
        dset.pushBack("C");
        assertEqualsArrays(["A","B","C"], dset.toArray());
    }
}
}
