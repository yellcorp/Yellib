package test.schema
{
import org.yellcorp.env.ResizableStage;
import org.yellcorp.xml.validator.SchemaValidator;
import org.yellcorp.xml.validator.types.SchemaElement;


public class TestValidator extends ResizableStage
{
    public function TestValidator()
    {
        var v:SchemaValidator = new SchemaValidator(
            new SchemaElement(VHADataSchema.schema));

        if (v.validate(vhaDataSample))
        {
            trace("Validate OK");
        }
        else
        {
            trace(v.errors.join("\n"));
        }
    }
}
}
