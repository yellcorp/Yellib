package scratch.xml
{
import org.yellcorp.lib.env.ConsoleApp;
import org.yellcorp.lib.xml.nso.NamespaceOptimizer;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;


public class TestNSO extends ConsoleApp
{
    private var loader:URLLoader;

    public function TestNSO()
    {
        super();
        loader = new URLLoader(new URLRequest("EPGUserDataService.wsdl.xml"));
        loader.addEventListener(Event.COMPLETE, onComplete);
    }

    private function onComplete(event:Event):void
    {
        var xml:XML = XML(loader.data);
        var nso:NamespaceOptimizer = new NamespaceOptimizer();
        trace(nso.optimize(xml));
    }
}
}
