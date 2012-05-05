package cl.agj.core {
	import org.osflash.signals.DeluxeSignal;
	
	
	public interface IDestroyable {
		
		function get destroyed():DeluxeSignal;
		function get isDestroyed():Boolean;
		
		function destroy():void;
		
	}
	
}