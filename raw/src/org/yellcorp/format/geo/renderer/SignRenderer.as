package org.yellcorp.format.geo.renderer
{
public class SignRenderer implements Renderer
{
    public var positive:String;
    public var negative:String;

    public function SignRenderer(positive:String, negative:String)
    {
        this.positive = positive;
        this.negative = negative;
    }

    public function render(degrees:Number):String
    {
        return degrees < 0 ? negative : positive;
    }
}
}
