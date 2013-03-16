package cl.agj.core.patterns.enum {
	public class Enum {
		
		public function Enum(value:Object) {
			_value = value;
		}
		
		protected var _value:Object;
		public function get value():Object {
			return _value;
		}
		
		public function toString():String {
			return value.toString();
		}
		
	}
}