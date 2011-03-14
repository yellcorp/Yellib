package scratch
{
import org.yellcorp.lib.events.XMLParseErrorEvent;
import org.yellcorp.tools.EventMetadata;

import flash.display.Sprite;


public class TestEventMetadata extends Sprite
{
    public function TestEventMetadata()
    {
        trace(EventMetadata.generate(XMLParseErrorEvent).join("\n"));
    }
}
}
