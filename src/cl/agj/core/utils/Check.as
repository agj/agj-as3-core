package cl.agj.core.utils {
	
	public class Check {
		
		/**
		 * Checks that the object is of either of the passed classes.
		 */
		static public function isA(obj:Object, ... types):Boolean {
			var ok:Boolean = false;
			for each (var t:Class in types) {
				if (obj is t) {
					ok = true;
					break;
				}
			}
			return ok;
		}
		
		static public function isInRange(num:Number, min:Number, max:Number = Infinity):Boolean {
			return num <= max && num >= min;
		}
		
		/**
		 * Checks that the objects are not null, NaN, or undefined,
		 * but allows for 0 and the empty string.
		 */
		static public function isSet(... objs):Boolean {
			for each (var obj:* in objs) {
				if (obj === null || isNaN(obj) || obj === undefined)
					return false;
			}
			return true;
		}
		
	}
}