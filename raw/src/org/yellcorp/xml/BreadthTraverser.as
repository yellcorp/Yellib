package org.yellcorp.xml {

public class BreadthTraverser {
    private var _parentNode:XML;
    private var _children:XMLList;
    private var _currentIndex:int;

    public function BreadthTraverser(container:XML) {
        _parentNode = container;
        _children = _parentNode.children();
        reset();
    }

    public function reset():void {
        _currentIndex = 0;
    }

    public function advance():void {
        _currentIndex++;
    }

    public function get currentNode():XML {
        if (_currentIndex < _children.length()) {
            return _children[_currentIndex];
        } else {
            return null;
        }
    }
}
}
