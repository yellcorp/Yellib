package org.yellcorp.xml.validator.utils
{
public class Range
{
    public var min:Number;
    public var max:Number;

    public function Range(min:Number, max:Number)
    {
        this.min = min;
        this.max = max;
    }

    public function verify(query:Number):Boolean
    {
        return (query >= min) && (query <= max);
    }

    public function toString():String
    {
        return "{" + min + ", " + max + "}";
    }
}
}
