package scratch.xml
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.markup.htmlclean.HTMLCleanFilter;


public class TestHTMLFilter extends ConsoleApp
{
    public function TestHTMLFilter()
    {
        super();

        var doc:XML =
        <html>
            fart an arse out of my <a href="http://balls" onmouseover="no!">mouth</a>
            <div>
                <table>
                    <tr><td>shitballs</td></tr>
                </table>
            </div>
        </html>;

        var hcf:HTMLCleanFilter = new HTMLCleanFilter();
        writeln(hcf.filter(doc));
    }
}
}
