package org.yellcorp.error
{
import flash.errors.IllegalOperationError;


public class AbstractCallError extends IllegalOperationError
{
    public function AbstractCallError(message:* = "Abstract function call", id:* = 0)
    {
        super(message, id);
        name = "AbstractCallError";
    }
}
}
