package org.yellcorp.text
{
import flash.text.TextField;


public class TruncateSuffixTextProxy
{
    private var field:TextField;
    private var _suffix:String;
    private var _text:String;

    // text field gutter width of 4 is hard-coded in flash
    // player, see documentation for TextLineMetrics
    private static const TEXTFIELD_PADDING:Number = 4;

    public function TruncateSuffixTextProxy(targetTextField:TextField, truncateSuffix:String = "...")
    {
        field = targetTextField;
        _suffix = truncateSuffix;
        _text = targetTextField.text;
    }

    public function get suffix():String
    {
        return _suffix;
    }

    public function set suffix(new_suffix:String):void
    {
        if (_suffix !== new_suffix)
        {
            _suffix = new_suffix;
            update();
        }
    }

    public function get text():String
    {
        return _text;
    }

    public function set text(new_text:String):void
    {
        if (_text !== new_text)
        {
            _text = new_text;
            update();
        }
    }

    public function get width():Number
    {
        return field.width;
    }

    public function set width(new_width:Number):void
    {
        if (field.width !== new_width)
        {
            field.width = new_width;
            update();
        }
    }

    public function update():void
    {
        var textWidth:Number;
        var suffixWidth:Number;
        var lastVisibleIndex:int;

        field.text = _text;
        if (_text.length == 0) return;

        textWidth = field.getLineMetrics(0).width;

        if (field.width < textWidth + TEXTFIELD_PADDING)
        {
            field.appendText(suffix);
            suffixWidth = field.getLineMetrics(0).width - textWidth;

            lastVisibleIndex =
                field.getCharIndexAtPoint(
                    field.width - suffixWidth - TEXTFIELD_PADDING,
                    field.height / 2);

            if (lastVisibleIndex < 1)
            {
                field.text = _suffix;
            }
            else
            {
                field.text = _text.substr(0, lastVisibleIndex) + _suffix;
            }
        }
    }
}
}
