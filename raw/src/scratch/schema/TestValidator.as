package scratch.schema
{
import org.yellcorp.lib.env.ResizableStage;
import org.yellcorp.lib.xml.validator.SchemaValidator;
import org.yellcorp.lib.xml.validator.types.SchemaElement;


public class TestValidator extends ResizableStage
{
    public function TestValidator()
    {
        var v:SchemaValidator = new SchemaValidator(
            new SchemaElement(localDataSchema));

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
