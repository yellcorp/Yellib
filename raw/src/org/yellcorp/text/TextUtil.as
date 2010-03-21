package org.yellcorp.text
{
import flash.text.TextField;
import flash.text.TextFormat;


public class TextUtil
{
    public static function cloneTextField(field:TextField):TextField
    {
        var clone:TextField = new TextField();

        clone.embedFonts = field.embedFonts;
        clone.defaultTextFormat = cloneTextFormat(field.defaultTextFormat);

        clone.alwaysShowSelection = field.alwaysShowSelection;
        clone.background = field.background;
        clone.backgroundColor = field.backgroundColor;
        clone.border = field.border;
        clone.borderColor = field.borderColor;
        clone.condenseWhite = field.condenseWhite;
        clone.displayAsPassword = field.displayAsPassword;
        clone.gridFitType = field.gridFitType;
        clone.maxChars = field.maxChars;
        clone.mouseWheelEnabled = field.mouseWheelEnabled;
        clone.restrict = field.restrict;
        clone.selectable = field.selectable;
        clone.type = field.type;

        clone.styleSheet = field.styleSheet;

        clone.antiAliasType = field.antiAliasType;
        clone.sharpness = field.sharpness;
        clone.thickness = field.thickness;

        clone.multiline = field.multiline;
        clone.wordWrap = field.wordWrap;
        clone.autoSize = field.autoSize;

        clone.x = field.x;
        clone.y = field.y;
        clone.width = field.width;
        clone.height = field.height;

        return clone;
    }

    public static function appendWithFormat(target:TextField, text:String, format:TextFormat = null):void
    {
        if (text === null) text = "";
        if (format === null) format = target.defaultTextFormat;

        target.appendText(text);
        target.setTextFormat(format, target.text.length - text.length, target.text.length);
    }

    public static function cloneTextFormat(format:TextFormat):TextFormat
    {
        return new TextFormat(format.font, format.size,
                              format.color, format.bold,
                              format.italic, format.underline,
                              format.url, format.target,
                              format.align, format.leftMargin,
                              format.rightMargin, format.indent,
                              format.leading);
    }

    public static function mergeTextFormat(base:TextFormat, ... formatList):TextFormat
    {
        return _mergeTextFormat(base, formatList);
    }

    /**
     * Convenience fixer method as dynamic text fields seem to lose the
     * letterSpacing attribute set in the Flash IDE
     */
    public static function setDefaultLetterSpacing(field:TextField, letterSpacing:Number):TextField
    {
        var format:TextFormat = field.defaultTextFormat;
        format.letterSpacing = letterSpacing;
        field.defaultTextFormat = format;
        return field;
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
