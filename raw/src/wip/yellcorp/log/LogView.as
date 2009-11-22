package wip.yellcorp.log
{
import org.yellcorp.regexp.RegExpUtil;

import wip.yellcorp.display.BaseDisplay;
import wip.yellcorp.display.TextFieldHighlighter;

import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class LogView extends BaseDisplay
{
    private var background:DisplayObject;
    private var textField:TextField;
    private var hilightLayer:Sprite;
    private var styleSheet:StyleSheet;
    private var textComposite:Sprite;
    private var hilighter:TextFieldHighlighter;

    public function LogView()
    {
        styleSheet = createStyleSheet();
        setupView();
        super();
        onRender();
    }

    public function print(string:String):void
    {
        textField.appendText(string);
    }

    public function printStyle(string:String, styleName:String):void
    {
        var format:TextFormat;

        print(string);

        format = styleSheet.transform(styleSheet.getStyle(styleName));
        textField.setTextFormat(format,
                                textField.text.length - string.length,
                                textField.text.length);
    }

    public function hilightString(search:String, caseSensitive:Boolean):void
    {
        var options:String;
        var re:RegExp;

        options = caseSensitive ? "" : "i";
        re = RegExpUtil.createLiteralRegExp(search, options);

        hilightRegExp(re);
    }

    public function hilightRegExp(regExp:RegExp):void
    {
        var match:Object;

        if (!regExp.global)
        {
            regExp = RegExpUtil.changeFlags(regExp, "g");
        }

        do {
            match = regExp.exec(textField.text);
            if (match)
            {
                hilighter.setHilightRange(match.index, match[0].length);
            }
        } while (match);
    }

    protected override function onRender():void
    {
        background.width = width;
        background.height = height;

        textField.width = width - 2 * textComposite.x;
        textField.height = height - 2 * textComposite.y;

        hilighter.redraw();
    }

    private function setupView():void
    {
        addChild(background = createBackground());
        addChild(textComposite = new Sprite());

        textComposite.addChild(textField = createTextField());
        textComposite.addChild(hilightLayer = createHilightLayer());

        textComposite.x = 6;
        textComposite.y = 6;

        hilighter = new TextFieldHighlighter(textField, hilightLayer);
    }

    private function createHilightLayer():Sprite
    {
        var hl:Sprite = new Sprite();
        hl.blendMode = BlendMode.DIFFERENCE;

        return hl;
    }

    private function createBackground():DisplayObject
    {
        var s:Shape = new Shape();
        var g:Graphics = s.graphics;

        g.beginFill(0, .75);
        g.drawRect(0, 0, 384, 256);
        g.endFill();

        return s;
    }

    private function createTextField():TextField
    {
        var field:TextField = new TextField();

        field.autoSize = TextFieldAutoSize.NONE;
        field.multiline = true;
        field.selectable = true;
        field.wordWrap = true;

        field.defaultTextFormat = styleSheet.transform(styleSheet.getStyle("default"));

        return field;
    }

    private function createStyleSheet():StyleSheet
    {
        var ss:StyleSheet = new StyleSheet();

        var style:XML = <style><![CDATA[
            default {
                color: #FFFFFF;
                font-family: sans-serif;
                font-size: 12px;
            }

            warning {
                color: #FFEE88;
            }

            error {
                color: #FF9999;
            }
        ]]></style>;

        ss.parseCSS(style);

        return ss;
    }
}
}
