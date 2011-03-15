package org.yellcorp.lib.error.chain
{
public class ErrorDescriptor
{
    public var object:*;
    public var message:String;
    public var stackTrace:String;

    public function ErrorDescriptor(object:*, message:String, stackTrace:String = "")
    {
        this.object = object;
        this.message = message;
        this.stackTrace = stackTrace;
    }
}
}
