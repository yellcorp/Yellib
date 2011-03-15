package org.yellcorp.lib.error
{
import flash.errors.IllegalOperationError;


public class DisposedInstanceError extends IllegalOperationError
{
    public function DisposedInstanceError(message:String = "Instance has been disposed", id:int = 0)
    {
        super(message, id);
        name = "DisposedInstanceError";
    }
}
}
