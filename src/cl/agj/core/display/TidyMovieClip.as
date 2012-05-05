package cl.agj.core.display {
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.IDestroyable;
	import cl.agj.core.events.ITidy;
	import cl.agj.core.events.TidyDelegate;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	public dynamic class TidyMovieClip extends MovieClip implements IDestroyable, ITidy {
		
		protected var _destroyed:DeluxeSignal;
		
		protected var _tidyDelegate:TidyDelegate;
		protected var _isDestroyed:Boolean;
		
		public function TidyMovieClip() {
			_tidyDelegate = new TidyDelegate(this);
			super();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		protected function init():void { }
		
		/////////
		
		public function destroy():void {
			if (parent)
				parent.removeChild(this);
			_isDestroyed = true;
			Destroyer.destroy([_tidyDelegate]);
			_tidyDelegate = null;
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