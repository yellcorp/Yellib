package org.yellcorp.lib.geom
{
public class Vector2
{
    public var x:Number;
    public var y:Number;

    public function Vector2(cx:Number = 0, cy:Number = 0)
    {
        x = cx;
        y = cy;
    }

    // Object management

    public function clone():Vector2
    {
        return new Vector2(x, y);
    }

    public function clear():void
    {
        x = y = 0;
    }

    public function toString():String
    {
        return "{" + x + ", " + y + "}";
    }

    public function setValues(newX:Number, newY:Number):void
    {
        x = newX;
        y = newY;
    }

    // Mutators

    public function add(v:Vector2):void
    {
        x += v.x;
        y += v.y;
    }

    public function negate():void
    {
        x = -x;
        y = -y;
    }

    public function subtract(v:Vector2):void
    {
        x -= v.x;
        y -= v.y;
    }

    public function scale(s:Number):void
    {
        x *= s;
        y *= s;
    }

    public function normalize():void
    {
        scale(magInverse());
    }

    // Setter operators (this = A op B)

    public function setEquals(a:Vector2):void
    {
        x = a.x;
        y = a.y;
    }

    public function setAdd(a:Vector2, b:Vector2):void
    {
        x = a.x + b.x;
        y = a.y + b.y;
    }

    public function setSubtract(a:Vector2, b:Vector2):void
    {
        x = a.x - b.x;
        y = a.y - b.y;
    }

    public function setNegative(a:Vector2):void
    {
        x = -a.x;
        y = -a.y;
    }

    public function setScale(a:Vector2, s:Number):void
    {
        x = a.x * s;
        y = a.y * s;
    }

    public function setNormalize(a:Vector2):void
    {
        setScale(a, a.magInverse());
    }

    // Scalar

    public function magnitude():Number
    {
        return Math.sqrt(x * x + y * y);
    }

    public function magSquared():Number
    {
        return x * x + y * y;
    }

    public function magInverse():Number
    {
        return 1 / Math.sqrt(x * x + y * y);
    }

    public function dot(w:Vector2):Number
    {
        return x * w.x + y * w.y;
    }

    // Boolean

    public function isZero():Boolean
    {
        return x == 0 && y == 0;
    }

    public function isfinite():Boolean
    {
        return isFinite(x) && isFinite(y);
    }

    public function isNearZero(epsilon:Number):Boolean
    {
        return x < epsilon && x > -epsilon &&
               y < epsilon && y > -epsilon;
    }

    public static function isEqual(a:Vector2, b:Vector2):Boolean
    {
        if (!a && !b)
        {
            return true;
        }
        else if (!a || !b)
        {
            return false;
        }
        else
        {
            return a.x == b.x && a.y == b.y;
        }
    }

    public static function isClose(a:Vector2, b:Vector2, epsilon:Number):Boolean
    {
        var dx:Number;
        var dy:Number;

        // different semantics to isEqual: an absence of both
        // vectors means equality, but is a null vector 'close' to
        // another null vector? i dunno. i think no.
        if (!a || !b)
        {
            return false;
        }
        else
        {
            dx = a.x - b.x;
            dy = a.y - b.y;
            return dx < epsilon && dx > -epsilon &&
                   dy < epsilon && dy > -epsilon;
        }
    }
}
}
