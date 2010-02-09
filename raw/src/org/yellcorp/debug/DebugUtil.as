package org.yellcorp.debug
{
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

    public static function displayTree(container:DisplayObjectContainer, maxLevels:int):String
    {
        return _displayTree(container, container, maxLevels, 0);
    }

    private static function _displayTree(
        container:DisplayObjectContainer,
        reference:DisplayObjectContainer,
        maxLevels:int,
        thislevel:int):String
    {
        var i:int = 0;
        var len:int = container.numChildren;
        var current:DisplayObject;
        var numPad:int = len.toString().length;
        var str:String = "";

        for (i = 0;i < len; i++)
        {
            current = container.getChildAt(i);

            str += StringUtil.repeat(" ", thislevel) /* Child index */
                 + StringUtil.padRight(i.toString(), numPad) + " " /* Name */
                 + current.name + " " /* Class */
                 + describeType(current).@name.toString() + " " /* First native ancestor */
                 + "(" + searchTypeChain(current, "flash.") + ") " /* Registration point */
                 + "{" + [current.x, current.y].join(", ") + "} " /* Scale */
                 + "{" + [current.scaleX, current.scaleY].join(", ") + "} " /* Bounding rectangle */
                 + current.getRect(container).toString() + " " + "\n";

            if (current is DisplayObjectContainer)
            {
                str += _displayTree(current as DisplayObjectContainer, reference, maxLevels, thislevel + 1);
            }
        }

        return str;
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
        return _dumpObject(root, maxDepth, 0);
    }

    private static function _dumpObject(obj:*, maxDepth:int, currentDepth:int):String
    {
        var desc:XML;
        var node:XML;
        var evalList:XML;
        var dynamicProp:*;
        var dynamicType:String;
        var propName:String;
        var indent:String;
        var className:String;
        var output:String;

        indent = StringUtil.repeat(" ", currentDepth);

        output = "";
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
            if (evalList.children().length() > 0)
                return indent + "[[Reached maximum depth of " + maxDepth + "]]\n";
            else
                return "";

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
            output += indent + propName + ":" + node.@type + "=";
            output += obj[propName];

            output += "\n";
            output += _dumpObject(obj[propName], maxDepth, currentDepth+1);
        }

        return output;
    }
}
}
