package wip.yellcorp.lib.serial.test
{
public class Implementor implements IInterface
{
    private var _thing:Number;

    public function get thing():Number
    {
        return _thing;
    }

    public function set thing(new_thing:Number):void
    {
        _thing = new_thing;
    }
}
}
