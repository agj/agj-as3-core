package cl.agj.core {
	
	import cl.agj.core.events.ITidy;
	import cl.agj.core.events.TidyDelegate;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	import cl.agj.core.utils.Destroyer;
	
	public class TidyEventDispatcher extends EventDispatcher implements IDestroyable, ITidy {
		
		protected var _tidyDelegate:TidyDelegate;
		
		protected var _isDestroyed:Boolean;
		protected var _destroyed:DeluxeSignal;
		
		public function TidyEventDispatcher() {
			super();
			_tidyDelegate = new TidyDelegate(this);
		}
		
		/////////
		
		public function destroy():void {
			Destroyer.destroy([
				_tidyDelegate
			]);
			_isDestroyed = true;
			if (_destroyed)
				_destroyed.dispatch(new GenericEvent);
			Destroyer.destroy([_destroyed]);
		}
		public function get isDestroyed():Boolean {
			return _isDestroyed;
		}
		public function get destroyed():DeluxeSignal {
			if (!_destroyed)
				_destroyed = new DeluxeSignal(this);
			return _destroyed;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_tidyDelegate.addEventListener(type, listener, useCapture, priority, useWeakReference);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_tidyDelegate.addEventListenerOnce(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_tidyDelegate.removeEventListener(type, listener, useCapture);
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeEventsForListener(listener:Function):void {
			_tidyDelegate.removeEventsForListener(listener);
		}
		
		/////////
		
		protected function registerListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_tidyDelegate.registerListener(object, eventType, listener, useCapture, priority, useWeakReference);
		}
		
		protected function registerListenerOnce(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_tidyDelegate.registerListenerOnce(object, eventType, listener, useCapture, priority, useWeakReference);
		}
		
		protected function unregisterListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			_tidyDelegate.unregisterListener(object, eventType, listener, useCapture);
		}
		
		protected function unregisterAllListeners(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):void {
			_tidyDelegate.unregisterAllListeners(object, eventType, listener, useCapture);
		}
		
		protected function removeAllEventListeners():void {
			_tidyDelegate.removeAllEventListeners();
		}
		
	}
}