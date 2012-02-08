package org.yellcorp.lib.error.chain
{
public class IndirectError extends Error
{
    protected var _cause:*;

    public function IndirectError(cause:*, message:* = "", id:* = 0)
    {
        _cause = cause;
        super(message || ErrorChainUtil.extractErrorText(_cause), id);
        name = "IndirectError";
    }

    public function get cause():*
    {
        return _cause;
    }

    public function getChain():Array
    {
        return ErrorChainUtil.getErrorChain(this);
    }
}
}
