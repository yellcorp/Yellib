package org.yellcorp.lib.geom
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
        z = -z;
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
        var n:Number = 1 / Math.sqrt(x * x + y * y + z * z);

        x *= n;
        y *= n;
        z *= n;
    }

    // Setter operators (this = A op B)

    public function setEquals(a:Vector3):void
    {
        x = a.x;
        y = a.y;
        z = a.z;
    }

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
        var n:Number = 1 / Math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z);

        x = a.x * n;
        y = a.y * n;
        z = a.z * n;
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

    public function norm():Number
    {
        return Math.sqrt(x * x + y * y + z * z);
    }

    public function normSquared():Number
    {
        return x * x + y * y + z * z;
    }

    public function normReciprocal():Number
    {
        return 1 / Math.sqrt(x * x + y * y + z * z);
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

    public function isNearZero(epsilon:Number):Boolean
    {
        return x < epsilon && x > -epsilon &&
               y < epsilon && y > -epsilon &&
               z < epsilon && z > -epsilon;
    }

    public static function isEqual(a:Vector3, b:Vector3):Boolean
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
            return a.x == b.x && a.y == b.y && a.z == b.z;
        }
    }

    public static function isClose(a:Vector3, b:Vector3, epsilon:Number):Boolean
    {
        var dx:Number;
        var dy:Number;
        var dz:Number;

        if (!a || !b)
        {
            return false;
        }
        else
        {
            dx = a.x - b.x;
            dy = a.y - b.y;
            dz = a.z - b.z;
            return dx < epsilon && dx > -epsilon &&
                   dy < epsilon && dy > -epsilon &&
                   dz < epsilon && dz > -epsilon;
        }
    }
}
}
