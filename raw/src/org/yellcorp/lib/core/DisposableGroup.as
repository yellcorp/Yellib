package org.yellcorp.lib.core
{
import flash.utils.Dictionary;


public class DisposableGroup implements Disposable
{
    private var members:Dictionary;

    public function DisposableGroup()
    {
        reset();
    }

    public function add(newMember:Disposable):void
    {
        members[newMember] = newMember;
    }

    public function remove(member:Disposable):Boolean
    {
        return delete members[member];
    }

    public function dispose():void
    {
        var iter:Disposable;

        for each (iter in members)
        {
            iter.dispose();
        }
        reset();
    }

    private function reset():void
    {
        members = new Dictionary();
    }
}
}
