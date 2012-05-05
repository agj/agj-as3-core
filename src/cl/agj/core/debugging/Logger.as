package cl.agj.core.debugging {
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	public class Logger {
		
		protected static var _logged:Signal;
		
		public static var enableTrace:Boolean = true;
		public static var useFullClassNames:Boolean = false;
		
		public static function log(object:Object, ... message):void {
			if ((!_logged || _logged.numListeners === 0) && (!enableTrace || !Capabilities.isDebugger))
				return;
			
			const len:uint = message.length;
			for (var i:uint = 0; i < len; i++) {
				if (message[i] === null)
					message[i] = "null";
				else if (message[i] === undefined)
					message[i] = "undefined";
			}
			
			var string:String = message.join(" ");
			
			var className:String = (object != null) ? getQualifiedClassName(object) : "";
			
			if (!useFullClassNames) {
				var index:int = className.indexOf("::");
				if (index >= 0) {
					className = className.substr(index + 2);
				}
			}
			
			if (enableTrace && Capabilities.isDebugger)
				trace("[LOG: " + className + "] " + string);
			
			if (_logged && _logged.numListeners > 0)
				_logged.dispatch(className, string);
		}
		
		/** Returns: className:String, message:String */
		public static function get logged():Signal {
			if (!_logged)
				_logged = new Signal(String, String);
			return _logged;
		}
		
	}
}