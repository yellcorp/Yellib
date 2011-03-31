package org.yellcorp.lib.collections
{
public class AutoMap extends BaseAutoMap
{
    public var creationFunction:Function = null;

    public function AutoMap(creationFunction:Function = null, initialContents:* = null)
    {
        this.creationFunction = creationFunction;
        super(initialContents);
    }

    protected override function createDefaultValue(name:*):*
    {
        if (creationFunction != null)
        {
            if (creationFunction.length == 0)
            {
                return creationFunction();
            }
            else
            {
                return creationFunction(name);
            }
        }
        else
        {
            return undefined;
        }
    }
}
}
