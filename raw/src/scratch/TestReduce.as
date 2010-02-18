package scratch
{
import org.yellcorp.array.ArrayUtil;
import org.yellcorp.env.ConsoleApp;


public class TestReduce extends ConsoleApp
{
    public function TestReduce()
    {
        super();
        run();
    }

    private function run():void
    {
        var a:Array = [1, 2, 3, 4, 5, 6, 7];
        var result:Number = ArrayUtil.reduce(a, add, 100);

        writeln(a," ",result);
    }

    private function add(a:Number, b:Number):Number
    {
        return a+b;
    }
}
}
