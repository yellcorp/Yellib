package scratch
{
import org.yellcorp.env.ConsoleApp;
import org.yellcorp.sequence.Set;


public class TestSet extends ConsoleApp
{
    public function TestSet()
    {
        testCompare();
        testMutators();
        testOperators();
    }

    private function testOperators():void
    {
        var s1:Set = new Set("ABCDEF".split(""));
        var s2:Set = new Set("DEFGHIJ".split(""));

        writeln("s1=", s1);
        writeln("s2=", s2);

        writeln(Set.union(s1, s2).toArray().sort());
        writeln(Set.intersection(s1, s2).toArray().sort());
        writeln(Set.difference(s1, s2).toArray().sort());
        writeln(Set.difference(s2, s1).toArray().sort());
        writeln(Set.symmetricDifference(s1, s2).toArray().sort());

        writeln();
    }

    public function testCompare():void
    {
        var a:Array = "ABCDEF".split("");
        var b:Array = "ABCD".split("");
        var c:Array = "ABCD".split("");

        var s1:Set = new Set(a);
        var s2:Set = new Set(b);
        var s3:Set = new Set(c);

        writeln("s1=", s1, " len=", s1.length);
        writeln("s2=", s2, " len=", s2.length);
        writeln("s3=", s3, " len=", s3.length);

        writeln('s1.contains("A")? ', s1.contains("A"));
        writeln('s1.contains("Z")? ', s1.contains("Z"));

        writeln('s1.isSubsetOf(s2)? ', s1.isSubsetOf(s2));
        writeln('s1.isSupersetOf(s2)? ', s1.isSupersetOf(s2));
        writeln('s2.isSubsetOf(s1)? ', s2.isSubsetOf(s1));
        writeln('s2.isSupersetOf(s1)? ', s2.isSupersetOf(s1));
        writeln('s2.equals(s1)? ', s2.equals(s1));
        writeln('s2.equals(s2)? ', s2.equals(s2));
        writeln('s2.equals(s3)? ', s2.equals(s3));

        writeln();
    }

    public function testMutators():void
    {
        var a:Array = "ABCDEF".split("");
        var b:Array = "ABC".split("");
        var c:Array = "XYZ".split("");

        var s1:Set = new Set(a);
        var s2:Set = new Set(b);
        var s3:Set = new Set(c);

        writeln("s1=", s1);
        writeln("s2=", s2);
        writeln("s3=", s3);

        s1.removeIterable(b);
        writeln(s1);

        s1.addIterable(c);
        writeln(s1);

        s1.removeIterable(s3);
        writeln(s1);

        s1.addIterable(s2);
        writeln(s1);

        writeln();
    }
}
}
