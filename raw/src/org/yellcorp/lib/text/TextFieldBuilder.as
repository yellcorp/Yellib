package org.yellcorp.lib.text
{
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class TextFieldBuilder
{
    private var _fontFamily:String = "_sans";
    private var _fontSize:Object = 12;
    private var _fontColor:Object = 0x000000;
    private var _fontBold:Object;
    private var _fontItalic:Object;

    private var _align:String = TextFormatAlign.LEFT;
    private var _wordWrap:Boolean;
    private var _multiline:Boolean;
    private var _autoSize:Boolean;
    private var _selectable:Boolean;
    private var _border:uint = 0xFF000000;

    private var _input:Boolean = false;
    private var _maxChars:int = 0;
    private var _restrict:String = "";

    private var _width:Number;
    private var _height:Number;

    private var _text:String = "";


    public function TextFieldBuilder()
    {
    }


    public function font(family:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null):TextFieldBuilder
    {
        if (family !== null) _fontFamily = family;
        if (size !== null) _fontSize = size;
        if (color !== null) _fontColor = color;
        if (bold !== null) _fontBold = bold;
        if (italic !== null) _fontItalic = italic;

        return this;
    }


    public function align(new_align:String):TextFieldBuilder
    {
        _align = new_align;
        return this;
    }


    public function wordWrap(new_wordWrap:Boolean):TextFieldBuilder
    {
        _wordWrap = new_wordWrap;
        return this;
    }


    public function multiline(new_multiline:Boolean):TextFieldBuilder
    {
        _multiline = new_multiline;
        return this;
    }


    public function autoSize(new_autoSize:Boolean):TextFieldBuilder
    {
        _autoSize = new_autoSize;
        return this;
    }


    public function selectable(new_selectable:Boolean):TextFieldBuilder
    {
        _selectable = new_selectable;
        return this;
    }


    public function border(new_border:uint):TextFieldBuilder
    {
        _border = new_border;
        return this;
    }


    public function size(width:Number, height:Number):TextFieldBuilder
    {
        _width = width;
        _height = height;
        return this;
    }


    public function input(new_input:Boolean, maxChars:int = 0, restrict:String = null):TextFieldBuilder
    {
        _input = new_input;
        _maxChars = maxChars;
        _restrict = restrict;
        return this;
    }


    public function text(new_text:String):TextFieldBuilder
    {
        _text = new_text;
        return this;
    }


    public function create():TextField
    {
        var field:TextField = new TextField();

        var format:TextFormat = new TextFormat(_fontFamily, _fontSize,
            _fontColor, _fontBold, _fontItalic, null, null, null, _align);

        field.defaultTextFormat = format;
        field.setTextFormat(format);

        field.text = _text;

        field.wordWrap = _wordWrap;
        field.multiline = _multiline;
        field.selectable = _input || _selectable;

        if ((_border & 0xFF000000) == 0)
        {
            field.border = true;
            field.borderColor = _border & 0xFFFFFF;
        }
        else
        {
            field.border = false;
        }

        if (_input)
        {
            field.type = TextFieldType.INPUT;
            field.maxChars = _maxChars;
            field.restrict = _restrict;
        }
        else
        {
            field.type = TextFieldType.DYNAMIC;
        }

        if (_autoSize)
        {
            field.autoSize = getAutoSizeForAlign(_align);
        }
        else
        {
            field.autoSize = TextFieldAutoSize.NONE;
        }

        if (isFinite(_width) && (_multiline || !_autoSize))
        {
            field.width = _width;
        }

        if (isFinite(_height) && !_autoSize)
        {
            field.height = _height;
        }

        return field;
    }


    private static function getAutoSizeForAlign(align:String):String
    {
        switch (align)
        {
        case TextFormatAlign.CENTER :
        case TextFieldAutoSize.CENTER :
            return TextFieldAutoSize.CENTER;

        case TextFormatAlign.RIGHT :
        case TextFieldAutoSize.RIGHT :
            return TextFieldAutoSize.RIGHT;
        }
        return TextFieldAutoSize.LEFT;
    }
}
}
