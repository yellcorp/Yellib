package test.yellcorp.lib.binary
{
import asunit.framework.TestCase;

import org.yellcorp.lib.binary.Base64;

import flash.utils.ByteArray;


public class Base64Test extends TestCase
{
    public function Base64Test(testMethod:String = null)
    {
        super(testMethod);
    }

    public function testIt():void
    {
        var text:String = "Man is distinguished, not only by his " +
        "reason, but by this singular passion from other animals, which " +
        "is a lust of the mind, that by a perseverance of delight in " +
        "the continued and indefatigable generation of knowledge, " +
        "exceeds the short vehemence of any carnal pleasure.";

        var code:String = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5I" +
        "GhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBv" +
        "dGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQ" +
        "gYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIG" +
        "FuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZ" +
        "WRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=";

        var textBytes:ByteArray = new ByteArray();
        textBytes.writeUTFBytes(text);

        assertEquals(code, Base64.encode(textBytes));


        var decoded:ByteArray = Base64.decode(code);
        decoded.position = 0;
        assertEquals(text, decoded.readUTFBytes(decoded.bytesAvailable));


        code = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5I" +
        "GhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBv" +
        "dGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQ" +
        "gYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIG" +
        "FuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZ" +
        "WRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4";

        assertEquals(code, Base64.encode(textBytes, false));
    }
}
}
