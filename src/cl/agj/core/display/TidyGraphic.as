package cl.agj.core.display {
	
	import cl.agj.core.events.ITidy;
	import cl.agj.core.events.TidyDelegate;
	
	import flash.events.IEventDispatcher;
	
	public class TidyGraphic extends Graphic implements ITidy {
		
		private var _tidyDelegate:TidyDelegate;
		
		public function TidyGraphic() {
			_tidyDelegate = new TidyDelegate(this);
			super();
		}
		
		/////////
		
		override public function destroy():void {
			if (isDestroyed)
				return;
			_tidyDelegate.destroy();
			_tidyDelegate = null;
			super.destroy();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_tidyDelegate.addEventListener(type, listener, useCapture, priority, useWeakReference);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_tidyDelegate.addEventListenerOnce(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if (!_tidyDelegate)
				return;
			_tidyDelegate.removeEventListener(type, listener, useCapture);
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeEventsForListener(listener:Function):void {
			if (!_tidyDelegate)
				return;
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
		
		protected function hasRegisteredListener(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):Boolean {
			return _tidyDelegate.hasRegisteredListener(object, eventType, listener, useCapture);
		}
		
	}
}