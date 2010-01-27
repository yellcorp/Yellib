package org.yellcorp.display
{
import flash.text.TextField;
import flash.text.TextFormat;


public class TextFieldUtil
{
    public static function appendWithFormat(target:TextField, text:String, format:TextFormat = null):void
    {
        if (text === null) text = "";
        if (format === null) format = target.defaultTextFormat;

        target.appendText(text);
        target.setTextFormat(format, target.text.length - text.length, target.text.length);
    }

    public static function mergeTextFormat(base:TextFormat, ... formatList):TextFormat
    {
        return _mergeTextFormat(base, formatList);
    }

    private static function _mergeTextFormat(base:TextFormat, formatList:Array):TextFormat
    {
        var next:TextFormat;
        if (!formatList || formatList.length == 0)
        {
            return base;
        }
        else
        {
            next = formatList.shift();
            copyNonNullProperties(next, base, [
                "align", "blockIndent", "bold", "bullet", "color", "font",
                "indent", "italic", "kerning", "leading", "leftMargin",
                "letterSpacing", "rightMargin", "size", "tabStops",
                "target", "underline", "url" ]);
            if (formatList.length > 0)
            {
                _mergeTextFormat(base, formatList);
            }
        }
        return base;
    }

    private static function copyNonNullProperties(source:Object, target:Object, props:Array):void
    {
        for each (var prop:String in props)
            if (source[prop] !== null) target[prop] = source[prop];
    }
}
}
