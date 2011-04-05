package test.yellcorp.lib.collections
{
import asunit.framework.TestCase;

import org.yellcorp.lib.collections.BinaryHeap;
import org.yellcorp.lib.collections.Heap;


public class BinaryHeapTest extends TestCase
{
    public function BinaryHeapTest(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testHeap():void
    {
        var expect:Array = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ];
        var actual:Array = [ ];

        var heap:Heap = new BinaryHeap(compare, [ 9, 7, 5, 3, 1 ]);

        assertEquals(5, heap.length);

        heap.add(2);
        heap.add(0);
        heap.add(6);
        heap.add(4);
        heap.add(8);

        assertEquals(10, heap.length);

        while (heap.length > 0)
        {
            actual.push(heap.remove());
        }

        assertEqualsArrays(actual, expect);
    }

    private static function compare(a:int, b:int):int
    {
        return a - b;
    }
}
}
