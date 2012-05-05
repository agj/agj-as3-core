package cl.agj.core.utils {
	
	public class Callback {
		
		public var func:Function;
		public var context:*;
		public var params:Array;
		
		public function Callback(func:Function, context:* = null, ... params) {
			this.func = func;
			this.context = context;
			this.params = params;
		}
		
	}
}