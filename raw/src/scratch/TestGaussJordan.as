package scratch
{
import org.yellcorp.color.ColorMatrix;
import org.yellcorp.color.ColorMatrixUtil;
import org.yellcorp.color.VectorRGB;
import org.yellcorp.env.ConsoleApp;


public class TestGaussJordan extends ConsoleApp
{
    public function TestGaussJordan()
    {
        /*
        var testMatrix:TestMatrix = new TestMatrix(this);
        testMatrix.eliminate();
        */

        var v:Array = [ 0,  1,  5,  6, 13 ,
                        2,  4,  7, 12, 14 ,
                        3,  8, 11, 15, 18 ,
                        9, 10, 16, 17, 19 ];

        var cm:ColorMatrix = new ColorMatrix(v);
        var icm:ColorMatrix = cm.inverse();

        var i:ColorMatrix = icm.multiply(cm);

        writeln("cm:");
        writeln(cm);
        writeln("-------");
        writeln("icm:");
        writeln(icm);
        writeln("-------");
        writeln("i:");
        writeln(i);
        writeln("-------");

        cm = ColorMatrixUtil.setScreen(VectorRGB.fromUint24(0x996633));
        icm = cm.inverse();
        i = cm.multiply(icm);

        writeln("cm:");
        writeln(cm);
        writeln("-------");
        writeln("icm:");
        writeln(icm);
        writeln("-------");
        writeln("i:");
        writeln(i);
        writeln("-------");
    }
}
}
