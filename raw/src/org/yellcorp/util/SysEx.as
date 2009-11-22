package org.yellcorp.util
{
import flash.utils.ByteArray;
import flash.utils.getTimer;


public class SysEx
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
        //trace('msec: ' + (msec));
        buffer.writeInt(runningTime);
        //trace('runningTime: ' + (runningTime));
        buffer.writeDouble(rnd);
        //trace('rnd: ' + (rnd));

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
