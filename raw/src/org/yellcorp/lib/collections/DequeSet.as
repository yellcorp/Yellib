package org.yellcorp.lib.collections
{
import org.yellcorp.lib.iterators.readonly.Iterator;

import flash.utils.Dictionary;


public class DequeSet
{
    private var nodeLookup:Dictionary;

    private var _front:Node;
    private var _back:Node;

    private var _length:int;

    public function DequeSet()
    {
        clear();
    }

    public function clear():void
    {
        nodeLookup = new Dictionary();

        _front = new Node(null);
        _back = new Node(null);
        Node.link(_front, _back);

        _length = 0;
    }

    public function get length():int
    {
        return _length;
    }

    public function get front():*
    {
        return _front.next.value;
    }

    public function get back():*
    {
        return _back.prev.value;
    }

    public function pushFront(element:*):void
    {
        if (element == null)
        {
            throw new ArgumentError("DequeSet cannot contain null members");
        }
        var node:Node = takeNode(element);
        Node.insertAfter(_front, node);
    }

    public function pushBack(element:*):void
    {
        if (element == null)
        {
            throw new ArgumentError("DequeSet cannot contain null members");
        }
        var node:Node = takeNode(element);
        Node.insertBefore(_back, node);
    }

    public function popFront():*
    {
        var oldFront:* = _front.next.value;
        remove(oldFront);
        return oldFront;
    }

    public function popBack():*
    {
        var oldBack:* = _back.prev.value;
        remove(oldBack);
        return oldBack;
    }

    public function contains(query:*):Boolean
    {
        return nodeLookup[query] != null;
    }

    public function remove(element:*):Boolean
    {
        var node:Node = nodeLookup[element];
        if (node)
        {
            Node.unlink(node);
            delete nodeLookup[element];
            _length--;
            return true;
        }
        else
        {
            return false;
        }
    }

    public function toArray():Array
    {
        var array:Array = [ ];
        for (var node:Node = _front.next; node !== _back; node = node.next)
        {
            array.push(node.value);
        }
        return array;
    }

    public function get iterator():Iterator
    {
        return new NodeIterator(_front, _back);
    }

    private function takeNode(element:*):Node
    {
        var node:Node = nodeLookup[element];
        if (node)
        {
            Node.unlink(node);
        }
        else
        {
            node = new Node(element);
            nodeLookup[element] = node;
            _length++;
        }
        return node;
    }
}
}

import org.yellcorp.lib.iterators.readonly.Iterator;


class Node
{
    public var prev:Node;
    public var value:*;
    public var next:Node;

    public function Node(value:*)
    {
        this.value = value;
    }

    public static function breakNext(node:Node):Node
    {
        var oldNext:Node = node.next;
        if (oldNext)
        {
            node.next = null;
            oldNext.prev = null;
        }
        return oldNext;
    }

    public static function breakPrev(node:Node):Node
    {
        var oldPrev:Node = node.prev;
        if (oldPrev)
        {
            node.prev = null;
            oldPrev.next = null;
        }
        return oldPrev;
    }

    public static function link(first:Node, second:Node):void
    {
        if (first && second)
        {
            breakNext(first);
            breakPrev(second);
            first.next = second;
            second.prev = first;
        }
        else if (first)
        {
            breakNext(first);
        }
        else if (second)
        {
            breakPrev(second);
        }
    }

    public static function unlink(node:Node):void
    {
        link(node.prev, node.next);
    }

    public static function insertAfter(reference:Node, newNode:Node):void
    {
        var back:Node = reference.next;
        link(reference, newNode);
        link(newNode, back);
    }

    public static function insertBefore(reference:Node, newNode:Node):void
    {
        var front:Node = reference.prev;
        link(front, newNode);
        link(newNode, reference);
    }
}


class NodeIterator implements Iterator
{
    private var start:Node;
    private var terminal:Node;

    private var node:Node;

    public function NodeIterator(start:Node, terminal:Node)
    {
        this.start = start;
        this.terminal = terminal;
        node = start.next;
    }

    public function get valid():Boolean
    {
        return node != terminal;
    }

    public function get current():*
    {
        return node.value;
    }

    public function next():void
    {
        node = node.next;
    }

    public function reset():void
    {
        node = start;
    }
}
