package org.yellcorp.lib.display.inject
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;


/**
 * A utility that sets the properties of some instance to reference named
 * children of DisplayObjectContainer.
 *
 * The intent is to:
 * <ul>
 *   <li>Maintain a loose coupling between a DisplayObjectContainer and a
 *       class that manipulates it</li>
 *   <li>Reduce the redundancy involved in assigning instance variables or
 *       getChildByName() results of one instance to another</li>
 *   <li>Fail fast and with detail if a DisplayObjectContainer's contents
 *       does not match expectations</li>
 * </ul>
 *
 * The two variables in this process are a DisplayObjectContainer with named
 * children, called the 'container', and an instance of an unrelated class
 * that wants references to the children of the DisplayObjectContainer,
 * called the 'target'.
 *
 * For each qualifying instance variable of the target, the default
 * behaviour of DisplayInjector.inject is:
 * <ul>
 *   <li>Search the container for a child with the same name as the target
 *       variable.</li>
 *   <li>Cast it to the target variable class.</li>
 *   <li>Assign it to the target variable.</li>
 * </ul>
 *
 * A qualifying instance variable is one that is publically accessible and
 * has the metadata tag <code>[Display]</code>.
 *
 * As an example, if a target instance has the following variable:
 *
 * <listing version="3.0">
 * [Display]
 * public var nextButton:Sprite;
 * </listing>
 *
 * Then a call to DisplayInjector.inject(container, target), when
 * discovering this property, will essentially perform the following:
 *
 * <listing version="3.0">
 * target.nextButton = Sprite(container.getChildByName("nextButton"));
 * </listing>
 *
 * Errors are thrown if the container lacks a child by the requested name,
 * or if the child is not of the expected class.
 *
 * The default behaviour can be overridden by adding parameters to the
 * [Display] tag. Supported parameters are:
 *
 * <dl>
 *   <dt><code>name</code></dt>
 *   <dd>Overrides the name used when querying the container. Dot syntax
 *     can be used to reference nested DisplayObjects. For example:
 *     <listing version="3.0">
 *       [Display(name="navBar.nextButton")]
 *       public var nextButton:Sprite;
 *     </listing>
 *     will first search the container for a child called 'navBar', and
 *     then search 'navBar' for a child called 'nextButton'. If any of the
 *     intermediate children are not found, or not DisplayObjectContainers,
 *     an error is thrown.
 *   </dd>
 *
 *   <dt><code>adapter</code></dt>
 *   <dd>Instead of trying to cast the child DisplayObject to the property's
 *     class, use the class as a constructor, with the child DisplayObject
 *     as an argument. For example:
 *     <listing version="3.0">
 *       [Display(adapter)]
 *       public var nextButton:GlowButton;
 *     </listing>
 *     will essentially perform the following:
 *     <listing version="3.0">
 *       target.nextButton = new GlowButton(container.getChildByName("nextButton")));
 *     </listing>
 *     If the property's class is an interface or a base class, the concrete
 *     class can be specified in the value for <code>adapter</code>.
 *     <listing version="3.0">
 *       [Display(adapter="org.yellcorp.ui.GlowButton")]
 *       public var nextButton:IButton;
 *     </listing>
 *     will perform the following:
 *     <listing version="3.0">
 *       target.nextButton = new GlowButton(container.getChildByName("nextButton")));
 *     </listing>
 *     In all cases, the constructor is assumed to take a single argument.
 *   </dd>
 * </dl>
 *
 * TODO: adapter could also specify a static function
 */
public class DisplayInjector
{
    /**
     * Perform a display injection.  Populates qualifying instance
     * variables of <code>target</code> with references to the corresponding
     * children of <code>container</code>.
     *
     * @param container  The DisplayObjectContainer containing named
     *                   children to assign to <code>target</code>.
     * @param target  The instance to populate.
     *
     * @throws org.yellcorp.lib.display.inject.DisplayPathError
     *         If a child with the default or overridden name could not be
     *         found in <code>container</code>.
     *
     * @throws org.yellcorp.lib.display.inject.DisplayPathError
     *         If a child was found but was of an incompatible class.
     *
     * @throws org.yellcorp.lib.display.inject.DisplayMetadataError
     *         If a metadata parameter is invalid.
     */
    public static function inject(container:DisplayObjectContainer, target:*):void
    {
        var type:XML = describeType(target);

        var displayMetadata:XMLList = type.*.(
            name() == "variable" || name() == "accessor").
            metadata.(@name == "Display");

        for each (var metadata:XML in displayMetadata)
        {
            injectProperty(metadata.parent(), metadata, container, target);
        }
    }


    private static function injectProperty(property:XML, metadata:XML,
            source:DisplayObjectContainer, target:*):void
    {
        var args:Object = { name: null, adapter: null };

        try {
            collectArgs(metadata, args);
            var displayPath:String = args.name || property.@name;
            var child:* = getChildByPath(source, displayPath);

            if (args.adapter === "")
            {
                args.adapter = property.@type;
            }

            if (args.adapter !== null)
            {
                child = construct(args.adapter, child);
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

            // [Metadata(paramName="string")]
            // becomes <arg key="paramName" value="string" />

            // but...

            // [Metadata(bareword)]
            // becomes <arg key="" value="bareword" />

            // so swap them
            if (key == "")
            {
                key = value;
                value = "";
            }

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


    private static function construct(adapter:String, displayObject:*):*
    {
        var clazz:Object = getDefinitionByName(adapter);
        return new clazz(displayObject);
    }
}
}
