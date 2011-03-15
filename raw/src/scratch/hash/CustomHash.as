package scratch.hash
{
import wip.yellcorp.lib.hash.Hashable;


public class CustomHash implements Hashable
{
    public var a:Number;
    public var b:String;
    public var c:int;

    public function CustomHash(a:Number, b:String, c:int)
    {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    public function hash():*
    {
        return uint.MAX_VALUE & uint(a*c);
    }

    public function equals(other:*):Boolean
    {
        var typedOther:CustomHash = other as CustomHash;

        return typedOther &&
               a == typedOther.a &&
               b == typedOther.b &&
               c == typedOther.c;
    }
}
}
