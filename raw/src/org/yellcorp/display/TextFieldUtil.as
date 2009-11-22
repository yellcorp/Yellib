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
}
}
