package scratch.debugconsole
{
import org.yellcorp.lib.debug.console.richtext.RichTextComposer;
import org.yellcorp.lib.debug.console.richtext.TestExpandBlock;
import org.yellcorp.lib.debug.console.richtext.TestNumberTextBlock;
import org.yellcorp.lib.env.ResizableStage;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;


public class TestRichText extends ResizableStage
{
    private var field:TextField;
    private var comp:RichTextComposer;

    public function TestRichText()
    {
        super();
        addChild(field = makeField());
        comp = new RichTextComposer(field);
        comp.appendBlock(new TestNumberTextBlock());
        comp.appendBlock(new TestExpandBlock());
        comp.appendBlock(new TestNumberTextBlock());

        comp.composeAll();
    }

    protected override function onStageResize():void
    {
        field.width = stage.stageWidth - 2;
        field.height = stage.stageHeight - 2;
    }

    private function makeField():TextField
    {
        var f:TextField = new TextField();
        f.type = TextFieldType.DYNAMIC;
        f.autoSize = TextFieldAutoSize.NONE;
        f.multiline = true;
        f.selectable = true;
        f.wordWrap = true;

        f.defaultTextFormat = new TextFormat("_sans", 12);

        f.border = true;
        f.x = f.y = 1;

        return f;
    }
}
}
