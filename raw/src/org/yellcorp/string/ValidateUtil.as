package org.yellcorp.string
{
public class ValidateUtil
{
    public static function isEmail(email:String):Boolean
    {
        var atPos:int;
        var dotPos:int;

        if (!email || email.length < 5) return false;
        atPos = email.lastIndexOf("@");
        if (atPos <= 0 || atPos == email.length - 1) return false;
        dotPos = email.lastIndexOf(".");
        if (dotPos <= atPos + 1 || dotPos == email.length - 1) return false;
        return true;
    }
}
}
