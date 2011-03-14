package org.yellcorp.lib.format.template.renderer
{
public class Literal implements Renderer
{
    private var string:String;

    public function Literal(string:String)
    {
        this.string = string;
    }

    public function render(fieldMap:*):*
    {
        return string;
    }

    public function toString():String
    {
        return '"' + string + '"';
    }
}
}
