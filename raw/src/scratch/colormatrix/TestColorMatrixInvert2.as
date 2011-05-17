package scratch.colormatrix
{
import org.yellcorp.lib.color.matrix.ColorMatrixUtil;
import org.yellcorp.lib.core.ArrayUtil;

import flash.display.Sprite;


public class TestColorMatrixInvert2 extends Sprite
{
    public function TestColorMatrixInvert2()
    {
        var m:Array = [
            .1, .2,  1, 0, 10,
             1, .1, .2, 0, 20,
            .2,  1, .1, 0, 30,
             0,  0,  0, 1,  0,
        ];

        var inv:Array = ColorMatrixUtil.invert(m);

        dumpMatrices(m, inv);
        trace("");

        m = [
            0, 0, 1, 0, 0,
            2, 0, 0, 1, 0,
            0, 1, 0, 0, 0,
            3, 0, 0, 0, 0,
        ];

        inv = ColorMatrixUtil.invert(m);

        dumpMatrices(m, inv);
        trace("");

        // singular.
        m = [
            1, 2, 3, 0, 0,
            2, 4, 6, 0, 0,
            0, 2, 3, 0, 0,
            0, 0, 0, 1, 0,
        ];

        // inv should contain a NaN and return false for CMU.isfinite
        inv = ColorMatrixUtil.invert(m);

        dumpMatrices(m, inv);
        trace(ColorMatrixUtil.isfinite(inv));
    }

    private static function dumpMatrices(from:Array, to:Array):void
    {
        var fromBuffer:Array = [ ];
        var toBuffer:Array = [ ];
        var vertCenter:int;
        var row:int;

        for (row = 0; row < 20; row += 5)
        {
            renderSlice(from, fromBuffer, row, 5);
            renderSlice(to, toBuffer, row, 5);
        }
        vertCenter = int((fromBuffer.length - 1) * .5);

        for (row = 0; row < fromBuffer.length; row++)
        {
            trace(fromBuffer[row] +
                  (row == vertCenter ? " -> " : "    ") +
                  toBuffer[row]);
        }
    }

    private static function renderSlice(matrix:Array, buffer:Array, start:int, length:int):void
    {
        buffer.push("[ " +
            ArrayUtil.mapToMethod(
                matrix.slice(start, start + length),
                "toFixed", [5]
            ).join(", ") +
            " ]"
        );
    }
}
}
