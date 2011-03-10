package org.yellcorp.debug.debugutil
{
import org.yellcorp.debug.DebugUtil;
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
    private var propertyErrorMessage:Template;

    public function ObjectDumper()
    {
        maxDepthMessage = new Template("{indent}[[Reached maximum depth of {maxDepth}]]\n");
        propertyMessage = new Template("{indent}{name}:{type}={value}\n");
        propertyErrorMessage = new Template("{indent}{name}:{type} [[{errorType}: {error.message}]]\n");
    }

    public function dump(object:*, maxDepth:int = 3, evaluateGetters:Boolean = false):String
    {
        this.maxDepth = maxDepth;

        output = new FormattingStringBuilder();
        recurse(object, 0, evaluateGetters);
        return output.toString();
    }

    private function recurse(object:*, currentDepth:int, evaluateGetters:Boolean):void
    {
        var desc:XML;
        var node:XML;
        var evalList:XML;
        var dynamicProp:*;
        var dynamicType:String;
        var formatValues:Object = { };
        var sortEvalList:Array;

        if (object === undefined)
        {
            return;
        }

        formatValues.indent = StringUtil.repeat(" ", currentDepth);

        desc = describeType(object);

        evalList = <eval />;
        evalList.appendChild(desc.variable);

        for (dynamicProp in object)
        {
            dynamicType = getQualifiedClassName(object[dynamicProp]);
            evalList.appendChild(<variable name={dynamicProp} type={dynamicType} isDynamic="true" />);
        }

        if (evaluateGetters)
        {
            evalList.appendChild(desc.accessor.(@access=="readonly" ||
                @access=="readwrite"));
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

        sortEvalList = [ ];
        for each (node in evalList.*)
        {
            sortEvalList.push(node);
        }
        sortEvalList.sortOn("@name");

        for each (node in sortEvalList)
        {
            formatValues.name = node.@name;
            formatValues.type = node.@type;

            try {
                formatValues.value = object[formatValues.name];
                output.appendFill(propertyMessage, formatValues);
                recurse(object[formatValues.name], currentDepth + 1, evaluateGetters);
            }
            catch (getterError:Error)
            {
                formatValues.error = getterError;
                formatValues.errorType = DebugUtil.getShortClassName(getterError);
                output.appendFill(propertyErrorMessage, formatValues);
            }
        }
    }
}
}
