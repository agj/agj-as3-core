package cl.agj.core.events {
	
	import cl.agj.core.IDestroyable;
	
	import flash.events.IEventDispatcher;
	
	public interface ITidy extends IEventDispatcher, IDestroyable {
		
		function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		
		function removeEventsForListener(listener:Function):void;
		
		//function get numEventListeners():int;
		
		//function getEventListenerAt(index:uint):ListenerVO;
		
		//function removeEventListenerAt(index:uint):void;
		
	}
	
}