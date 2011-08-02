package uk.co.creativepartnership.game.gameplay.audio.env
{
import flash.geom.Vector3D;


public class SoundEnvironment
{
    private var position:Vector3D;
    private var facingVector:Vector3D;

    private var attRadius:Number;
    private var attLevel:Number;

    public function SoundEnvironment()
    {
        position = new Vector3D();
        facingVector = new Vector3D();
    }

    public function addEmitter(emitter:SoundEmitter):void
    {
        emitters.push(emitter);
    }

    public function setListenerPosition(x:Number, y:Number, z:Number):void
    {
        setVector(position, x, y, z);
    }

    public function setListenerFacing(vx:Number, vy:Number, vz:Number):void
    {
        setVector(facingVector, vx, vy, vz);
    }

    public function setAttenuation(radius:Number, levelAtRadius:Number):void
    {
        attRadius = radius;
        attLevel = levelAtRadius;
    }

    private static function setVector(target:Vector3D, x:Number, y:Number, z:Number):void
    {
        target.x = x;
        target.y = y;
        target.z = z;
    }
}
}
