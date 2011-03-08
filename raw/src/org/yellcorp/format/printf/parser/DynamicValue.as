package org.yellcorp.format.printf.parser
{
import org.yellcorp.format.printf.context.AbsoluteArg;
import org.yellcorp.format.printf.context.ConstantArg;
import org.yellcorp.format.printf.context.RelativeArg;
import org.yellcorp.format.printf.context.RenderContext;
import org.yellcorp.format.printf.context.Resolver;
import org.yellcorp.format.printf.lexer.Token;


public class DynamicValue
{
    private var _resolver:Resolver;
    private var _token:Token;
    private var _isSet:Boolean;
    private var _value:*;

    public function DynamicValue()
    {
        clear();
    }

    public function clear():void
    {
        _resolver = new ConstantArg(null);
        _value = undefined;
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

    public function setRelativeIndexArg(index:int, token:Token):void
    {
        setResolver(new RelativeArg(index), token);
    }

    public function resolve(context:RenderContext):void
    {
        _resolver.resolve(context);
    }

    public function getValue(defaultValue:* = null):*
    {
        return _isSet ? _value : defaultValue;
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