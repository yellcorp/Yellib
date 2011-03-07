package org.yellcorp.array
{
public class Sort
{
    public static function cmpString(a:String, b:String):int
    {
        return a.localeCompare(b);
    }

    public static function cmpStringNoCase(a:String, b:String):int
    {
        return a.toLocaleLowerCase().localeCompare(b.toLocaleLowerCase());
    }

    public static function cmpNumeric(a:Number, b:Number):int
    {
        if (a < b)
        {
            return -1;
        }
        else if (a > b)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    public static function cmpDate(a:Date, b:Date):int
    {
        if (a.time < b.time)
        {
            return -1;
        }
        else if (a.time > b.time)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}
}
