package wip.yellcorp.lib.serial.test
{
import org.yellcorp.lib.serial.Deserializer;
import org.yellcorp.lib.serial.source.xml.XMLSource;

import flash.display.Sprite;


public class TestDeser extends Sprite
{
    public function TestDeser()
    {
        var target:TestClass = new TestClass();
        var deser:Deserializer = new Deserializer();

        deser.setConstructor(IInterface, function ():* { return new Implementor(); } );

        deser.deserialize(target, new XMLSource(testClassDocument));
        trace(target);
    }
}
}
