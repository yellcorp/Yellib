package org.yellcorp.tools
{
import org.yellcorp.lib.format.template.Template;
import org.yellcorp.lib.iterators.map.MapIterator;

import flash.utils.describeType;
import flash.utils.getDefinitionByName;


/**
 * Automatically generates a block of [Event] metadata declarations for
 * each const static String found in a given Event class.  Intended
 * as a development tool and not a runtime library.
 */
public class EventMetadata
{
    private var _eventClass:Class;
    private var _eventClassName:String;
    private var _superClassName:String;
    private var type:XML;

    private static var declarationFormatter:Template =
        new Template('[Event(name="{stringValue}", type="{className}")]');

    /**
     * @private
     */
    public function EventMetadata(eventClass:Class)
    {
        _eventClass = eventClass;
        type = describeType(eventClass);
        _eventClassName = type.factory.@type[0];
        _superClassName = type.factory.extendsClass.@type[0];
    }

    /**
     * @private
     */
    public function get className():String
    {
        return _eventClassName;
    }

    /**
     * @private
     */
    public function get superClassName():String
    {
        return _superClassName;
    }

    /**
     * @private
     */
    public function get eventStrings():Object
    {
        var strings:Object = { };
        var stringNode:XML;
        var stringName:String;

        for each (stringNode in type.constant.(@type=="String"))
        {
            stringName = stringNode.@name;
            strings[stringName] = _eventClass[stringName];
        }
        return strings;
    }

    /**
     * @private
     */
    public function get parent():EventMetadata
    {
        var superClass:Class;
        if (_superClassName)
        {
            superClass = getDefinitionByName(_superClassName) as Class;
            if (superClass)
            {
                return new EventMetadata(superClass);
            }
        }
        return null;
    }

    /**
     * Generates an array of strings containing Event metadata declarations
     * &#x2013; one for each const static String found in the provided event
     * class and its superclasses.
     *
     * @param eventClass  The Class to use as the basis for Event metadata
     *                    declarations.
     * @param stopAtNative  If true, will not include declarations for
     *                      Events native to Flash Player.
     * @return  An Array of Strings, each one an Event metadata declaration.
     */
    public static function generate(eventClass:Class, stopAtNative:Boolean = true):Array
    {
        var decls:Array = [];
        var metadata:EventMetadata = new EventMetadata(eventClass);
        var formatValues:Object = { };

        while (metadata && !(stopAtNative && /^flash\./.test(metadata.className)))
        {
            formatValues.className = metadata.className.replace("::", ".");

            for (var i:MapIterator = new MapIterator(metadata.eventStrings);
                 i.valid; i.next())
            {
                formatValues.stringValue = i.value;
                decls.push(declarationFormatter.fill(formatValues));
            }
            metadata = metadata.parent;
        }
        return decls;
    }
}
}
