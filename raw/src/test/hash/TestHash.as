package test.hash
{
import org.yellcorp.env.ConsoleApp;

import wip.yellcorp.hash.HashMap;


public class TestHash extends ConsoleApp
{
    public function TestHash()
    {
        super();
        test();
    }

    private function test():void
    {
        var h:HashMap = new HashMap();

        h.setItem(new CustomHash(1, "s", 3), "1s3");
        h.setItem(new CustomHash(1, "t", 3), "1t3");
        h.setItem(new CustomHash(Math.PI, "a", 5), "PIa5");

        writeln(h.getItem(new CustomHash(1, "s", 3)));
        writeln(h.getItem(new CustomHash(1, "t", 3)));
        writeln(h.getItem(new CustomHash(Math.PI, "a", 5)));
    }
}
}
