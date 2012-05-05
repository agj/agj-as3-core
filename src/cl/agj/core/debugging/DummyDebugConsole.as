package cl.agj.core.debugging {
	import cl.agj.core.Destroyable;
	
	import flash.display.Stage;
	
	public class DummyDebugConsole extends Destroyable implements IDebugConsole {
		
		public function DummyDebugConsole(theStage:Stage, keyToggle:Boolean = false, directionUp:Boolean = true) {
			
		}
		
		public function print(... text):void { }
		
		public function clear():void { }
		
		public function get visible():Boolean { return false; }
		public function set visible(value:Boolean):void { }
		
	}
}