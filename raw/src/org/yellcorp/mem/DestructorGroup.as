package org.yellcorp.mem
{
import org.yellcorp.mem.Destructor;

import flash.utils.Dictionary;


public class DestructorGroup implements Destructor
{
    private var members:Dictionary;

    public function DestructorGroup()
    {
        reset();
    }

    public function add(newMember:Destructor):void
    {
        members[newMember] = newMember;
    }

    public function remove(member:Destructor):Boolean
    {
        return delete members[member];
    }

    public function destroy():void
    {
        var iter:Destructor;

        for each (iter in members)
        {
            iter.destroy();
        }
        reset();
    }

    private function reset():void
    {
        members = new Dictionary();
    }
}
}
