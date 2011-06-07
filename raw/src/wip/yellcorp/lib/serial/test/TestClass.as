package wip.yellcorp.lib.serial.test
{
public class TestClass
{
    public var heresAString:String;
    public var heresAnInt:int;
    public var harkAVector:Vector.<TestCompositeClass>;
    public var ohMyAnInterface:IInterface;
//        public var yikesUntyped:*;

        private var _imAnAccessor:uint;
        private var _mystery:String;

        public function get imAnAccessor():uint
        {
            return _imAnAccessor;
        }

        public function set imAnAccessor(new_imAnAccessor:uint):void
        {
            _imAnAccessor = new_imAnAccessor;
        }

        public function set mysteriousWriteOnlyValue(value:String):void
        {
            _mystery = value;
        }
    }
}
