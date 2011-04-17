package scratch.gradx
{
import org.yellcorp.lib.color.VectorRGB;
import org.yellcorp.lib.geom.Vector3;

import flash.display.Graphics;
import flash.display.Sprite;


public class GradExtrapolate extends Sprite
{
    public static const EPSILON:Number = 1e-6;
    public static const NEG_EPSILON:Number = -EPSILON;
    public static const EPSILON_PLUS_1:Number = EPSILON + 1;

    public function GradExtrapolate()
    {
        super();

        var p:Vector3 = new Vector3(.7, .2, .4);
        var q:Vector3 = new Vector3(.6, .15, .3);

        var x:Vector3 = new Vector3(1, 0, 0);
        var y:Vector3 = new Vector3(0, 1, 0);
        var z:Vector3 = new Vector3(0, 0, 1);

        var zero:Vector3 = new Vector3();
        var result:Vector3 = new Vector3();

        var intersections:Array = [ ];
        var points:Array;

        if (linePointIntersectionParam(p, q, x, zero, result))
            intersections.push(result.clone());

        if (linePointIntersectionParam(p, q, y, zero, result))
            intersections.push(result.clone());

        if (linePointIntersectionParam(p, q, z, zero, result))
            intersections.push(result.clone());


        if (linePointIntersectionParam(p, q, x, x, result))
            intersections.push(result.clone());

        if (linePointIntersectionParam(p, q, y, y, result))
            intersections.push(result.clone());

        if (linePointIntersectionParam(p, q, z, z, result))
            intersections.push(result.clone());


        points = intersections.filter(withinUnitCube);

        processResults(p, q, points);
    }


    private function processResults(p:Vector3, q:Vector3, points:Array):void
    {
        var pColor:VectorRGB = vec2color(p);
        var qColor:VectorRGB = vec2color(q);
        var colors:Array = points.map(vec2color);

        var g:Graphics = graphics;

        g.beginFill(pColor.getUint24());
        g.drawRect(0, 0, 64, 64);
        g.endFill();

        g.beginFill(qColor.getUint24());
        g.drawRect(64, 0, 64, 64);
        g.endFill();

        var x:Number = 0;
        for each (var c:VectorRGB in colors)
        {
            g.beginFill(c.getUint24());
            g.drawRect(x, 64, 64, 64);
            g.endFill();
            x += 64;
        }
    }

    private function vec2color(q:Vector3, ... ignored):VectorRGB
    {
        return new VectorRGB(q.x * 255, q.y * 255, q.z * 255);
    }


    private static function linePointIntersectionParam(p1:Vector3, p2:Vector3,
        normal:Vector3, pp:Vector3, out:Vector3):Boolean
    {
        var d:Number, n:Number;
        var param:Number;
        var ddelta:Vector3;
        var ndelta:Vector3;

        ndelta = p2.clone();
        ndelta.subtract(p1);
        n = normal.dot(ndelta);

        if (n > NEG_EPSILON && n < EPSILON)
        {
            return false;
        }

        ddelta = pp.clone();
        ddelta.subtract(p1);
        d = normal.dot(ddelta);

        param = d / n;

        out.setScale(ndelta, param);
        out.add(p1);

        return true;
    }


    private static function withinUnitCube(p:Vector3, ... ignored):Boolean
    {
        return p.x >= NEG_EPSILON && p.x <= EPSILON_PLUS_1 &&
               p.y >= NEG_EPSILON && p.y <= EPSILON_PLUS_1 &&
               p.z >= NEG_EPSILON && p.z <= EPSILON_PLUS_1;
    }
}
}
