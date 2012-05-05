package cl.agj.core.events {
	import flash.events.IEventDispatcher;
	
	public class ListenerVO {
		
		public var object:IEventDispatcher;
		public var type:String;
		public var listener:Function;
		public var useCapture:Boolean;
		
		public function ListenerVO(object:IEventDispatcher, type:String, listener:Function, useCapture:Boolean) {
			this.object = object;
			this.type = type;
			this.listener = listener;
			this.useCapture = useCapture;
		}
		
		public function clone():ListenerVO {
			return new ListenerVO(object, type, listener, useCapture);
		}
		
		public function toString():String {
			return "[ListenerVO for " + object + " " + type + " " + listener + "]";
		}
		
	}
}