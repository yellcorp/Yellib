package org.yellcorp.lib.text
{
import flash.text.Font;
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
        if (text === null || text.length == 0) return;
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

    /**
     * Hack to fix author-time attributes of TextField formats which
     * get forgotten at run time (particularly letterSpacing).  It gets
     * format attributes common to all characters and merges it with the
     * field's default text format.
     */
    public static function fixField(field:TextField):TextField
    {
        var commonFormat:TextFormat = field.getTextFormat();
        var defaultFormat:TextFormat = cloneTextFormat(field.defaultTextFormat);
        mergeTextFormat(defaultFormat, commonFormat);
        field.defaultTextFormat = defaultFormat;
        field.setTextFormat(commonFormat);
        return field;
    }

    public static function fixFields(textFieldArray:Array):void
    {
        var field:TextField;
        for each (field in textFieldArray)
        {
            fixField(field);
        }
    }

    /**
     * Chooses a font from an ordered list in a similar way to CSS.
     * That is, chooses the first available font. If no fonts are available,
     * returns the last one. Note that the CSS values of sans-serif, serif,
     * and monospace map to Flash's builtin font names of _sans, _serif, and
     * _typewriter respectively. Also, mono maps to _typewriter for
     * compatibility with flash.text.StyleSheet.
     *
     * @param fontNameList  A list of fonts. The first available one of
     *                      these will be returned. If none are available,
     *                      the last one will be returned. If null or an
     *                      empty list, will return null.
     *
     * @param includeDevice Whether to consider device fonts in addition to
     *                      embedded fonts. If true, will consider both
     *                      device and embedded fonts. If false, will
     *                      consider embedded fonts only. _sans, _serif, and
     *                      _typewriter are always considered available.
     */
    public static function pickFont(fontNameList:Array, includeDevice:Boolean = true):String
    {
        var fontSet:Object = {};
        var font:Font;
        var fontName:String;
        var ifontName:String;

        if (!fontNameList || fontNameList.length == 0)
        {
            return null;
        }

        for each (font in Font.enumerateFonts(includeDevice))
        {
            fontSet[font.fontName.toLowerCase()] = true;
        }
        for each (fontName in fontNameList)
        {
            ifontName = fontName.toLowerCase();
            switch (ifontName)
            {
            case "_sans":
            case "sans-serif":
                return "_sans";
            case "_serif":
            case "serif":
                return "_serif";
            case "_typewriter":
            case "monospace":
            case "mono":
                return "_typewriter";
            default:
                if (fontSet[ifontName])
                {
                    return fontName;
                }
            }
        }
        return fontNameList[fontNameList.length - 1];
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
