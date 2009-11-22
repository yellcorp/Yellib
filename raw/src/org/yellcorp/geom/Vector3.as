package org.yellcorp.geom
{
public class Vector3
{
    public var x:Number;
    public var y:Number;
    public var z:Number;

    public function Vector3(cx:Number = 0, cy:Number = 0, cz:Number = 0)
    {
        x = cx;
        y = cy;
        z = cz;
    }

    // Object management

    public function clone():Vector3
    {
        return new Vector3(x, y, z);
    }

    public static function copy(source:Vector3, dest:Vector3):void
    {
        dest.x = source.x;
        dest.y = source.y;
        dest.z = source.z;
    }

    public function clear():void
    {
        x = y = z = 0;
    }

    public function toString():String
    {
        return "{" + x + ", " + y + ", " + z + "}";
    }

    public function setValues(newX:Number, newY:Number, newZ:Number):void
    {
        x = newX;
        y = newY;
        z = newZ;
    }

    // Mutators

    public function add(v:Vector3):void
    {
        x += v.x;
        y += v.y;
        z += v.z;
    }

    public function negate():void
    {
        x = -x;
        y = -y;
        y = -z;
    }

    public function subtract(v:Vector3):void
    {
        x -= v.x;
        y -= v.y;
        z -= v.z;
    }

    public function scale(s:Number):void
    {
        x *= s;
        y *= s;
        z *= s;
    }

    public function cross(w:Vector3):void
    {
        var vx:Number = x;
        var vy:Number = y;
        var vz:Number = z;

        var wx:Number = w.x;
        var wy:Number = w.y;
        var wz:Number = w.z;

        x = vy * wz - vz * wy;
        y = vz * wx - vx * wz;
        z = vx * wy - vy * wx;
    }

    public function normalize():void
    {
        scale(1 / magnitude());
    }

    // Setter operators (this = A op B)

    public function setAdd(a:Vector3, b:Vector3):void
    {
        x = a.x + b.x;
        y = a.y + b.y;
        z = a.z + b.z;
    }

    public function setSubtract(a:Vector3, b:Vector3):void
    {
        x = a.x - b.x;
        y = a.y - b.y;
        z = a.z - b.z;
    }

    public function setNegative(a:Vector3):void
    {
        x = -a.x;
        y = -a.y;
        z = -a.z;
    }

    public function setScale(a:Vector3, s:Number):void
    {
        x = a.x * s;
        y = a.y * s;
        z = a.z * s;
    }

    public function setNormalize(a:Vector3):void
    {
        setScale(a, 1 / a.magnitude());
    }

    public function setCross(v:Vector3, w:Vector3):void
    {
        var vx:Number = v.x;
        var vy:Number = v.y;
        var vz:Number = v.z;

        var wx:Number = w.x;
        var wy:Number = w.y;
        var wz:Number = w.z;

        x = vy * wz - vz * wy;
        y = vz * wx - vx * wz;
        z = vx * wy - vy * wx;
    }

    // Scalar

    public function magnitude():Number
    {
        return Math.sqrt(x * x + y * y + z * z);
    }

    public function magSquared():Number
    {
        return x * x + y * y + z * z;
    }

    public function dot(w:Vector3):Number
    {
        return x * w.x + y * w.y + z * w.z;
    }

    // Boolean

    public function isZero():Boolean
    {
        return x == 0 && y == 0 && z == 0;
    }

    // lowercase f because isFinite is global top-level yay fun
    public function isfinite():Boolean
    {
        return isFinite(x) && isFinite(y) && isFinite(z);
    }

    public function isEpsilon(e:Number):Boolean
    {
        return (x < e) && (x > -e) &&
               (y < e) && (y > -e) &&
               (z < e) && (z > -e);
    }
}
}
