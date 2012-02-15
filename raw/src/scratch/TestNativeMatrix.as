package scratch
{
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;


public class TestNativeMatrix extends Sprite
{
    public function TestNativeMatrix()
    {
        // The lesson is A.concat(B) == B . A

        var A:Matrix = new Matrix(2, -5, -11, 17, 0.5, 0.25);
        var B:Matrix = new Matrix(3, -7, -13, 19, 0.125, 0.0625);
        var p:Point = new Point(23, 29);

        var expect_AB:Matrix = new Matrix(83, -134, -235, 388, 0.0625, 0.6875);
        var expect_BA:Matrix = new Matrix(71, -109, -254, 400, -1.625, 1.3125);

        var BA:Matrix = A.clone();
        BA.concat(B);
        compareMatrix(BA, expect_BA);

        var AB:Matrix = B.clone();
        AB.concat(A);
        compareMatrix(AB, expect_AB);
    }

    private function compareMatrix(got:Matrix, expect:Matrix):void
    {
        trace("expect: " + expect);
        trace("got:    " + got);
        compareProp(got, expect, 'a');
        compareProp(got, expect, 'b');
        compareProp(got, expect, 'c');
        compareProp(got, expect, 'd');
        compareProp(got, expect, 'tx');
        compareProp(got, expect, 'ty');
    }

    private function compareProp(got:Matrix, expect:Matrix, prop:String):void
    {
        trace("Property " + prop + ": " +
              (got[prop] == expect[prop] ? "PASS" : "FAIL"));
    }
}
}
