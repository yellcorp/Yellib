package org.yellcorp.lib.text
{
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextLineMetrics;


public class TextFieldBuilder
{
    // FIELD
    private var _alwaysShowSelection:Boolean = false;
    private var _antiAliasType:String = AntiAliasType.ADVANCED;
    private var _behavior:String = TextFieldBehavior.SINGLE_LINE_FIXED;
    private var _background:int = -1;
    private var _border:int = -1;
    private var _condenseWhite:Boolean = false;
    private var _password:Boolean = false;
    private var _embedFonts:Boolean = false;
    private var _gridFitType:String = GridFitType.SUBPIXEL;
    private var _maxChars:uint = 0;
    private var _mouseWheelEnabled:Boolean = true;
    private var _restrict:String = null;
    private var _selectable:Boolean = true;
    private var _sharpness:Number = 0;
    private var _styleSheet:StyleSheet;
    private var _text:String = null;
    private var _htmlText:String = null;
    private var _thickness:Number = 0;
    private var _acceptsInput:Boolean = false;
    private var _useRichTextClipboard:Boolean;

    private var _width:Number;
    private var _height:Number;

    // FORMAT
    private var _align:String = TextFormatAlign.LEFT;
    private var _blockIndent:Object;
    private var _bold:Boolean;
    private var _bullet:Boolean;
    private var _color:uint = 0x000000;
    private var _font:String = "_sans";
    private var _indent:int = 0;
    private var _italic:Boolean;
    private var _kerning:Boolean;
    private var _leading:Number = 0;
    private var _leftMargin:int = 0;
    private var _rightMargin:int = 0;
    private var _letterSpacing:Number = 0;
    private var _size:Number = 12;
    private var _tabStops:Array = null;

    // FIELD
    public function alwaysShowSelection(newAlwaysShowSelection:Boolean):TextFieldBuilder
    {
        _alwaysShowSelection = newAlwaysShowSelection;
        return this;
    }


    public function antiAliasType(newAntiAliasType:String):TextFieldBuilder
    {
        _antiAliasType = newAntiAliasType;
        return this;
    }


    public function behavior(newBehavior:String):TextFieldBuilder
    {
        _behavior = newBehavior;
        return this;
    }


    public function background(newBackground:int):TextFieldBuilder
    {
        _background = newBackground;
        return this;
    }


    public function border(newBorder:int):TextFieldBuilder
    {
        _border = newBorder;
        return this;
    }


    public function condenseWhite(newCondenseWhite:Boolean):TextFieldBuilder
    {
        _condenseWhite = newCondenseWhite;
        return this;
    }


    public function password(newPassword:Boolean):TextFieldBuilder
    {
        _password = newPassword;
        return this;
    }


    public function embedFonts(newEmbedFonts:Boolean):TextFieldBuilder
    {
        _embedFonts = newEmbedFonts;
        return this;
    }


    public function gridFitType(newGridFitType:String):TextFieldBuilder
    {
        _gridFitType = newGridFitType;
        return this;
    }


    public function maxChars(newMaxChars:uint):TextFieldBuilder
    {
        _maxChars = newMaxChars;
        return this;
    }


    public function mouseWheelEnabled(newMouseWheelEnabled:Boolean):TextFieldBuilder
    {
        _mouseWheelEnabled = newMouseWheelEnabled;
        return this;
    }


    public function restrict(newRestrict:String):TextFieldBuilder
    {
        _restrict = newRestrict;
        return this;
    }


    public function selectable(newSelectable:Boolean):TextFieldBuilder
    {
        _selectable = newSelectable;
        return this;
    }


    public function sharpness(newSharpness:Number):TextFieldBuilder
    {
        _sharpness = newSharpness;
        return this;
    }


    public function text(newText:String):TextFieldBuilder
    {
        _text = newText;
        _htmlText = null;
        return this;
    }


    public function htmlText(newHtmlText:String):TextFieldBuilder
    {
        _htmlText = newHtmlText;
        _text = null;
        return this;
    }


    public function thickness(newThickness:Number):TextFieldBuilder
    {
        _thickness = newThickness;
        return this;
    }


    public function acceptsInput(newIsInput:Boolean):TextFieldBuilder
    {
        _acceptsInput = newIsInput;
        return this;
    }


    public function useRichTextClipboard(newUseRichTextClipboard:Boolean):TextFieldBuilder
    {
        _useRichTextClipboard = newUseRichTextClipboard;
        return this;
    }


    public function width(newWidth:Number):TextFieldBuilder
    {
        _width = newWidth;
        return this;
    }


    public function height(newHeight:Number):TextFieldBuilder
    {
        _height = newHeight;
        return this;
    }


    public function size(newWidth:Number, newHeight:Number):TextFieldBuilder
    {
        _width = newWidth;
        _height = newHeight;
        return this;
    }


    // FORMAT
    public function align(newAlign:String):TextFieldBuilder
    {
        _align = newAlign;
        return this;
    }


    public function blockIndent(newBlockIndent:Object):TextFieldBuilder
    {
        _blockIndent = newBlockIndent;
        return this;
    }


    public function bold(newBold:Boolean):TextFieldBuilder
    {
        _bold = newBold;
        return this;
    }


    public function bullet(newBullet:Boolean):TextFieldBuilder
    {
        _bullet = newBullet;
        return this;
    }


    public function color(newColor:uint):TextFieldBuilder
    {
        _color = newColor;
        return this;
    }


    public function font(newFont:String):TextFieldBuilder
    {
        _font = newFont;
        return this;
    }


    public function indent(newIndent:int):TextFieldBuilder
    {
        _indent = newIndent;
        return this;
    }


    public function italic(newItalic:Boolean):TextFieldBuilder
    {
        _italic = newItalic;
        return this;
    }


    public function kerning(newKerning:Boolean):TextFieldBuilder
    {
        _kerning = newKerning;
        return this;
    }


    public function leading(newLeading:Number):TextFieldBuilder
    {
        _leading = newLeading;
        return this;
    }


    public function leftMargin(newLeftMargin:int):TextFieldBuilder
    {
        _leftMargin = newLeftMargin;
        return this;
    }


    public function rightMargin(newRightMargin:int):TextFieldBuilder
    {
        _rightMargin = newRightMargin;
        return this;
    }


    public function letterSpacing(newLetterSpacing:Number):TextFieldBuilder
    {
        _letterSpacing = newLetterSpacing;
        return this;
    }


    public function tabStops(newTabStops:Array):TextFieldBuilder
    {
        _tabStops = newTabStops;
        return this;
    }


    public function styleSheet(newStyleSheet:StyleSheet):TextFieldBuilder
    {
        _styleSheet = newStyleSheet;
        return this;
    }

    public function create():TextField
    {
        var field:TextField = new TextField();
        var format:TextFormat = createTextFormat();

        field.defaultTextFormat = format;

        field.type = _acceptsInput ? TextFieldType.INPUT
                                   : TextFieldType.DYNAMIC;

        if (_styleSheet)
            field.styleSheet = _styleSheet;

        switch (_behavior)
        {
        case TextFieldBehavior.SINGLE_LINE_FIXED:
        default:
            field.autoSize = TextFieldAutoSize.NONE;
            field.multiline = false;
            field.wordWrap = false;
            break;

        case TextFieldBehavior.SINGLE_LINE_AUTO_WIDTH:
            field.autoSize = getAutoSizeForAlign(_align);
            field.multiline = false;
            field.wordWrap = false;
            break;

        case TextFieldBehavior.MULTI_LINE_FIXED:
            field.autoSize = TextFieldAutoSize.NONE;
            field.multiline = true;
            field.wordWrap = false;
            break;

        case TextFieldBehavior.MULTI_LINE_WRAP_FIXED:
            field.autoSize = TextFieldAutoSize.NONE;
            field.multiline = true;
            field.wordWrap = true;
            break;

        case TextFieldBehavior.MULTI_LINE_AUTO_WIDTH:
            field.autoSize = getAutoSizeForAlign(_align);
            field.multiline = true;
            field.wordWrap = false;
            break;

        case TextFieldBehavior.MULTI_LINE_AUTO_HEIGHT:
            field.autoSize = getAutoSizeForAlign(_align);
            field.multiline = true;
            field.wordWrap = true;
            break;
        }

        field.alwaysShowSelection = _alwaysShowSelection;

        if (_border >= 0)
        {
            field.border = true;
            field.borderColor = _border;
        }
        else
        {
            field.border = false;
        }

        if (_background >= 0)
        {
            field.background = true;
            field.backgroundColor = _background;
        }
        else
        {
            field.background = false;
        }

        field.condenseWhite = _condenseWhite;
        field.displayAsPassword = _password;

        field.embedFonts = _embedFonts;
        field.antiAliasType = _antiAliasType;
        field.gridFitType = _gridFitType;
        field.sharpness = _sharpness;
        field.thickness = _thickness;

        field.maxChars = _maxChars;
        field.restrict = _restrict;

        field.selectable = _selectable || _acceptsInput;

        field.useRichTextClipboard = _useRichTextClipboard;
        field.mouseWheelEnabled = _mouseWheelEnabled;

        if (isFinite(_width))
            field.width = _width;

        if (isFinite(_height))
            field.height = _height;
        else
        {
            field.text = "M";
            var metrics:TextLineMetrics = field.getLineMetrics(0);
            field.height = metrics.ascent + metrics.descent + 4;
        }

        if (_htmlText !== null)
            field.htmlText = _htmlText;
        else if (_text !== null)
            field.text = _text;
        else
            field.text = "";

        return field;
    }


    private function createTextFormat():TextFormat
    {
        var tf:TextFormat = new TextFormat(_font, _size, _color, _bold,
                _italic, false, null, null, _align, _leftMargin,
                _rightMargin, _indent, _leading);

        tf.blockIndent = _blockIndent;
        tf.bullet = _bullet;
        tf.kerning = _kerning;
        tf.letterSpacing = _letterSpacing;

        if (_tabStops)
        {
            tf.tabStops = _tabStops;
        }
        return tf;
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
