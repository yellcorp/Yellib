package org.yellcorp.lib.format.geo
{
import org.yellcorp.lib.format.geo.renderer.Literal;
import org.yellcorp.lib.format.geo.renderer.NumberRenderer;
import org.yellcorp.lib.format.geo.renderer.SignRenderer;


internal class GeoParser2
{
    private var _text:String;
    private var ch:int;
    private var len:int;

    private var fieldProperties:GeoFieldProperties;
    private var renderers:Array;
    private var numBuffer:int;

    public function GeoParser2()
    {
    }

    public function parse(text:String):Array
    {
        var lastch:int;

        _text = text;
        ch = 0;
        len = _text.length;

        renderers = [ ];

        while (ch < len)
        {
            lastch = ch;
            ch = _text.indexOf('%', ch);

            if (ch == -1) ch = len;
            if (ch != lastch)
            {
                renderers.push(new Literal(_text.substring(lastch, ch)));
            }

            if (ch >= len) break;

            parseField();
        }
        return renderers;
    }

    private function parseField():void
    {
        fieldProperties = new GeoFieldProperties();
        ch++; // skip %
        var chr:int = _text.charCodeAt(ch++);

        if (chr == 48)
            fieldProperties.zeroPad = true;

        numBuffer = 0;
        while (chr >= 48 && chr <= 57)
        {
            numBuffer = numBuffer * 10 + chr - 48;
            chr = _text.charCodeAt(ch++);
        }

        fieldProperties.minWidth = numBuffer;
        numBuffer = 0;

        if (chr == 46) // '.'
        {
            chr = _text.charCodeAt(ch++);
            while (chr >= 48 && chr <= 57)
            {
                numBuffer = numBuffer * 10 + chr - 48;
                chr = _text.charCodeAt(ch++);
            }
            fieldProperties.precision = numBuffer;
            numBuffer = 0;
        }

        renderers.push(createField(chr));
    }

    private function createField(chr:int):*
    {
        switch (chr)
        {
        case 100: // d
            return new NumberRenderer(fieldProperties, 1, 0, true);
        case 109: // m
            return new NumberRenderer(fieldProperties, 60, 60, true);
        case 115: // s
            return new NumberRenderer(fieldProperties, 3600, 60, false);
        case 45: // -
            return new SignRenderer("", "-");
        case 43: // +
            return new SignRenderer("+", "-");
        case 111: // o
            return new SignRenderer("e", "w");
        case 79:  // O
            return new SignRenderer("E", "W");
        case 97:  // a
            return new SignRenderer("n", "s");
        case 65:  // A
            return new SignRenderer("N", "S");
        case 42:  // *
            return new Literal(String.fromCharCode(0x00B0));
        case 39:  // '
            chr = _text.charCodeAt(ch++);
            if (chr == 39)
            {
                return new Literal(String.fromCharCode(0x2033));
            }
            else
            {
                ch--;
                return new Literal(String.fromCharCode(0x2032));
            }
        case 37:  // %
            return new Literal("%");
        }
    }
}
}
