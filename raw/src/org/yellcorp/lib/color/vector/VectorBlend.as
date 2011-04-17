package org.yellcorp.lib.color.vector
{
import org.yellcorp.lib.geom.Vector3;


public class VectorBlend
{
    public static function multiply(a:Vector3, b:Vector3, out:Vector3 = null):Vector3
    {
        if (!out) out = new Vector3();

        out.x = a.x * b.x;
        out.y = a.y * b.y;
        out.z = a.z * b.z;

        return out;
    }

    public static function screen(a:Vector3, b:Vector3, out:Vector3 = null):Vector3
    {
        if (!out) out = new Vector3();

        out.x = 1 - (1 - a.x) * (1 - b.x);
        out.y = 1 - (1 - a.y) * (1 - b.y);
        out.z = 1 - (1 - a.z) * (1 - b.z);

        return out;
    }

    public static function difference(a:Vector3, b:Vector3, out:Vector3 = null):Vector3
    {
        if (!out) out = new Vector3();

        out.x = Math.abs(a.x - b.x);
        out.y = Math.abs(a.y - b.y);
        out.z = Math.abs(a.z - b.z);

        return out;
    }
}
}
