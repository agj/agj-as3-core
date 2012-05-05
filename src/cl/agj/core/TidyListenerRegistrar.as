package cl.agj.core {
	import cl.agj.core.events.TidyDelegate;
	
	import flash.events.IEventDispatcher;
	
	public class TidyListenerRegistrar extends Destroyable {
		
		private var _tidyDelegate:TidyDelegate;
		
		public function TidyListenerRegistrar() {
			_tidyDelegate = new TidyDelegate();
		}
		
		/////////
		
		override public function destroy():void {
			_tidyDelegate.destroy();
			super.destroy();
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
		
		protected function hasRegisteredListener(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):Boolean {
			return _tidyDelegate.hasRegisteredListener(object, eventType, listener, useCapture);
		}
		
	}
}