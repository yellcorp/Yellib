package org.yellcorp.lib.binary
{
import flash.utils.ByteArray;
import flash.utils.IDataInput;


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

    public static function bytesToXML(buffer:IDataInput):XML
    // throws EOFError, TypeError
    {
        var str:String;
        var xml:XML;

        str = buffer.readUTFBytes(buffer.bytesAvailable);
        xml = XML(str);

        return xml;
    }
}
}
