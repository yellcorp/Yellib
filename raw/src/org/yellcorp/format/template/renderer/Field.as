package org.yellcorp.format.template.renderer
{
public class Field implements Renderer
{
    private var fieldName:String;

    public function Field(fieldName:String)
    {
        this.fieldName = fieldName;
    }

    public function render(fieldMap:*):*
    {
        return fieldMap[fieldName];
    }

    public function toString():String
    {
        return 'Field("' + fieldName + '")';
    }
}
}
