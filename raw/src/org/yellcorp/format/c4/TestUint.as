package org.yellcorp.format.c4
{
import org.yellcorp.debug.DebugUtil;

import flash.display.Sprite;
import flash.utils.ByteArray;
import flash.utils.Endian;


public class TestUint extends Sprite
{
    public function TestUint()
    {
        for (var pow:int = -6; pow <= 6; pow++)
        {
            trace("pow=" + pow);
            var num:Number = Math.pow(10, pow);
            trace("  toString          " + num.toString());
            trace("  toExponential(4)  " + num.toExponential(4));
            trace("  toFixed(4)        " + num.toFixed(4));
            trace("  toPrecision(4)    " + num.toPrecision(4));
        }

        var bytes:ByteArray = new ByteArray();
        bytes.endian = Endian.BIG_ENDIAN;
        bytes.writeDouble(1);
        trace(DebugUtil.dumpByteArray(bytes));
    }
}
}
