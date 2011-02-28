package scratch
{
import org.yellcorp.debug.DebugUtil;
import org.yellcorp.env.ConsoleApp;

import flash.utils.ByteArray;


public class TestDumpByteArray extends ConsoleApp
{
    public function TestDumpByteArray()
    {
        var testObject:Object = {
            anInt: 3,
            aNumber: Math.PI,
            aDate: new Date(),
            anArray: [ 1, 2.3, "Fart", ["Another", "Array"], { arrayObj: "yes" } ],
            anObject: {
                hmm: "yes"
            },
            string: "A failure of imagination when it comes to amusing debug values"
        };

        var bytes:ByteArray = new ByteArray();
        bytes.writeObject(testObject);

        writeln(DebugUtil.dumpByteArray(bytes, 32));

        writeln(DebugUtil.dumpDisplayTree(this));
    }
}
}
