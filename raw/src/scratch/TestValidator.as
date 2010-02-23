package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.valid.TypeValidator;

import scratch.valid.Config;


public class TestValidator extends ConsoleApp
{
    public function TestValidator()
    {
        var tv:TypeValidator = new TypeValidator();
        tv.copy(null, Config.getInstance());
    }
}
}
