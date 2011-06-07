package org.yellcorp.lib.serial.source.xml
{
import org.yellcorp.lib.serial.error.SourceError;


public class XMLSourceUtil
{
    public static function assertSingle(list:XMLList, expr:String):*
    {
        if (list.length() != 1)
        {
            throw new SourceError(
                "Wrong number of values defined for expression [" + expr +
                "] (found " + list.length() +")");
        }
        return list[0];
    }
}
}
