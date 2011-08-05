package org.yellcorp.lib.display.inject
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;


public class DisplayInjector
{
    public static function inject(display:DisplayObjectContainer, target:*):void
    {
        var type:XML = describeType(target);

        var displayProperties:XMLList = type.*.(
            (hasOwnProperty("metadata") &&
             metadata.@name == "Display" &&
             (name() == "variable" || name() == "accessor")));

        for each (var property:XML in displayProperties)
        {
            injectProperty(property, display, target);
        }
    }


    private static function injectProperty(property:XML,
            display:DisplayObjectContainer, target:*):void
    {
        var args:Object = { name: null };
        collectArgs(property, args);
        var displayPath:String = args.name || property.@name;

        try {
            var child:* = getChildByPath(display, displayPath);
            target[property.@name] = child;
        }
        catch (dpe:DisplayPathError)
        {
            dpe.property = property.@name;
            throw dpe;
        }
        catch (te:TypeError)
        {
            throw new DisplayPathError(te.message, displayPath, property.@name);
        }
    }


    private static function getChildByPath(
            display:DisplayObjectContainer, path:String):*
    {
        var names:Array = path.split(".");
        var resolvedNames:Array = [ ];
        var name:String;

        var child:DisplayObject;
        var context:DisplayObjectContainer = display;

        while (names.length > 0)
        {
            name = names.shift();
            child = context.getChildByName(name);

            if (child)
            {
                resolvedNames.push(name);
                if (names.length > 0)
                {
                    if (child is DisplayObjectContainer)
                    {
                        context = DisplayObjectContainer(child);
                    }
                    else
                    {
                        throw new DisplayPathError("DisplayObject '" +
                            resolvedNames.join(".") +
                            "' is not a DisplayObjectContainer",
                            path);
                    }
                }
            }
            else
            {
                throw new DisplayPathError("DisplayObject '" +
                    resolvedNames.join(".") +
                    "' does not have a child with name '" +
                    name + "'",
                    path);
            }
        }
        return child;
    }


    private static function collectArgs(property:XML, argDict:*):void
    {
        for each (var arg:XML in property.metadata.arg)
        {
            if (argDict.hasOwnProperty(arg.@key))
            {
                argDict[arg.@key] = arg.@value;
            }
            else
            {
                throw new DisplayMetadataError(
                    "Unknown argument in metadata: " + arg.@key,
                    property.@name);
            }
        }
    }
}
}
