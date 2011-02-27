package scratch.schema
{
import org.yellcorp.env.ResizableStage;
import org.yellcorp.format.template.Template;


public class NamespaceTest extends ResizableStage
{
    public function NamespaceTest()
    {
        super();

        var i:int, j:int;

        var qnames:Array = [
            new QName("a", "b"),
            new QName("a", "b"),
            new QName("b", "c"),
        ];

        for (j = 0;j < qnames.length;j++)
        {
            for (i = 0;i < qnames.length;i++)
            {
                trace(Template.format("{0}[{1}] == {2}[{3}]: {4}", [qnames[i], i, qnames[j], j, qnames[i]==qnames[j]]));
                trace(Template.format("{0}[{1}] === {2}[{3}]: {4}", [qnames[i], i, qnames[j], j, qnames[i]===qnames[j]]));
                trace("");
            }
        }
    }
}
}
