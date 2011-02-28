package org.yellcorp.debug.debugutil
{
import org.yellcorp.format.template.Template;
import org.yellcorp.string.FormattingStringBuilder;
import org.yellcorp.string.StringUtil;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class ObjectDumper
{
    private var maxDepth:int;
    private var output:FormattingStringBuilder;

    private var maxDepthMessage:Template;
    private var propertyMessage:Template;

    public function ObjectDumper()
    {
        maxDepthMessage = new Template("{indent}[[Reached maximum depth of {maxDepth}]]\n");
        propertyMessage = new Template("{indent}{name}:{type}={value}\n");
    }

    public function dump(object:*, maxDepth:int = 3):String
    {
        this.maxDepth = maxDepth;

        output = new FormattingStringBuilder();
        recurse(object, 0);
        return output.toString();
    }

    private function recurse(object:*, currentDepth:int):void
    {
        var desc:XML;
        var node:XML;
        var evalList:XML;
        var dynamicProp:*;
        var dynamicType:String;
        var formatValues:Object = { };

        formatValues.indent = StringUtil.repeat(" ", currentDepth);

        desc = describeType(object);

        evalList = <eval />;
        evalList.appendChild(desc.variable);

        for (dynamicProp in object)
        {
            dynamicType = getQualifiedClassName(object[dynamicProp]);
            evalList.appendChild(<variable name={dynamicProp} type={dynamicType} isDynamic="true" />);
        }

        if (currentDepth >= maxDepth)
        {
            if (evalList.children().length() > 0)
            {
                output.appendFill(maxDepthMessage, {
                        indent: formatValues.indent,
                        maxDepth: maxDepth });
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
            formatValues.name = node.@name;
            formatValues.type = node.@type;
            formatValues.value = object[formatValues.name];

            output.appendFill(propertyMessage, formatValues);

            recurse(object[formatValues.name], currentDepth + 1);
        }
    }
}
}
