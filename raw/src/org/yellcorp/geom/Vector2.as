package org.yellcorp.geom
{
import flash.geom.Point;


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

    public static function copy(source:Vector2, dest:Vector2):void
    {
        dest.x = source.x;
        dest.y = source.y;
    }

    public static function copyToPoint(source:Vector2, dest:Point):void
    {
        dest.x = source.x;
        dest.y = source.y;
    }

    public static function copyFromPoint(source:Point, dest:Vector2):void
    {
        dest.x = source.x;
        dest.y = source.y;
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
        scale(1 / magnitude());
    }

    // Setter operators (this = A op B)

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
        setScale(a, 1 / a.magnitude());
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

    public function isEpsilon(e:Number):Boolean
    {
        return (x < e) && (x > -e) &&
               (y < e) && (y > -e);
    }
}
}
