package cl.agj.core.debugging {
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
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
			
			var timestamp:String = "";
			if (useTimestamps) {
				timestamp = "@" + formatTime(getTimer());
			}
			
			if (enableTrace && Capabilities.isDebugger)
				trace("[LOG: " + className + (timestamp ? " " + timestamp : "") + "] " + string);
			
			if (_logged && _logged.numListeners > 0)
				_logged.dispatch(className, (timestamp ? timestamp + " " : "") + string);
		}
		
		/** Returns: className:String, message:String */
		public static function get logged():Signal {
			if (!_logged)
				_logged = new Signal(String, String);
			return _logged;
		}
		
		static private var _useTimestamps:Boolean = false;
		static public function get useTimestamps():Boolean {
			return _useTimestamps;
		}
		static public function set useTimestamps(value:Boolean):void {
			_useTimestamps = value;
		}
		
		/////
		
		static private function formatTime(time:int):String {
			var t:String = time.toString();
			return t.length <= 3 ? t : t.substr(0, -3) + '"' + t.substr(-3);
		}
		
	}
}