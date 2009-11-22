package org.yellcorp.xml {

public class Traverser {
    private var _document:XML;
    private var traversers:Array;

    public function Traverser(document:XML) {
        _document = document;
        reset();
    }

    public function reset():void {
        traversers=new Array();
        push(_document);
    }

    public function advance():void {
        var nextNode:XML;

        if (currentNode.children().length() > 0) {
            push(currentNode);
        } else {
            currentLevel().advance();
            do {
                nextNode = currentNode;
                if (nextNode == null) {
                    pop();
                    currentLevel().advance();
                }
            } while (nextNode == null && traversers.length > 1);
        }
    }

    public function get currentNode():XML {
        return currentLevel().currentNode;
    }

    public function get currentDepth():int {
        return traversers.length - 1;
    }

    private function currentLevel():BreadthTraverser {
        return traversers[0] as BreadthTraverser;
    }

    private function pop():void {
        if (traversers.length <= 0) {
            throw new ReferenceError("Nothing in traversers array");
        }
        traversers.shift();
    }

    private function push(containerNode:XML):void {
        traversers.unshift(new BreadthTraverser(containerNode));
    }
}
}
