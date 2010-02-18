package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.valid.TypeValidator;

import test.valid.Config;

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;


public class TestValidator extends ConsoleApp
{
    public function TestValidator()
    {
        var tv:TypeValidator = new TypeValidator();
        tv.copy(null, Config.getInstance());
    }
}
}
