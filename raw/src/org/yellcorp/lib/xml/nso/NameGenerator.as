package org.yellcorp.lib.xml.nso
{
public class NameGenerator
{
    private static var chars:String = "abcdefghijklmnopqrstuvwxyz0123456789";
    private static var initials:int = 26;

    private var digits:Array;

    public function NameGenerator()
    {
        reset();
    }

    public function reset():void
    {
        digits = [ 0 ];
    }

    public function getNextName():String
    {
        var name:String = digitsToName();
        increment();
        return name;
    }

    private function digitsToName():String
    {
        return digits.map(
            function (n:int, i:int, a:Array):String
            {
                return chars.charAt(n);
            }
        ).join("");
    }

    private function increment():void
    {
        var i:int;
        var carry:Boolean;
        for (i = digits.length - 1; i >= 0; i--)
        {
            digits[i]++;
            if (digits[i] < (i == 0 ? initials : chars.length))
            {
                carry = false;
                break;
            }
            else
            {
                carry = true;
                digits[i] = 0;
            }
        }
        if (carry) digits.unshift(0);
    }
}
}
