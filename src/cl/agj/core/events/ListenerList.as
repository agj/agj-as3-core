package cl.agj.core.events {
	import flash.events.IEventDispatcher;
	
	/**
	 * Used by TidyDelegate to keep track of event listeners.
	 */
	public class ListenerList {
		
		public var _list:Vector.<ListenerVO>;
		
		public function ListenerList() {
			_list = new Vector.<ListenerVO>;
		}
		
		public function add(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			if (getListenerIndex(object, eventType, listener, useCapture) < 0) {
				_list.push(new ListenerVO(object, eventType, listener, useCapture));
			}
		}
		
		public function remove(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			var index:int = getListenerIndex(object, eventType, listener, useCapture);
			if (index >= 0) {
				_list.splice(index, 1);
			}
		}
		
		public function clear():void {
			while (_list.length > 0) {
				_list.pop();
			}
		}
		
		public function hasListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):Boolean {
			if (getListenerIndex(object, eventType, listener, useCapture) >= 0)
				return true;
			
			return false;
		}
		
		public function getListenerIndex(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean):int {
			var lvo:ListenerVO;
			var len:int = _list.length;
			for (var i:int = 0; i < len; i++) {
				lvo = _list[i];
				if (lvo.object === object && lvo.type === eventType && lvo.listener === listener && lvo.useCapture === useCapture) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * You may pass whichever parameters you need and it will generate a Vector of
		 * matching listeners.
		 */
		public function getMatchingListeners(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):Vector.<ListenerVO> {
			var result:Vector.<ListenerVO> = new Vector.<ListenerVO>;
			var useCaptureIsBoolean:Boolean = (useCapture is Boolean);
			for each (var lvo:ListenerVO in _list) {
				if ( (!object || object === lvo.object)
					&& (!eventType || eventType === lvo.type)
					&& (listener == null || listener === lvo.listener)
					&& (!useCaptureIsBoolean || useCapture === lvo.useCapture)
				) {
					
					result.push(lvo);
				}
			}
			return result;
		}
		
		public function getList():Vector.<ListenerVO> {
			return _list;
		}
		
	}
}