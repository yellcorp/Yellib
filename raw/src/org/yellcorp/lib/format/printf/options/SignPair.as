package org.yellcorp.lib.format.printf.options
{
public class SignPair
{
    public var lead:String = "";
    public var trail:String = "";

    public function SignPair(lead:String, trail:String)
    {
        this.lead = lead;
        this.trail = trail;
    }

    public function setSigns(lead:String, trail:String):void
    {
        this.lead = lead;
        this.trail = trail;
    }

    public function clone():SignPair
    {
        return new SignPair(lead, trail);
    }
}
}
