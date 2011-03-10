package org.yellcorp.error
{
import flash.errors.IllegalOperationError;


public class DestroyedInstanceError extends IllegalOperationError
{
    public function DestroyedInstanceError(message:String = "Cannot call this method on a destroyed instance", id:int = 0)
    {
        super(message, id);
        name = "DestroyedInstanceError";
    }
}
}
