package cl.agj.core.events {
	import flash.events.IEventDispatcher;
	
	import cl.agj.core.utils.IComparableByValue;
	
	public class ListenerVO implements IComparableByValue {
		
		public function ListenerVO(object:IEventDispatcher, type:String, listener:Function, useCapture:Boolean) {
			_object = object;
			_type = type;
			_listener = listener;
			_useCapture = useCapture;
		}
		
		/////
		
		protected var _object:IEventDispatcher;
		public function get object():IEventDispatcher {
			return _object;
		}
		
		protected var _type:String;
		public function get type():String {
			return _type;
		}
		
		protected var _listener:Function;
		public function get listener():Function {
			return _listener;
		}
		
		protected var _useCapture:Boolean;
		public function get useCapture():Boolean {
			return _useCapture;
		}
		
		/////
		
		public function clone():ListenerVO {
			return new ListenerVO(object, type, listener, useCapture);
		}
		
		public function equals(obj:IComparableByValue):Boolean {
			if (!(obj is ListenerVO))
				return false;
			var o:ListenerVO = ListenerVO(obj);
			return _object === o.object &&
			       _type === o.type &&
				   _listener === o.listener &&
				   _useCapture === o.useCapture;
		}
		
		public function toString():String {
			return "[ListenerVO for " + object + " " + type + " " + listener + "]";
		}
		
	}
}