package org.yellcorp.lib.layout.ast.nodes
{
/**
 * @private
 */
public class Setter implements ASTNode
{
    // commented out getFunc - decide later if evaluate should return
    // the value node's result, or the result after retrieving with
    // a getter
//        private var getFunc:Function;
        private var setFunc:Function;
        private var value:ASTNode;
        private var debugName:String;

        //        public function Setter(setFunc:Function, getFunc:Function, value:ASTNode)
        public function Setter(setFunc:Function, value:ASTNode, debugName:String = "unknown")
        {
//            this.getFunc = getFunc;
            this.setFunc = setFunc;
            this.value = value;
            this.debugName = debugName;
        }
        public function evaluate():Number
        {
//            return getFunc();
            var result:Number = value.evaluate();
            setFunc(result);
            return result;
        }
        public function capture():void
        {
            value.capture();
        }
        public function optimize():ASTNode
        {
            value = value.optimize();
            return this;
        }
        public function toString():String
        {
            return "object." + debugName + " = " + value.toString();
        }
    }
}
