package scratch.htmlclean
{
import org.yellcorp.lib.core.StringUtil;
import org.yellcorp.lib.env.ResizableStage;
import org.yellcorp.lib.markup.htmlclean.HTMLCleanLexer;
import org.yellcorp.lib.markup.htmlclean.HTMLCleanParser;


public class TestClean extends ResizableStage
{
    private var lexer:HTMLCleanLexer;
    private var parser:HTMLCleanParser;

    public function TestClean()
    {
        super();
        lexer = new HTMLCleanLexer();
        parser = new HTMLCleanParser();

        test("<html>Hello <img src='I am the first, me' src=bum.gif?poo&wee=true> Bye</html>");
    }

    private function test(html:String):void
    {
        var clean:String;
        var tokens:Array = lexer.lex(html);
        trace(StringUtil.repeat("-", 20));
        trace(tokens.join("\n"));
        trace(StringUtil.repeat("-", 20));
        clean = parser.parse(tokens);
        trace(clean);
        trace(StringUtil.repeat("-", 20));
    }
}
}
