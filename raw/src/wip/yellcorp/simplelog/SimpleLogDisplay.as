package wip.yellcorp.simplelog
{
import org.yellcorp.layout.LayoutLink;
import org.yellcorp.layout.LayoutProperty;
import org.yellcorp.layout.LayoutSet;
import org.yellcorp.ui.BaseDisplay;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.KeyboardEvent;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;


public class SimpleLogDisplay extends BaseDisplay
{
    protected var background:DisplayObject;
    protected var output:TextField;
    protected var input:TextField;
    protected var _styleSheet:StyleSheet;

    private var layout:LayoutSet;
    private var parsers:Array;

    public function SimpleLogDisplay()
    {
        super(384, 256);

        parsers = [ ];
        _styleSheet = createDefaultStyleSheet();

        setupView();
        setupEvents();

        addParser(new DefaultInputParser());
    }

    protected function addParser(parser:LogInputParser):void
    {
        parsers.push(parser);
    }

    public function appendFormatText(text:String, styleName:String = null):void
    {
        var pinScroll:Boolean;
        var style:Object;
        var format:TextFormat;

        pinScroll = output.scrollV == output.maxScrollV;

        if (styleName)
        {
            style = _styleSheet.getStyle(styleName);
            if (style)
            {
                format = _styleSheet.transform(style);
            }
        }

        output.appendText(text);

        if (format)
        {
            output.setTextFormat(format,
                                 output.text.length - text.length,
                                 output.text.length);
        }

        if (pinScroll)
        {
            output.scrollV = output.maxScrollV;
        }
    }

    protected override function onRender():void
    {
        background.width = width;
        background.height = height;
        layout.updateLayout();
    }

    private function setupView():void
    {
        addChild(background = createBackground());
        addChild(output = createOutputField());
        addChild(input = createInputField());

        output.x = background.x + 4;
        output.y = background.y + 4;

        input.x = output.x;
        input.y = background.x + background.height - input.height - 4;

        input.width =
        output.width = background.width - output.x * 2;

        output.height = input.y - output.y;

        layout = new LayoutSet();
        layout.addLayout(new LayoutLink(output, LayoutProperty.WIDTH, background, LayoutProperty.WIDTH));
        layout.addLayout(new LayoutLink(input, LayoutProperty.WIDTH, background, LayoutProperty.WIDTH));

        layout.addLayout(new LayoutLink(output, LayoutProperty.HEIGHT, background, LayoutProperty.HEIGHT));
        layout.addLayout(new LayoutLink(input, LayoutProperty.Y, background, LayoutProperty.HEIGHT));
    }

    private function setupEvents():void
    {
        input.addEventListener(KeyboardEvent.KEY_UP, onInputKeyUp);
    }

    private function onInputKeyUp(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.ENTER)
        {
            if (parse(input.text))
            {
                input.text = "";
            }
        }
    }

    private function parse(text:String):Boolean
    {
        var i:int;
        var parser:LogInputParser;

        for (i = 0; i < parsers.length; i++)
        {
            parser = parsers[i];
            if (parser.parse(text, this))
            {
                return true;
            }
        }
        return false;
    }

    private function createBackground():DisplayObject
    {
        var s:Shape = new Shape();
        var g:Graphics = s.graphics;

        g.beginFill(0, .75);
        g.drawRect(0, 0, width, height);
        g.endFill();

        return s;
    }

    private function createOutputField():TextField
    {
        var field:TextField = new TextField();

        field.autoSize = TextFieldAutoSize.NONE;
        field.multiline = true;
        field.selectable = true;
        field.wordWrap = true;

        field.defaultTextFormat = _styleSheet.transform(_styleSheet.getStyle("default"));

        return field;
    }

    private function createInputField():TextField
    {
        var field:TextField = new TextField();
        var metrics:TextLineMetrics;

        field.autoSize = TextFieldAutoSize.NONE;
        field.multiline = false;
        field.selectable = true;
        field.wordWrap = false;
        field.type = TextFieldType.INPUT;
        field.border = true;
        field.borderColor = 0x808080;

        field.defaultTextFormat = _styleSheet.transform(_styleSheet.getStyle("default"));

        field.text = "Measure";
        metrics = field.getLineMetrics(0);
        field.height = metrics.height + 4;

        field.text = "";

        return field;
    }

    private function createDefaultStyleSheet():StyleSheet
    {
        var ss:StyleSheet = new StyleSheet();

        var style:XML = <style><![CDATA[
            window {
                background-color: #000000;
                background-alpha: 0.75;
                corner-radius: 6;
                padding: 4;
            }

            default {
                color: #FFFFFF;
                font-family: sans-serif;
                font-size: 11px;
            }

            warning {
                color: #FFEE88;
            }

            error {
                color: #FF8877;
            }

            critical {
                color: #FF0033;
            }
        ]]></style>;

        ss.parseCSS(style);

        return ss;
    }
}
}
