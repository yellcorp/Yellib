package scratch.lcs
{
import org.yellcorp.lib.core.StringBuilder;
import org.yellcorp.lib.core.StringUtil;

import flash.display.Sprite;


public class LCS extends Sprite
{
    public function LCS()
    {
        var n:int = 5;
        var m:int = 7;

        var x:int, y:int;

        var output:StringBuilder = new StringBuilder();

        for (y = 0; y < m; y++)
        {
            for (x = 0; x < n; x++)
            {
                output.append(StringUtil.padLeft(x - y, 5));
            }
            output.append("\n");
        }

        trace(output.toString());
    }

    public function shortestEditScriptLength(a:Array, b:Array):int
    {
        // just copied from the paper, don't understand it yet

        var m:int = a.length;   // length is poss 1 too many? may need
        var n:int = b.length;   // to subtract 1
        var max:int = m + n;
        var v:Array = new Array(2 * max + 1);

        var d:int;
        var k:int;

        var x:int, y:int;

        for (d = 0; d < max; d++)
        {
            for (k = -d; k < d; k += 2)
            {
                if (k == -d || (k != d && v[k-1 + max] < v[k+1 + max]))
                {
                    x = v[k+1 + max];
                }
                else
                {
                    x = v[k-1 + max] + 1;
                }
                y = x - k;
                while (x < n && y < m && a[x+1] == b[y+1])
                {
                    x++; y++;
                }
                v[k + max] = x;
                if (x >= n && y >= m)
                {
                    return d;
                }
            }
        }
        return -1;
    }
}
}
