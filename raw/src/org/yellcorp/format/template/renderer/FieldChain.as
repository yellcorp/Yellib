package org.yellcorp.format.template.renderer
{
public class FieldChain implements Renderer
{
    private var fields:Array;

    public function FieldChain(fields:Array)
    {
        this.fields = fields;
    }

    public function render(fieldMap:*):*
    {
        var node:* = fieldMap;

        try {
            for (var i:int = 0; i < fields.length; i++)
            {
                if (node === null || node === undefined)
                {
                    break;
                }
                node = node[fields[i]];
            }
            return node;
        }
        catch (re:ReferenceError)
        {
            return null;
        }
    }

    public function toString():String
    {
        return "FieldChain([ " + fields.map(quote).join(", ") + " ])";
    }

    private static function quote(string:String, x:*, y:*):String
    {
        return '"' + string + '"';
    }
}
}
