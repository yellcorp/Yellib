package org.yellcorp.lib.validation.json
{
import org.yellcorp.lib.core.MapUtil;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class JSONValidator
{
    public var allowExtra:Boolean;

    private var stack:Array;

    public function JSONValidator(allowExtra:Boolean = false)
    {
        this.allowExtra = allowExtra;
    }

    public function validate(value:*, schema:*):void
    {
        stack = [ ];
        try {
            validateValue(value, schema);
        }
        catch (jve:JSONValidationError)
        {
            if (stack.length > 0)
            {
                jve.message = "For property " + stack.join(".") + ": " + jve.message;
            }
            throw jve;
        }
    }

    private function validateValue(value:*, schema:*):void
    {
        // if schema is null, then the caller is just checking for value
        // presence. do nothing
        if (!schema)
        {
            return;
        }

        if (value === undefined || value === null)
        {
            throw new JSONValidationError("Value is " + voidValueToString(value));
        }

        if (schema is Class)
        {
            if (!valueIsCompatibleType(value, schema))
            {
                throw new JSONValidationError("Incorrect type. " +
                    "Expected " + getQualifiedClassName(schema) + ", " +
                    "got " + getQualifiedClassName(value));
            }
        }
        else if (schema is Array)
        {
            validateArray(value, schema[0]);
        }
        else if (!MapUtil.isEmpty(schema))
        {
            validateObject(value, schema);
        }
    }

    private function validateArray(value:*, schema:*):void
    {
        if (!value.hasOwnProperty('length'))
        {
            throw new JSONValidationError("No length property found where expecting array");
        }
        var arrayLen:Number = Number(value.length);
        if (!isFinite(arrayLen) || arrayLen < 0)
        {
            throw new JSONValidationError("Invalid value for length property: " + voidValueToString(arrayLen));
        }
        for (var i:Number = 0; i < arrayLen; i++)
        {
            stack.push("[" + i + "]");
            validateValue(value[i], schema);
            stack.pop();
        }
    }

    private function validateObject(value:*, schema:*):void
    {
        var k:String;

        for (k in schema)
        {
            if (value.hasOwnProperty(k))
            {
                stack.push(k);
                validateValue(value[k], schema[k]);
                stack.pop();
            }
            else
            {
                throw new JSONValidationError("Missing property: " + k);
            }
        }

        if (!allowExtra)
        {
            for (k in value)
            {
                if (!schema.hasOwnProperty(k))
                {
                    throw new JSONValidationError("Superfluous property: " + k);
                }
            }
        }
    }

    private static function voidValueToString(value:*):String
    {
        if (value === undefined)
        {
            return "undefined";
        }
        else if (value === null)
        {
            return "null";
        }
        else
        {
            return String(value);
        }
    }

    private static function valueIsCompatibleType(value:*, clazz:Class):Boolean
    {
        var valueClassName:String = getQualifiedClassName(value);
        var factory:XMLList = describeType(clazz).factory;

        if (valueClassName == factory.@type)
        {
            return true;
        }
        else
        {
            return factory.extendsClass.(@type == valueClassName).length() > 0;
        }
    }
}
}
