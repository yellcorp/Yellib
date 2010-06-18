package org.yellcorp.error
{
public class CausedError extends Error
{
    public var cause:Error;

    public function CausedError(cause:Error, message:* = "", id:* = 0)
    {
        this.cause = cause;
        super(message || cause.message, id);
    }

    public function getErrorChain():Array
    {
        var chain:Array = [ this ];
        var currentError:Error = this;

        do {
            currentError = CausedError(currentError).cause;
            if (currentError) chain.push(currentError);
        } while (currentError is CausedError);

        return chain;
    }
}
}
