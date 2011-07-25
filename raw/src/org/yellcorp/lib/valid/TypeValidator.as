package org.yellcorp.lib.valid
{
import org.yellcorp.lib.core.StringUtil;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class TypeValidator
{
    public var coercionPolicy:String = COERCE_STRINGS_ONLY;

    public static const COERCE_NONE:String = "COERCE_NONE";
    public static const COERCE_NATIVE:String = "COERCE_NATIVE";
    public static const COERCE_STRINGS_ONLY:String = "COERCE_STRINGS_ONLY";

    // getQualifiedClassName returns this for undefined
    public static const TYPE_VOID:String = "void";

    public static const TYPE_STRING:String = "String";
    public static const TYPE_NUMBER:String = "Number";
    public static const TYPE_UINT:String = "uint";
    public static const TYPE_INT:String = "int";
    public static const TYPE_BOOLEAN:String = "Boolean";
    public static const TYPE_NULL:String = "null";

    private static const NULL_SOURCE:ValueSource = new NullSource();

    private static var stringBooleanMap:Object = { '1'      : true, '0'       : false,
                                                   't'      : true, 'f'       : false,
                                                   'true'   : true, 'false'   : false,
                                                   'y'      : true, 'n'       : false,
                                                   'yes'    : true, 'no'      : false,
                                                   'on'     : true, 'off'     : false,
                                                   'enabled': true, 'disabled': false };

    private static var decimalRegex:RegExp = /^[-+]?[0-9]*(\.[0-9]*)?(e[-+]?[0-9]+)?$/i;

    public function copy(source:ValueSource, target:*, defaultSource:ValueSource = null):void
    {
        var desc:XML;
        var member:XML;

        var copied:Boolean;

        if (!defaultSource)
        {
            defaultSource = NULL_SOURCE;
        }

        desc = describeType(target);

        for each (member in desc.*.(localName() == 'variable' ||
                                    (localName() == 'accessor' && @access == 'readwrite')))
        {
            copied = copyKey(source, target, member.@name, member.@type);
            if (!copied)
            {
                copyKey(defaultSource, target, member.@name, member.@type);
            }
        }
    }

    private function copyKey(source:ValueSource,
                             target:*,
                             key:String,
                             targetType:String):Boolean
    {
        var sourceVal:*;
        var sourceType:String;

        sourceVal = source.getValue(key);
        sourceType = getQualifiedClassName(sourceVal);

        if (isAbsentType(sourceType))
        {
            return false;
        }

        // special case for numbers: coerce any number
        // type into any other, if it can be done losslessly,
        // even if COERCE_NONE
        if (sourceType === targetType || canNumericLosslessCast(sourceVal, sourceType, targetType))
        {
            target[key] = sourceVal;
            return true;
        }

        switch (coercionPolicy)
        {
        case COERCE_STRINGS_ONLY :
            if (sourceType == TYPE_STRING)
            {
                return copyKeyParse(sourceVal, target, key, targetType);
            }
            else
            {
                return false;
            }
            break;

        case COERCE_NATIVE :
            return copyKeyNative(sourceVal, target, key, targetType);
            break;

        case COERCE_NONE :
        default :
            return false;
            break;
        }
    }

    private function copyKeyNative(sourceVal:*, target:*, key:String, targetType:String):Boolean
    {
        try {
            switch (targetType)
            {
            case TYPE_STRING :
                target[key] = String(sourceVal);
                break;

            case TYPE_NUMBER :
                target[key] = Number(sourceVal);
                break;

            case TYPE_INT :
                target[key] = int(sourceVal);
                break;

            case TYPE_UINT :
                target[key] = uint(sourceVal);
                break;

            case TYPE_BOOLEAN :
                target[key] = Boolean(sourceVal);
                break;

            default :
                target[key] = sourceVal;
                break;
            }
        }
        catch (err:TypeError)
        {
            return false;
        }
        return true;
    }

    private function copyKeyParse(sourceVal:*, target:*, key:String, targetType:String):Boolean
    {
        var sourceStr:String = StringUtil.trim(String(sourceVal));

        switch (targetType)
        {
        case TYPE_STRING :
            // this shouldn't happen but here it is anyway
            target[key] = sourceStr;
            return true;
            break;

        case TYPE_NUMBER :
        case TYPE_INT :
        case TYPE_UINT :
            return copyKeyParseNumber(sourceStr, target, key, targetType);
            break;

        case TYPE_BOOLEAN :
            sourceStr = sourceStr.toLowerCase();
            if (stringBooleanMap.hasOwnProperty(sourceStr))
            {
                target[key] = stringBooleanMap[sourceStr];
                return true;
            }
            else
            {
                return false;
            }
            break;

        default :
            return false;
            break;
        }
    }

    private function copyKeyParseNumber(sourceStr:String, target:*, key:String, targetType:String):Boolean
    {
        var numVal:Number;

        if (decimalRegex.test(sourceStr))
        {
            numVal = parseFloat(sourceStr);
            if (canNumericLosslessCast(numVal, TYPE_NUMBER, targetType))
            {
                target[key] = sourceStr;
                return true;
            }
        }
        return false;
    }

    private function canNumericLosslessCast(value:*, fromType:String, toType:String):Boolean
    {
        if (isNumericType(fromType) && isNumericType(toType))
        {
            switch (toType)
            {
            case TYPE_NUMBER :
                return value === Number(value);

            case TYPE_UINT :
                return value === uint(value);

            case TYPE_INT :
                return value === int(value);

            default :
                throw new ArgumentError("unsupported argument for numericType");
            }
        }
        else
        {
            return false;
        }
    }

    private function isNumericType(type:String):Boolean
    {
        return type == TYPE_NUMBER || type == TYPE_INT || type == TYPE_UINT;
    }

    private function isAbsentType(type:String):Boolean
    {
        return type == TYPE_VOID || type == TYPE_NULL;
    }
}
}
