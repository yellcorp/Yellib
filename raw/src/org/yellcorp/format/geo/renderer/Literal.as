package org.yellcorp.format.geo.renderer
{
public class Literal implements Renderer
{
    private var _text:String;

    public function Literal(text:String)
    {
        _text = text;
    }

    public function render(degrees:Number):String
    {
        return _text;
    }
}
}
