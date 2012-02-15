package scratch.colormatrix
{
import org.yellcorp.lib.color.matrix.ColorMatrixFactory;
import org.yellcorp.lib.color.matrix.ColorMatrixUtil;
import org.yellcorp.lib.env.ConsoleApp;


public class TestColorMatrixInvert extends ConsoleApp
{
    public function TestColorMatrixInvert()
    {
        var m:Array = [ 0,  1,  5,  6, 13 ,
                        2,  4,  7, 12, 14 ,
                        3,  8, 11, 15, 18 ,
                        9, 10, 16, 17, 19 ];

        var m_1:Array = ColorMatrixUtil.invert(m);

        var i:Array = ColorMatrixUtil.multiply(m, m_1);

        writeln("m:");
        writeln(ColorMatrixUtil.toString(m));
        writeln("-------");
        writeln("m^-1:");
        writeln(ColorMatrixUtil.toString(m_1));
        writeln("-------");
        writeln("i:");
        writeln(ColorMatrixUtil.toString(i));
        writeln("-------");

        ColorMatrixFactory.makeScreen(0x996633, m);
        ColorMatrixUtil.invert(m, m_1);
        ColorMatrixUtil.multiply(m, m_1, i);

        writeln("m:");
        writeln(ColorMatrixUtil.toString(m));
        writeln("-------");
        writeln("m^-1:");
        writeln(ColorMatrixUtil.toString(m_1));
        writeln("-------");
        writeln("i:");
        writeln(ColorMatrixUtil.toString(i));
        writeln("-------");
    }
}
}
