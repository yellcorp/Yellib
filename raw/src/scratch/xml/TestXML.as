package scratch.xml
{
import org.yellcorp.env.ConsoleApp;


public class TestXML extends ConsoleApp
{
    public function TestXML()
    {
        super();

        var doc:XML =
        <doc docAttr1="docValue1">
            doc text content
            <tag tagAttr1="tagValue1" tagAttr2="tagValue2">
                tag text content
            </tag>
            <tag moreAttr="more" />
        </doc>;

        for each (var tag:XML in doc.elements())
        {
            writeln(tag.localName());
            for each (var attr:XML in tag.attributes())
            {
                writeln("   " + attr.localName() + "=" + attr.toString());
            }
        }
    }
}
}
