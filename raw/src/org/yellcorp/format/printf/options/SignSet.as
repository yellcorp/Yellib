package org.yellcorp.format.printf.options
{
public class SignSet
{
    public var positive:SignPair;
    public var negative:SignPair;

    public function SignSet(
        positiveLead:String = "", positiveTrail:String = "",
        negativeLead:String = "-", negativeTrail:String = "")
    {
        positive = new SignPair(positiveLead, positiveTrail);
        negative = new SignPair(negativeLead, negativeTrail);
    }

    public function getPair(requestNegative:Boolean):SignPair
    {
        return requestNegative ? negative : positive;
    }

    public function clone():SignSet
    {
        return new SignSet(positive.lead, positive.trail,
            negative.lead, negative.trail);
    }
}
}
