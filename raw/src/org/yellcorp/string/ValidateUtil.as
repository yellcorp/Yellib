package org.yellcorp.string
{
public class ValidateUtil
{
    public static function isEmail(email:String):Boolean
    {
        var atPos:int;
        var dotPos:int;

        // shortest possible email is a@b.c -- 5 chars
        // who knows, maybe they'll invent one-letter TLDs
        if (!email || email.length < 5)
        {
            return false;
        }

        atPos = email.lastIndexOf("@");
        // check @ exists, and is neither the first or last character
        if (atPos <= 0 || atPos == email.length - 1)
        {
            return false;
        }

        dotPos = email.lastIndexOf(".");
        // check . exists, and that the last occurrence of . is neither
        // the last character, nor before the @
        if (dotPos <= atPos + 1 || dotPos == email.length - 1)
        {
            return false;
        }

        // no further checks -- better to be permissive rather than
        // overly restrictive.  a wide range of characters are
        // actually permitted before the @, including extra @s

        // here's a popular post on the subject
        // http://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx

        // here's a popular regex on the subject
        // http://cpansearch.perl.org/src/MAURICE/Email-Valid-0.14/Valid.pm

        return true;
    }
}
}
