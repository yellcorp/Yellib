package org.yellcorp.lib.display.inject
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;


public class DisplayInjector
{
    public static function inject(display:DisplayObjectContainer, target:*):void
    {
        var type:XML = describeType(target);

        var displayMetadata:XMLList = type.*.(
            name() == "variable" || name() == "accessor").
            metadata.(@name == "Display");

        for each (var metadata:XML in displayMetadata)
        {
            injectProperty(metadata.parent(), metadata, display, target);
        }
    }


    private static function injectProperty(property:XML, metadata:XML,
            source:DisplayObjectContainer, target:*):void
    {
        var args:Object = { name: null, wrapper: null };

        try {
            collectArgs(metadata, args);
            var displayPath:String = args.name || property.@name;
            var child:* = getChildByPath(source, displayPath);

            if (args.wrapper)
            {
                child = construct(args.wrapper, child);
            }

            target[property.@name] = child;
        }
        catch (die:DisplayInjectorError)
        {
            die.property = property.@name;
            throw die;
        }
        catch (te:TypeError)
        {
            throw new DisplayPathError(te.message, displayPath, property.@name);
        }
    }


    private static function getChildByPath(
            display:DisplayObjectContainer, path:String):*
    //        throws DisplayPathError
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


    private static function collectArgs(metadata:XML, argDict:*):void
    //        throws DisplayMetadataError
    {
        for each (var arg:XML in metadata.arg)
        {
            var key:String = arg.@key;
            var value:String = arg.@value;
            if (argDict.hasOwnProperty(key))
            {
                argDict[key] = value;
            }
            else
            {
                throw new DisplayMetadataError(
                    "Unknown argument in metadata: " + arg.@key);
            }
        }
    }


    private static function construct(wrapper:String, displayObject:*):*
    {
        var clazz:Object = getDefinitionByName(wrapper);
        return new clazz(displayObject);
    }
}
}
