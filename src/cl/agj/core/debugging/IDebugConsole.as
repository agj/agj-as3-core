package cl.agj.core.debugging {
	import cl.agj.core.IDestroyable;
	
	import flash.display.Sprite;
	
	
	public interface IDebugConsole extends IDestroyable {
		
		function print(... text):void;
		function clear():void;
		
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		
	}
	
}