package cl.agj.core.utils {
	
	public class ObjectUtil {
		
		static public function keys(obj:Object):Array {
			var result:Array = [];
			for (var key:Object in obj) {
				result.push(key);
			}
			return result;
		}
		
		static public function values(obj:Object):Array {
			var result:Array = [];
			for each (var value:Object in obj) {
				result.push(obj[value]);
			}
			return result;
		}
		
	}
}