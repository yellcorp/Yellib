package org.yellcorp.binary {
import flash.utils.ByteArray;


public class Base64 {
    private static const BASE_64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    public static function encode(bin:ByteArray):String {
        var buffer:uint;

        var char1:int;
        var char2:int;
        var char3:int;
        var char4:int;

        var outStr:String = "";

        var i:uint;
        var pad:uint = 0;

        bin.position = 0;

        while (bin.bytesAvailable > 0) {
            buffer = 0;
            i = 0;
            while (i++ < 3) {
                if (bin.bytesAvailable > 0) {
                    buffer |= bin.readUnsignedByte();
                } else {
                    pad++;
                }
                if (i < 3) buffer <<= 8;
            }

            char1 = (buffer >> 18) & 0x3F;
            char2 = (buffer >> 12) & 0x3F;
            char3 = (buffer >>  6) & 0x3F;
            char4 =  buffer        & 0x3F;

            switch (pad) {
                case 2 :
                    char3 = 64;
                    // fall-through
                case 1 :
                    char4 = 64;
                    break;
                case 0 :
                    break;
                default :
                    trace("Base64.encode: WARNING: Abnormal overflow: " + pad);
                    break;
            }

            outStr += BASE_64_CHARS.charAt(char1) + BASE_64_CHARS.charAt(char2) +
                      BASE_64_CHARS.charAt(char3) + BASE_64_CHARS.charAt(char4);
        }

        return outStr;
    }

    public static function decode(str:String):ByteArray {
        var outBin:ByteArray = new ByteArray();
        var byteCount:int;
        var strLen:uint;
        var strPtr:uint;
        var pad:uint;
        var i:uint;

        var buffer:uint;
        var charVal:uint;

        if (str.charAt(str.length - 2) == "=") {
            pad = 2;
        } else if (str.charAt(str.length - 1) == "=") {
            pad = 1;
        }

        strLen = str.length;
        byteCount = strLen * .75 - pad;

        strPtr = 0;

        try {
            while (strPtr < strLen) {
                buffer = 0;
                i = 0;
                while (i < 4) {
                    charVal = charToVal(str.charCodeAt(strPtr + i));

                    buffer |= charVal;
                    if (i < 3) buffer <<= 6;
                    i++;
                }
                strPtr += 4;

                // the ByteArray.writeByte doc says only the lowest 8 bits
                // are written, so don't have to mask with & 0xFF?
                if (byteCount-- > 0) outBin.writeByte(buffer >> 16);
                if (byteCount-- > 0) outBin.writeByte(buffer >> 8);
                if (byteCount-- > 0) outBin.writeByte(buffer);
            }
        } catch (e:RangeError) {
            // catch the error from decoder, append
            // position number, and re-throw
            throw new RangeError(e.message + " position=" + strPtr);
        }

        if (byteCount > 0) {
            trace("Base64.decode: WARNING: Early end of string.  Remaining byte count = " + byteCount);
        }

        outBin.position = 0;
        return outBin;
    }

    public static function encodeUint(value:uint):String {
        var str:String = "";
        do {
            str += BASE_64_CHARS.charAt(value & 0x3F);
        } while (value >>= 6);
        return str;
    }

    public static function decodeUint(encoded:String):uint {
        var i:uint;
        var num:uint = 0;

        for (i=0; i<encoded.length; i++) {
            if (num >= 0x4000000) {
                throw new RangeError("uint overflow");
            }
            num <<= 6;
            num |= charToVal(encoded.charCodeAt(i));
        }
        return num;
    }

    public static function encodeInt(value:int):String {
        return encodeUint(uint(value));
    }

    public static function decodeInt(encoded:String):int {
        return int(decodeUint(encoded));
    }

    private static function charToVal(charCode:uint):uint {
        if (charCode >= 0x41 && charCode <= 0x5A) {    // 'A' to 'Z'
            return charCode - 0x41;
        } else if (charCode >= 0x61 && charCode <= 0x7A) {    // 'a' to 'z'
            return charCode - 0x47;
        } else if (charCode >= 0x30 && charCode <= 0x39) {    // '0' to '9'
            return charCode + 0x04;
        } else if (charCode == 0x2B) {    // '+'
            return 0x3E;
        } else if (charCode == 0x2F) {    // '/'
            return 0x3F;
        } else if (charCode != 0x3D) {    // '='
            throw new RangeError("Non-Base64 character encountered: code=" + charCode + " char="+String.fromCharCode(charCode));
        }
        return charCode;
    }
}
}
