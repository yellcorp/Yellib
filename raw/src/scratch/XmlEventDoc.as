package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.xml.Traverser;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;


public class XmlEventDoc extends ConsoleApp
{
    private var docLoader:URLLoader;
    private var doc:XML;

    public function XmlEventDoc()
    {
        super();

        docLoader = new URLLoader();
        docLoader.addEventListener(Event.COMPLETE, onDocLoaded, false, 0, true);
        docLoader.load(new URLRequest("wsdltest.xml"));
    }

    private function onDocLoaded(event:Event):void
    {
        var t:Traverser;
        var node:XML;

        doc = XML(docLoader.data);
        t = new Traverser(doc);

        do
        {
            node = t.currentNode;
            if (!node) continue;

            writeln([node.nodeKind(), node.name()].join(" "));
            t.advance();
        } while (node);
    }
}
}
