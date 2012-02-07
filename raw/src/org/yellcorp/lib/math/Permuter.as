package org.yellcorp.lib.math
{
import org.yellcorp.lib.iterators.readonly.Iterator;


public class Permuter implements Iterator
{
    private var _array:Array;
    private var _subsetLength:int;
    private var _code:Array;
    private var _nextCode:Array;
    private var _valid:Boolean;
    private var _hasNext:Boolean;

    public function Permuter(array:Array, subsetLength:int = -1)
    {
        _array = array;
        if (subsetLength < 0)
        {
            subsetLength = array.length;
        }
        _subsetLength = subsetLength;
        reset();
    }

    public function get valid():Boolean
    {
        return _valid;
    }

    public function get current():*
    {
        if (!_valid) return null;

        var copy:Array = _array.concat();
        var result:Array = new Array(_subsetLength);
        for (var i:int = 0; i < _code.length; i++)
        {
            result[i] = copy.splice(_code[i], 1)[0];
        }
        return result;
    }

    public function next():void
    {
        _valid = _hasNext;

        if (_valid)
        {
            var temp:Array = _code;
            _code = _nextCode;
            _nextCode = temp;
            _hasNext = nextLehmerCode(_array.length, _code, _nextCode);
        }
    }

    public function reset():void
    {
        _valid = _subsetLength > 0  &&
                 _subsetLength <= _array.length  &&
                 _array.length > 0;

        if (_valid)
        {
            _code = new Array(_subsetLength);
            _nextCode = new Array(_subsetLength);
            for (var i:int = 0; i < _subsetLength; i++)
            {
                _code[i] = 0;
            }
            _hasNext = nextLehmerCode(_array.length, _code, _nextCode);
        }
        else
        {
            _code = _nextCode = null;
            _hasNext = false;
        }
    }

    public static function nextLehmerCode(n:int, current:Array, next:Array):Boolean
    {
        if (!current || current.length == 0 || current.length > n) return false;

        var newDigit:int;
        var digitBase:int = n - current.length + 1;
        var carry:int = 1;

        for (var i:int = current.length - 1; i >= 0; i--)
        {
            newDigit = current[i] + carry;
            if (newDigit >= digitBase)
            {
                newDigit = 0;
                carry = 1;
            }
            else
            {
                carry = 0;
            }
            next[i] = newDigit;
            digitBase++;
        }
        return carry == 0;
    }
}
}
