package cl.agj.core.utils {
	import flash.display.DisplayObject;
	
	public class Sort {
		
		public static function byYDescending(do1:DisplayObject, do2:DisplayObject):int {
			if (do1.y > do2.y)		return -1;
			if (do1.y < do2.y)		return 1;
			return 0;
		}
		public static function byYAscending(do1:DisplayObject, do2:DisplayObject):int {
			if (do1.y < do2.y)		return -1;
			if (do1.y > do2.y)		return 1;
			return 0;
		}
		
	}
}