package wip.yellcorp.lib.profiler
{
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class UglyButton extends Sprite
{
    private var labelField:TextField;

    public function UglyButton(label:String, fill:uint, textCol:uint)
    {
        labelField = new TextField();
        labelField.autoSize = TextFieldAutoSize.LEFT;
        labelField.background = true;
        labelField.backgroundColor = fill;
        labelField.defaultTextFormat = new TextFormat("_sans", 11, textCol);
        labelField.multiline = false;
        labelField.selectable = false;
        labelField.wordWrap = false;

        labelField.text = label;

        addChild(labelField);

        mouseChildren = false;
    }
}
}
