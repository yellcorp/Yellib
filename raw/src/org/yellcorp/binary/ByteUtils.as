package org.yellcorp.binary
{
import flash.utils.ByteArray;


public class ByteUtils
{
    public static function cloneByteArray(source:ByteArray):ByteArray
    {
        var baClone:ByteArray;

        baClone = new ByteArray();
        baClone.writeBytes(source);
        baClone.position = 0;

        return baClone;
    }
}
}
