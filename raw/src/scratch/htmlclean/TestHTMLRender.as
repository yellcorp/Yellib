package scratch.htmlclean
{
import org.yellcorp.env.ResizableStage;
import org.yellcorp.string.StringUtil;

import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;


public class TestHTMLRender extends ResizableStage
{
    private static const TESTF_CONDENSE_WHITE:int = 1;
    private static const TESTF_MAX:int = 2;

    private static var samples:Array = [
        "%<br />",
        "%\n<br />",
        "%<br />\n",
        "%\n<br />\n",
        "<p>%</p>",
        "<p>%</p>\n",
        "<p>%\n</p>",
        "<p>%\n</p>\n"
    ];

    public function TestHTMLRender()
    {
        super();
        createView();
    }

    protected override function onStageResize():void
    {
        var i:int;
        var imax:int = TESTF_MAX;

        var j:int;
        var jmax:int = samples.length;

        var n:int = 0;
        var disp:DisplayObject;

        for (j = 0; j < jmax; j++)
        {
            for (i = 0; i < imax; i++)
            {
                disp = getChildAt(n);
                place(disp,
                    i * stage.stageWidth / imax,
                    j * stage.stageHeight / jmax,
                    (i+1) * stage.stageWidth / imax,
                    (j+1) * stage.stageHeight / jmax);
                n++;
            }
        }
    }

    private function createView():void
    {
        var field:TextField;
        var sample:String;

        var i:int;
        var imax:int = TESTF_MAX;

        var j:int;
        var jmax:int = samples.length;

        for (j = 0; j < jmax; j++)
        {
            sample = samples[j];
            sample = sample.replace("%", "text");
            sample = StringUtil.repeat(sample, 20);
            for (i = 0; i < imax; i++)
            {
                field = makeTestTextField(i);
                field.htmlText = sample;
                addChild(field);
            }
        }
    }

    private static function place(disp:DisplayObject, left:Number, top:Number, right:Number, bottom:Number):void
    {
        disp.x = Math.round(left);
        disp.y = Math.round(top);
        disp.width = Math.round(right - left);
        disp.height = Math.round(bottom - top);
    }

    private static function makeTestTextField(props:int):TextField
    {
        var tf:TextField = makeTextField();

        tf.condenseWhite = (props & TESTF_CONDENSE_WHITE) > 0;
        tf.border = true;
        tf.borderColor = 0;

        return tf;
    }

    private static function makeTextField():TextField
    {
        var tf:TextField = new TextField();

        tf.autoSize = TextFieldAutoSize.NONE;
        tf.multiline = true;
        tf.selectable = true;
        tf.type = TextFieldType.DYNAMIC;
        tf.wordWrap = true;

        return tf;
    }
}
}
