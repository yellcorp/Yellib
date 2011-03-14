package org.yellcorp.lib.xml.nso
{
import org.yellcorp.lib.core.MapUtil;
import org.yellcorp.lib.xml.XMLTraverser;


public class NamespaceOptimizer
{
    private var nsCount:Object;
    private var nsCounter:XMLTraverser;
    private var nameGenerator:NameGenerator;
    private var nsByURI:Object;

    private var newDocRoot:XML;
    private var currentParent:XML;
    private var rebuilder:XMLTraverser;

    public function NamespaceOptimizer()
    {
        nsCounter = new XMLTraverser();
        nsCounter.openElementHandler = countOpenTag;

        rebuilder = new XMLTraverser();
        rebuilder.openElementHandler = rebuildOpenTag;
        rebuilder.closeElementHandler = rebuildCloseTag;
        rebuilder.textHandler = rebuildText;

        nameGenerator = new NameGenerator();
    }

    public function optimize(doc:XML):XML
    {
        assignNSPrefixes(doc);
        rebuild(doc);
        return newDocRoot;
    }

    private function rebuild(doc:XML):void
    {
        newDocRoot =
        currentParent = null;
        rebuilder.traverse(doc);
    }

    private function rebuildOpenTag(node:XML):void
    {
        var newNode:XML = <x />;
        var nsDeclScope:XML = newDocRoot || newNode;

        newNode.setName(getNewName(node, nsDeclScope));

        for each (var attr:XML in node.attributes())
        {
            newNode.@[getNewName(attr, nsDeclScope)] = attr.toString();
        }

        if (currentParent)
        {
            currentParent.appendChild(newNode);
            currentParent = newNode;
        }
        else
        {
            newDocRoot =
            currentParent = newNode;
        }
    }

    private function getNewName(reference:XML, nsDeclScope:XML):QName
    {
        var newNS:Namespace = getNewNamespace(reference.name());
        var newName:QName = new QName(newNS, reference.localName());
        nsDeclScope.addNamespace(newNS);
        return newName;
    }

    private function getNewNamespace(name:QName):Namespace
    {
        if (!name.uri)
        {
            return new Namespace();
        }
        else if (nsByURI.hasOwnProperty(name.uri))
        {
            return nsByURI[name.uri];
        }
        else
        {
            throw new Error("Internal error: URI never counted: " + name.uri);
        }
    }

    private function rebuildCloseTag(node:XML):void
    {
        currentParent = currentParent.parent();
    }

    private function rebuildText(node:XML):void
    {
        currentParent.appendChild(node);
    }

    private function assignNSPrefixes(doc:XML):void
    {
        var nsByFreq:Array;
        var uri:String;

        nsCount = { };
        nsCounter.traverse(doc);
        nsByFreq = sortKeysByFrequency(nsCount);

        nameGenerator.reset();
        nsByURI = { };

        for (var i:int = 0; i < nsByFreq.length; i++)
        {
            uri = nsByFreq[i];
            if (!uri) continue;
            nsByURI[uri] = new Namespace(nameGenerator.getNextName(), uri);
        }
    }

    private function countOpenTag(node:XML):void
    {
        countNamespace(node.name());
        for each (var attr:XML in node.attributes())
        {
            countNamespace(attr.name());
        }
    }

    private function countNamespace(name:QName):void
    {
        if (nsCount.hasOwnProperty(name.uri))
        {
            nsCount[name.uri]++;
        }
        else
        {
            nsCount[name.uri] = 1;
        }
    }

    private static function sortKeysByFrequency(table:Object):Array
    {
        var kvPairs:Array = MapUtil.mapToArray(table);
        kvPairs.sortOn("1", Array.NUMERIC | Array.DESCENDING);
        return kvPairs.map(
            function (pair:Array, i:int, a:Array):String
            {
                return pair[0];
            }
        );
    }
}
}
