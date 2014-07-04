package cl.agj.core.events {
	
	import cl.agj.core.IDestroyable;
	
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	/**
	 * Helps ITidy implementing classes to keep track of event listeners, and to clear them upon destruction.
	 */
	public class TidyDelegate implements IDestroyable {
		
		protected var _destroyed:DeluxeSignal;
		
		protected var _receiver:IEventDispatcher;
		
		protected var _listeners:ListenerList;
		protected var _outboundListeners:ListenerList;
		protected var _singleTriggerListeners:ListenerList;
		
		protected var _isDestroyed:Boolean;
		
		public function TidyDelegate(receiver:IEventDispatcher = null) {
			_receiver = receiver;
			_listeners = new ListenerList;
			if (_receiver)
				_outboundListeners = new ListenerList;
			_singleTriggerListeners = new ListenerList;
		}
		
		/////////
		
		public function destroy():void {
			if (!_isDestroyed) {
				_isDestroyed = true;
				unregisterAllListeners();
				removeAllEventListeners();
				_receiver = null;
				_listeners = null;
				_outboundListeners = null;
				_singleTriggerListeners = null;
				if (_destroyed)
					_destroyed.dispatch(new GenericEvent);
				_destroyed = null;
			}
		}
		public function get isDestroyed():Boolean {
			return _isDestroyed;
		}
		public function get destroyed():DeluxeSignal {
			if (!_destroyed && !_isDestroyed)
				_destroyed = new DeluxeSignal(this);
			return _destroyed;
		}
		
		/**
		 * In order to avoid endless recursion, the receiver object itself must take care of
		 * adding the listener when calling this function, using super.addEventListener().
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (!_receiver)
				return;
			_outboundListeners.add(_receiver, type, listener, useCapture);
		}
		
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (!_receiver)
				return;
			_receiver.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_receiver.addEventListener(type, onEventTriggered, useCapture, int.MIN_VALUE);
			_singleTriggerListeners.add(_receiver, type, listener, useCapture);
			_singleTriggerListeners.add(_receiver, type, onEventTriggered, useCapture);
		}
		
		/**
		 * In order to avoid endless recursion, the receiver object itself must take care of
		 * removing the listener when calling this function, using super.removeEventListener().
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if (!_receiver)
				return;
			_outboundListeners.remove(_receiver, type, listener, useCapture);
		}
		
		/////////
		
		public function registerListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_listeners.add(object, eventType, listener, useCapture);
			object.addEventListener(eventType, listener, useCapture, priority, useWeakReference);
		}
		
		public function registerListenerOnce(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			registerListener(object, eventType, listener, useCapture, priority, useWeakReference);
			registerListener(object, eventType, onEventTriggered, useCapture, int.MIN_VALUE);
			_singleTriggerListeners.add(object, eventType, listener, useCapture);
			_singleTriggerListeners.add(object, eventType, onEventTriggered, useCapture);
		}
		
		public function unregisterListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			object.removeEventListener(eventType, listener, useCapture);
			_listeners.remove(object, eventType, listener, useCapture);
		}
		
		public function unregisterAllListeners(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):void {
			var lvo:ListenerVO;
			for each (lvo in _listeners.getMatchingListeners(object, eventType, listener, useCapture)) {
				unregisterListener(lvo.object, lvo.type, lvo.listener, lvo.useCapture);
			}
		}
		
		public function removeAllEventListeners():void {
			if (!_receiver)
				return;
			var lvo:ListenerVO;
			for each (lvo in _outboundListeners.getList()) {
				_receiver.removeEventListener(lvo.type, lvo.listener, lvo.useCapture);
			}
			_outboundListeners.clear();
		}
		
		public function removeEventsForListener(listener:Function):void {
			if (!_receiver)
				return;
			var lvo:ListenerVO;
			for each (lvo in _outboundListeners.getMatchingListeners(_receiver, null, listener)) {
				_receiver.removeEventListener(lvo.type, lvo.listener, lvo.useCapture);
			}
		}
		
		public function hasRegisteredListener(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):Boolean {
			return (_listeners.getMatchingListeners(object, eventType, listener, useCapture).length > 0);
		}
		
		/////////
		/*
		public function get numEventListeners():int {
			return _outboundListeners.list.length;
		}
		
		public function getEventListenerAt(index:uint):ListenerVO {
			return _outboundListeners.list[index].clone();
		}
		
		public function removeEventListenerAt(index:uint):void {
			var lvo:ListenerVO = _outboundListeners.list[index];
			_receiver.removeEventListener(lvo.type, lvo.listener, lvo.useCapture);
		}
		*/
		/////////
		
		private function onEventTriggered(e:Event):void {
			var type:String = e.type;
			var object:IEventDispatcher = e.target as IEventDispatcher;
			var useCapture:Boolean = (e.eventPhase == EventPhase.CAPTURING_PHASE);
			
			//object.removeEventListener(type, onEventTriggered, useCapture);
			
			var list:Vector.<ListenerVO> = _singleTriggerListeners.getMatchingListeners(object, type, null, useCapture);
			for each (var lvo:ListenerVO in list) {
				if (lvo.object == _receiver)
					_receiver.removeEventListener(lvo.type, lvo.listener, lvo.useCapture);
				else
					unregisterListener(lvo.object, lvo.type, lvo.listener, lvo.useCapture);
				_singleTriggerListeners.remove(lvo.object, lvo.type, lvo.listener, lvo.useCapture);
			}
		}
		
	}
}