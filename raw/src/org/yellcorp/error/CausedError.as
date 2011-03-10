package org.yellcorp.error
{
public class CausedError extends Error implements ErrorChain
{
    public var cause:Error;

    public function CausedError(cause:Error, message:* = "", id:* = 0)
    {
        this.cause = cause;
        super(message || cause.message, id);
        name = "CausedError";
    }

    public function getCauses():Array
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
