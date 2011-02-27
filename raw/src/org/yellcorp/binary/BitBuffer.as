package org.yellcorp.binary
{
import flash.utils.ByteArray;


public class BitBuffer
{
    private var _byteArray:ByteArray;

    private var currentByte:int;
    private var bitsLeft:int;

    public function BitBuffer(byteArray:ByteArray)
    {
        _byteArray = byteArray;
        bitsLeft = 0;
    }

    public function get length():uint
    {
        return _byteArray.length << 3;
    }

    public function get position():uint
    {
        return (_byteArray.position << 3) - bitsLeft;
    }

    public function get bitsAvailable():uint
    {
        return length - position;
    }

    public function set position(bitNumber:uint):void
    {
        var byteNum:uint = bitNumber >> 3;
        var bitNum:uint = bitNumber & 7;

        _byteArray.position = byteNum;

        if (bitNum > 0)
        {
            currentByte = _byteArray.readUnsignedByte();
            bitsLeft = 8 - bitNum;
        }
    }

    public function get byteArray():ByteArray
    {
        return _byteArray;
    }

    public function getBits(target:ByteArray, bitCount:uint):void
    {
        while (bitCount > 32)
        {
            target.writeUnsignedInt(getUint(32));
            bitCount -= 32;
        }
        if (bitCount > 16)
        {
            target.writeShort(getUint(16));
            bitCount -= 16;
        }
        if (bitCount > 8)
        {
            target.writeByte(getUint(8));
            bitCount -= 8;
        }
        if (bitCount > 0)
        {
            target.writeByte(getUint(bitCount));
        }
    }

    /**
     * @param bitCount Valid range 1-32. Not range checked.
     */
    public function getUint(bitCount:uint):uint
    {
        var output:uint = 0;
        var mask:uint;

        while (bitCount > 0)
        {
            if (bitsLeft == 0)
            {
                currentByte = _byteArray.readUnsignedByte();
                bitsLeft = 8;
            }

            if (bitCount >= bitsLeft)
            {
                output <<= bitsLeft;
                output |= currentByte;
                bitCount -= bitsLeft;
                bitsLeft = 0;
            }
            else
            {
                output <<= bitCount;
                mask = (1 << bitCount) - 1;
                output |= currentByte & mask;
                currentByte >>= bitCount;
                bitsLeft -= bitCount;
                bitCount = 0;
            }
        }

        return output;
    }
}
}
