package org.yellcorp.lib.serial.util
{
import org.yellcorp.lib.serial.enum.Intrinsics;


public class Reflector
{
    public static const VECTOR_TYPE_PATTERN:RegExp =
        /^__AS3__\.vec::Vector.<([A-Za-z$_:.][A-Za-z$_:.0-9<>]*)>$/ ;

    private var typeParameterCache:Object;

    public function Reflector()
    {
        typeParameterCache = { };
    }

    public function isVectorType(type:String):Boolean
    {
        return type == Intrinsics.ARRAY || VECTOR_TYPE_PATTERN.test(type);
    }

    public function getTypeParameter(type:String):String
    {
        var result:String = typeParameterCache[type];
        var match:Object;

        if (result)
        {
            return result;
        }
        else
        {
            match = VECTOR_TYPE_PATTERN.exec(type);
            if (match)
            {
                result = match[1];
            }
            else
            {
                result = "*";
            }
            typeParameterCache[type] = result;
            return result;
        }
    }

    public function isMapType(type:String):Boolean
    {
        // TODO: add support for flash.utils.Proxy
        return type == Intrinsics.OBJECT || type == Intrinsics.DICTIONARY;
    }
}
}
