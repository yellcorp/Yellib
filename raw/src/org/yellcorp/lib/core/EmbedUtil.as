package org.yellcorp.lib.core
{
import flash.utils.ByteArray;


public class EmbedUtil
{
    public static function bytesToString(embedClass:Class):String
    {
        var bytes:ByteArray = ByteArray(new embedClass());
        return bytes.readUTFBytes(bytes.bytesAvailable);
    }
}
}
