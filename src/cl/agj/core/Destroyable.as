package cl.agj.core {
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.events.GenericEvent;
	import cl.agj.core.utils.Destroyer;
	
	public class Destroyable implements IDestroyable {
		
		protected var _destroyed:DeluxeSignal;
		
		protected var _isDestroyed:Boolean;
		
		public function destroy():void {
			_isDestroyed = true;
			if (_destroyed)
				_destroyed.dispatch(new GenericEvent);
			Destroyer.destroy([_destroyed]);
			_destroyed = null;
		}
		
		public function get isDestroyed():Boolean {
			return _isDestroyed;
		}
		
		public function get destroyed():DeluxeSignal {
			if (!_destroyed && !_isDestroyed)
				_destroyed = new DeluxeSignal(this);
			return _destroyed;
		}
		
	}
}