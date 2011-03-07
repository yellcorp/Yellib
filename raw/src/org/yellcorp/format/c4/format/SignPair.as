package org.yellcorp.format.c4.format
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

    public function clone():SignPair
    {
        return new SignPair(lead, trail);
    }
}
}
