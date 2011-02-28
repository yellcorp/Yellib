package org.yellcorp.debug.debugutil
{
import org.yellcorp.format.template.Template;
import org.yellcorp.string.FormattingStringBuilder;
import org.yellcorp.string.StringUtil;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class DisplayTreeDumper
{
    private var maxDepth:int;

    private var reference:DisplayObjectContainer;

    private var maxDepthMessage:Template;
    private var propertyMessage:Template;

    private var output:FormattingStringBuilder;

    public function DisplayTreeDumper()
    {
        maxDepthMessage = new Template("{index}[[Reached maximum depth of {maxDepth}]]\n");
        propertyMessage = new Template("{indent}{index} name:\"{name}\" " +
                "class:{class}({nativeClass}) " +
                "pos:({x}, {y}) " +
                "scale:({scaleX}, {scaleY}) " +
                "rect:{rect}\n");
    }

    public function dump(container:DisplayObjectContainer, maxDepth:int = 0):String
    {
        this.maxDepth = maxDepth;

        reference = container;
        output = new FormattingStringBuilder();

        recurse(container, 0);

        return output.toString();
    }

    private function recurse(container:DisplayObjectContainer, currentDepth:int):void
    {
        var i:int = 0;
        var len:int = container.numChildren;
        var current:DisplayObject;
        var numPad:int = len.toString().length;

        var formatValues:Object = {};

        formatValues.indent = StringUtil.repeat(" ", currentDepth);

        if (maxDepth > 0 && currentDepth > maxDepth)
        {
            output.appendFill(maxDepthMessage, {
                    maxDepth:maxDepth,
                    indent:formatValues.indent });
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

                output.appendFill(propertyMessage, formatValues);

                if (current is DisplayObjectContainer)
                {
                    recurse(current as DisplayObjectContainer, currentDepth + 1);
                }
            }
        }
    }

    private static function searchTypeChain(query:Object, prefix:String):String
    {
        var supers:XMLList = describeType(query).extendsClass.(
                StringUtil.startsWith(@type, prefix));

        if (supers.length == 0)
        {
            return "";
        }
        else
        {
            return supers[0].@type;
        }
    }
}
}
