package cl.agj.core.net {
	import com.codecatalyst.promise.Promise;
	
	import org.osflash.signals.DeluxeSignal;

	public interface ILoader {
		
		function get result():Promise;
		function get progressed():DeluxeSignal;
		function get progress():Number;
		function get finished():Boolean;
		
	}
}