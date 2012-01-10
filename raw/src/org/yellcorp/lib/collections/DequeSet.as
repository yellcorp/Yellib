package org.yellcorp.lib.collections
{
import org.yellcorp.lib.iterators.readonly.Iterator;

import flash.utils.Dictionary;


/**
 * An ordered set implemented as a doubly-linked list. All members are unique;
 * if a member that already exists in the DequeSet is inserted, it is moved
 * from its old position to its new position.  Addition, removal, and
 * retrieval from either end of the list are constant time.  Membership testing
 * by value, removal by value and insertion relative to value are also constant
 * time.  Operations by numeric index are linear time.
 */
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

    public function pushFront(member:*):void
    {
        checkMember(member);
        var node:Node = takeNode(member);
        Node.insertAfter(_front, node);
    }

    public function pushBack(member:*):void
    {
        checkMember(member);
        var node:Node = takeNode(member);
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

    public function remove(member:*):Boolean
    {
        var node:Node = nodeLookup[member];
        if (node)
        {
            Node.unlink(node);
            delete nodeLookup[member];
            _length--;
            return true;
        }
        else
        {
            return false;
        }
    }

    public function insertAfter(newMember:*, referenceMember:*):void
    {
        checkRelativeArguments(newMember, referenceMember);
        var reference:Node = nodeLookup[referenceMember];
        var node:Node = takeNode(newMember);
        Node.insertAfter(reference, node);
    }

    public function insertBefore(newMember:*, referenceMember:*):void
    {
        checkRelativeArguments(newMember, referenceMember);
        var reference:Node = nodeLookup[referenceMember];
        var node:Node = takeNode(newMember);
        Node.insertBefore(reference, node);
    }

    // O(n) manipulations
    public function get(index:int):*
    {
        return getNodeAtIndex(index).value;
    }

    public function indexOf(query:*):int
    {
        var rover:Node = nodeLookup[query];
        var index:int = -1;
        if (rover)
        {
            while (rover !== _front)
            {
                rover = rover.prev;
                index++;
            }
        }
        return index;
    }

    public function removeAt(index:int):*
    {
        var memberToRemove:* = get(index);
        remove(memberToRemove);
        return memberToRemove;
    }

    public function insertAt(newMember:*, index:int):void
    {
        checkMember(newMember);
        if (index === 0)
        {
            pushFront(newMember);
        }
        else if (index >= _length)
        {
            pushBack(newMember);
        }
        else
        {
            var node:Node = takeNode(newMember);
            Node.insertBefore(getNodeAtIndex(index), node);
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

    private function takeNode(member:*):Node
    {
        var node:Node = nodeLookup[member];
        if (node)
        {
            Node.unlink(node);
        }
        else
        {
            node = new Node(member);
            nodeLookup[member] = node;
            _length++;
        }
        return node;
    }

    private function getNodeAtIndex(index:int):Node
    {
        var rover:Node = null;
        if (index >= 0 && index < _length)
        {
            rover = _front.next;
            for (var i:int = 0; i < index; i++)
            {
                rover = rover.next;
            }
        }
        return rover;
    }

    private function checkMember(newMember:*):void
    {
        if (newMember == null)
        {
            throw new ArgumentError("DequeSet cannot contain null members");
        }
    }

    private function checkRelativeArguments(newMember:*, referenceMember:*):void
    {
        checkMember(newMember);
        if (nodeLookup[referenceMember] == null)
        {
            throw new ArgumentError("Reference member does not exist in this DequeSet");
        }
        if (newMember === referenceMember)
        {
            throw new ArgumentError("Member cannot be specifed relative to itself");
        }
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
