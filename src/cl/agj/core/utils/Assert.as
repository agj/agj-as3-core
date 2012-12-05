package cl.agj.core.utils {
	
	/**
	 * Throws errors if any check (passed as Boolean values) failed.
	 */
	public class Assert {
		
		static public function arguments(... checks):void {
			var len:uint = checks.length;
			for (var i:int = 0; i < len; i++) {
				if (!checks[i]) {
					var error:ArgumentError = new ArgumentError();
					error.message = "Failed check number " + (i + 1) + ".";
					trace(error.getStackTrace());
					throw error;
				}
			}
		}
		
	}
}