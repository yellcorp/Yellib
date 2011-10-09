package org.yellcorp.lib.format.printf.parser
{
import org.yellcorp.lib.format.printf.context.AbsoluteArg;
import org.yellcorp.lib.format.printf.context.ConstantArg;
import org.yellcorp.lib.format.printf.context.ImplicitArg;
import org.yellcorp.lib.format.printf.context.LastArg;
import org.yellcorp.lib.format.printf.context.RenderContext;
import org.yellcorp.lib.format.printf.context.Resolver;
import org.yellcorp.lib.lex.split.Token;


/**
 * @private
 */
public class DynamicValue
{
    private var _resolver:Resolver;
    private var _token:Token;
    private var _isSet:Boolean;

    public function DynamicValue()
    {
        clear();
    }

    public function clear():void
    {
        _resolver = new ConstantArg(null);
        _token = null;
        _isSet = false;
    }

    public function setConstantValue(value:*, token:Token):void
    {
        setResolver(new ConstantArg(value), token);
    }

    public function setAbsoluteIndexArg(index:int, token:Token):void
    {
        setResolver(new AbsoluteArg(index), token);
    }

    public function setLastArg(token:Token):void
    {
        setResolver(new LastArg(), token);
    }

    public function setImplicitArg(token:Token):void
    {
        setResolver(new ImplicitArg(), token);
    }

    public function resolve(context:RenderContext):void
    {
        try {
            _resolver.resolve(context);
        }
        catch (rangeError:RangeError)
        {
            throw new FormatTokenError(rangeError.message, _token);
        }
    }

    public function getValue(defaultValue:* = null):*
    {
        return _isSet ? _resolver.value : defaultValue;
    }

    public function get token():Token
    {
        return _token;
    }

    public function get isSet():Boolean
    {
        return _isSet;
    }

    private function setResolver(resolver:Resolver, token:Token):void
    {
        _resolver = resolver;
        _token = token;
        _isSet = true;
    }
}
}
