package scratch.textfield
{
import org.yellcorp.env.ResizableStage;
import org.yellcorp.text.highlighter.SimpleHighlightDrawer;
import org.yellcorp.text.highlighter.TextFieldHighlighter;

import flash.display.BlendMode;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;


public class TestHighlighter extends ResizableStage
{
    private var field:TextField;
    private var highlights:Shape;
    private var drawer:SimpleHighlightDrawer;
    private var highlighter:TextFieldHighlighter;

    public function TestHighlighter()
    {
        super();
        addChild(field = makeTextField());
        addChild(highlights = new Shape());
        highlights.blendMode = BlendMode.DIFFERENCE;
        field.text = "0123456789ABCDEF here's \nsome text here's some text\n\n " +
            "here's some text here's some text here's some text " +
            "here's some more text and more and more and text and more #" +
            "25 Sep 2009 ... Block objects (informally, “blocks”) are an extension " +
            "to C, as well as Objective-C and C++, that make it easy for programmers to define ..." +
            "developer.apple.com/mac/articles/cocoa/introblocksgcd.html - Cached - Similar" +
            "Cocoa for Scientists (Part XXVII): Getting Closure with Objective ..." +
            "15 posts - 14 authors - Last post: 16 Dec 2008" +
            "Chris Lattner's announcement details how blocks will be used in C and Objective-C, and — in essence — it is similar to the Python example ..." +
            "www.macresearch.org/cocoa-scientists-part-xxvii-getting-closure-objective-c - Cached - Similar" +
            "Cocoa for Scientists (Part II): Classy Cocoa‎ - 20 Feb 2010" +
            "Cocoa for Scientists (XXXIII): 10 Uses for Blocks in C/Objective-C ...‎ - 30 Jan 2010" +
            "Cocoa for Scientists (Part V): It's All in the Genes‎ - 16 Dec 2009" +
            "More results from macresearch.org »" +
            "Get more discussion results" +
            "#" +
            "Blog | Plausible Labs » Blocks for iPhoneOS 3.0 and Mac OS X 10.5" +
            "Blocks are a great addition to Objective-C, but unfortunately, are " +
            "only available in Mac OS X 10.6. We have a quite a bit of code that could be greatly ..." +
            "www.plausiblelabs.com/blog/?p=8 - Cached - Similar" +
            "#" +
            "mikeash.com: Friday Q&A 2008-12-26" +
            "26 Dec 2008 ... Thanks for introducing the blocks to objective-c community in a bit more detailed way. The " +
            "method example greatly simplifies the ..." +
            "www.mikeash.com/pyblog/friday-qa-2008-12-26.html - Cached" +
            "#" +
            "Closure or Block with Objective-C in Snow Leopard « JongAm's blog" +
            "11 Sep 2009 ... So, I would like to put some links for block. Programming " +
            "with C Blocks on Apple Devices · Mac Fanatic ” Blocks: Coming to Objective-C Soon ..." +
            "jongampark.wordpress.com/.../closure-or-block-with-objective-c-in-snow-leopard/ - ";

        drawer = new SimpleHighlightDrawer(highlights, 0x0000FF);
        highlighter = new TextFieldHighlighter(field, drawer);
        highlighter.setHighlightLength(int(field.length / 2), 48);
        highlighter.setHighlightLength(int(field.length / 4), 8);
    }

    private function makeTextField():TextField
    {
        var tf:TextField = new TextField();
        tf.autoSize = TextFieldAutoSize.NONE;
        tf.wordWrap = true;
        tf.multiline = true;
        tf.type = TextFieldType.INPUT;
        tf.defaultTextFormat = new TextFormat("_sans", 15, 0);
        return tf;
    }

    protected override function onStageResize():void
    {
        field.width = stage.stageWidth;
        field.height = stage.stageHeight;
        highlighter.draw();
    }
}
}
