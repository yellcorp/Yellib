package uk.co.creativepartnership.game.gameplay.audio.env
{
public class SoundEmitter
{
    public var x:Number = 0;
    public var y:Number = 0;
    public var z:Number = 0;

    public function SoundEmitter()
    {
    }

    public function setPosition(x:Number, y:Number, z:Number):void
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
}
