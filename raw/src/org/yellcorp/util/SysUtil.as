package org.yellcorp.util
{
import flash.utils.ByteArray;
import flash.utils.getTimer;


public class SysUtil
{
    public static function getGUID():String
    {
        var buffer:ByteArray = new ByteArray();
        var byte:uint;
        var outString:String = "";

        var runningTime:int = getTimer();
        var msec:Number = (new Date()).time;
        var rnd:Number = Math.random();

        buffer.writeDouble(msec);
        buffer.writeInt(runningTime);
        buffer.writeDouble(rnd);

        buffer.position = 0;

        while (buffer.bytesAvailable > 0)
        {
            byte = buffer.readUnsignedByte();
            if (byte < 0x10) outString += "0";
            outString += byte.toString(16);
        }

        return outString;
    }
}
}
