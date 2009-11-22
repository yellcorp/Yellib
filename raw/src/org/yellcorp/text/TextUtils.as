package org.yellcorp.text
{
import flash.text.TextFormat;


public class TextUtils
{
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
}
}
