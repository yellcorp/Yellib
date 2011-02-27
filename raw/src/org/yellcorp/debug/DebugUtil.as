package org.yellcorp.debug
{
import org.yellcorp.format.Template;
import org.yellcorp.string.StringUtil;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class DebugUtil
{
    /**
     * This utilises a horrible hack to force a stack trace
     * into an array of strings
     */
    public static function stackTrace():Array
    {
        var traceString:String;
        var calls:Array;
        var i:int;

        try
        {
            throw new Error();
        } catch (e:Error)
        {
            traceString = e.getStackTrace();
        }

        if (!traceString) return [];

        calls = traceString.split(/\n\s+/);

        // remove the first two because it will be the deliberate
        // error + this method
        calls.splice(0, 2);

        for (i = 0;i < calls.length; i++)
        {
            // remove "at "
            calls[i] = calls[i].substr(3);
        }

        return calls;
    }

    public static function dumpDisplayTree(container:DisplayObjectContainer, maxDepth:int = 0):String
    {
        var lineBuffer:Array = [ ];
        _dumpDisplayTree(container, container, maxDepth, 0, lineBuffer);
        return lineBuffer.join("\n");
    }

    private static function _dumpDisplayTree(
        container:DisplayObjectContainer,
        reference:DisplayObjectContainer,
        maxDepth:int,
        currentDepth:int,
        outLineBuffer:Array):void
    {
        var i:int = 0;
        var len:int = container.numChildren;
        var current:DisplayObject;
        var numPad:int = len.toString().length;

        var formatValues:Object = { };

        formatValues.indent = StringUtil.repeat(" ", currentDepth);

        if (maxDepth > 0 && currentDepth > maxDepth)
        {
            outLineBuffer.push(formatValues.indent + "[[Reached maximum depth of " + maxDepth + "]]");
            return;
        }
        else
        {
            for (i = 0;i < len; i++)
            {
                current = container.getChildAt(i);

                formatValues.index = StringUtil.padRight(i.toString(), numPad);
                formatValues.name = current.name;

                formatValues['class'] = getQualifiedClassName(current);
                formatValues.nativeClass = searchTypeChain(current, "flash.");

                formatValues.x = current.x;
                formatValues.y = current.y;

                formatValues.scaleX = current.scaleX;
                formatValues.scaleY = current.scaleY;

                formatValues.rect = current.getRect(container);

                outLineBuffer.push(Template.format("{indent}{index} name:\"{name}\" class:{class}({nativeClass}) pos:({x}, {y}) scale:({scaleX}, {scaleY}) rect:{rect}",
                        formatValues));

                if (current is DisplayObjectContainer)
                {
                    _dumpDisplayTree(current as DisplayObjectContainer, reference, maxDepth, currentDepth + 1, outLineBuffer);
                }
            }
        }
    }

    private static function searchTypeChain(query:Object, prefix:String):String
    {
        var supers:XMLList = describeType(query).extendsClass.(StringUtil.startsWith(@type, prefix));

        if (supers.length == 0)
        {
            return "";
        }
        else
        {
            return supers[0].@type;
        }
    }

    public static function dumpObject(root:*, maxDepth:int = 3):String
    {
        var lineBuffer:Array = [ ];
        _dumpObject(root, maxDepth, 0, lineBuffer);
        return lineBuffer.join("\n");
    }

    private static function _dumpObject(obj:*, maxDepth:int, currentDepth:int, outLineBuffer:Array):void
    {
        var desc:XML;
        var node:XML;
        var evalList:XML;
        var dynamicProp:*;
        var dynamicType:String;
        var propName:String;
        var indent:String;
        var className:String;

        indent = StringUtil.repeat(" ", currentDepth);

        desc = describeType(obj);
        className = desc.@name;

        evalList = <eval />;
        evalList.appendChild(desc.variable);

        for (dynamicProp in obj)
        {
            dynamicType = getQualifiedClassName(obj[dynamicProp]);
            evalList.appendChild(<variable name={dynamicProp} type={dynamicType} isDynamic="true" />);
        }

        if (currentDepth >= maxDepth)
        {
            if (evalList.children().length() > 0)
            {
                outLineBuffer.push(indent + "[[Reached maximum depth of " + maxDepth + "]]");
            }
            return;
        }

        // no good: if late property evaluation, i.e. name[prop] invokes a getter that
        // throws an exception, try/catch won't actually catch it.  this is likely the
        // same problem that says you shouldn't throw in flash.utils.Proxy subclasses

        /*
        if (optEvalGetters)
            evalList.appendChild(desc.accessor.(@access=="readonly" || @access=="readwrite"));
             */

        // avm doesn't set up error handling for [] operator i guess?

        for each (node in evalList.*)
        {
            propName = node.@name;
            outLineBuffer.push(
                    indent + propName + ":" + node.@type + "=" + obj[propName]);

            _dumpObject(obj[propName], maxDepth, currentDepth + 1, outLineBuffer);
        }
    }
}
}
