package scratch
{
import org.yellcorp.env.ResizableStage;
import org.yellcorp.markup.htmlclean.HTMLTransformer;


public class TestHTML extends ResizableStage
{
    public function TestHTML()
    {
        super();
        var ht:HTMLTransformer = new HTMLTransformer();
        var xml:XML =
        <html>
        <!-- a comment you dilz -->
        <thing attrib="1" attrib="2">it's a <nuvver>fing</nuvver>!??</thing>
        </html>;

        ht.transform(xml);
    }
}
}
