package cl.agj.core.utils {
	
	public class Revokable {
		
		public function Revokable(fn:Function) {
			_callable = function (...args):* {
				if (!_revoked) return fn.apply(this, args);
			};
		}
		
		/////
		
		protected var _revoked:Boolean = false;
		
		protected var _callable:Function;
		public function get callable():Function {
			return _callable;
		}
		
		/////
		
		public function revoke():void {
			_revoked = true;
		}
		
	}
	
}