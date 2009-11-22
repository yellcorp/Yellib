package org.yellcorp.util {
import flash.utils.Dictionary;


public class NamespaceOptimizer {
    private static const nsPrefixStartChars:String="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";

    private var _original:XML;
    private var _result:XML;

    private var emptyNS:Namespace;
    private var namespaceByUri:Dictionary;
    private var _minLen:uint = 3;

    public function NamespaceOptimizer() {
    }

    private function optimize():void {
        _result = _original.copy();

        namespaceByUri = new Dictionary();
        emptyNS = new Namespace("", "");

        collectNamespaces(_result);
        assignPrefixes();
        declareNamespaces(_result);
        replaceNamespaces(_result);
    }

    private function assignPrefixes():void {
        var iterNS:Namespace;
        var newPrefixes:Dictionary = new Dictionary();
        var parts:Array;

        var strLen:int;
        var prefixBase:String;
        var newPrefix:String;

        var fallbackCounter:int = 1;

        for each (iterNS in namespaceByUri) {
            parts = getUriParts(iterNS);
            strLen = 0;
            do {
                if (parts.length > 0) {
                    if (strLen < _minLen || strLen > prefixBase.length) {
                        prefixBase = parts.pop();
                        strLen = _minLen;
                    }
                    newPrefix = prefixBase.substr(0,strLen);
                    strLen++;
                } else {
                    newPrefix = "ns" + (fallbackCounter++);
                }
            } while (nsPrefixAllowed(newPrefix) && newPrefixes[newPrefix] != null);

            newPrefixes[newPrefix] = new Namespace(newPrefix, iterNS.uri);
        }

        namespaceByUri = new Dictionary();
        for each (iterNS in newPrefixes) {
            namespaceByUri[iterNS.uri] = iterNS;
        }
    }

    private function nsPrefixAllowed(newPrefix:String):Boolean {
        if (newPrefix.substr(0,3).toLowerCase() == "xml") {
            return false;
        }
        if (nsPrefixStartChars.indexOf(newPrefix.charAt(0)) < 0) {
            return false;
        }
        return true;
    }

    private function getUriParts(ns:Namespace):Array {
        var source:String;
        var splitPoint:int = ns.uri.indexOf(':');

        if (splitPoint >= 0 && splitPoint < ns.uri.length-1) {
            source = ns.uri.substr(splitPoint+1);
        } else {
            source = ns.uri;
        }

        var slashSplit:Array = source.split("/");
        var parts:Array = new Array();

        for each (source in slashSplit) {
            if (source == "") continue;
            parts = parts.concat(source.split(/[^A-Za-z0-9_-]+/).reverse());
        }
        parts = parts.filter(removeNulls);

        return parts;
    }

    private function removeNulls(item:*, index:int, array:Array):Boolean {
        return (item != null && item is String && item != "");
    }

    private function declareNamespaces(tag:XML):void {
        var declNS:Namespace;

        for each (declNS in namespaceByUri) {
            tag.addNamespace(declNS);
        }
    }

    private function collectNamespaces(tag:XML):void {
        var ns:Namespace = tag.namespace();
        var iterTag:XML;

        if (ns==null) return;

        if (!namespaceByUri[ns.uri]) {
            namespaceByUri[ns.uri] = ns;
        }

        for each (iterTag in tag.children()) {
            collectNamespaces(iterTag);
        }
    }

    private function replaceNamespaces(tag:XML, isRoot:Boolean=true):void {
        var origNS:Namespace = tag.namespace();
        var newNS:Namespace;
        var declNS:Namespace;
        var iterTag:XML;

        if (origNS != null)
        {
            newNS = namespaceByUri[origNS.uri];
            tag.setNamespace(emptyNS);
        }
        for each (iterTag in tag.children()) {
            replaceNamespaces(iterTag, false);
        }
        for each (declNS in tag.namespaceDeclarations()) {
            if (!isRoot || declNS.prefix != (namespaceByUri[declNS.uri] as Namespace).prefix) {
                tag.removeNamespace(declNS);
            }
        }
        if (origNS!=null) {
            tag.setNamespace(newNS);
        }
    }

    private function dumpNamespace(ns:Namespace):String {
        return(ns.prefix + ":" + ns.uri);
    }

    public function get original():XML {
        return _original;
    }

    public function set original(original:XML):void {
        _original = original;
    }

    public function get optimized():XML {
        optimize();
        return _result;
    }

    public function get minPrefixLength():uint {
        return _minLen;
    }

    public function set minPrefixLength(minLen:uint):void {
        if (minLen > 0) _minLen = minLen;
    }
}
}
