package org.yellcorp.lib.layout.helpers
{
public class Registers
{
    private var regs:Vector.<uint>;

    public function Registers()
    {
        regs = new Vector.<uint>();
    }
    
    public function nextFreeIndex():uint
    {
        regs.push(0);
        return regs.length - 1;
    }
}
}
