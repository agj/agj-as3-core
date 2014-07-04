package cl.agj.core.events {
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * The idea for this didn't work.
	 * @deprecated
	 */
	public class ListenerListUpdated {
		
		public var _list:Dictionary = new Dictionary(true);
		
		public function ListenerListUpdated() {
			
		}
		
		public function add(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			if (!getListener(object, eventType, listener, useCapture)) {
				_list[new ListenerVO(object, eventType, listener, useCapture)] = true;
			}
		}
		
		public function remove(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):void {
			var lvo:ListenerVO = getListener(object, eventType, listener, useCapture);
			if (lvo) {
				delete _list[lvo];
			}
		}
		
		public function clear():void {
			for (var lvo:Object in _list) {
				delete _list[lvo];
			}
		}
		
		public function hasListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false):Boolean {
			if (getListener(object, eventType, listener, useCapture))
				return true;
			return false;
		}
		
		public function getListener(object:IEventDispatcher, eventType:String, listener:Function, useCapture:Boolean):ListenerVO {
			for (var l:Object in _list) {
				var lvo:ListenerVO = l as ListenerVO;
				if (lvo.object === object && lvo.type === eventType && lvo.listener === listener && lvo.useCapture === useCapture) {
					return lvo;
				}
			}
			return null;
		}
		
		/**
		 * You may pass whichever parameters you need and it will generate a Vector of
		 * matching listeners.
		 */
		public function getMatchingListeners(object:IEventDispatcher = null, eventType:String = null, listener:Function = null, useCapture:Object = null):Vector.<ListenerVO> {
			var result:Vector.<ListenerVO> = new Vector.<ListenerVO>;
			var useCaptureIsBoolean:Boolean = (useCapture is Boolean);
			for (var l:Object in _list) {
				var lvo:ListenerVO = l as ListenerVO;
				if ( (!object || object === lvo.object)
					&& (!eventType || eventType === lvo.type)
					&& (!listener || listener === lvo.listener)
					&& (!useCaptureIsBoolean || useCapture === lvo.useCapture)
				) {
					
					result.push(lvo);
				}
			}
			return result;
		}
		
		public function getList():Vector.<ListenerVO> {
			var result:Vector.<ListenerVO> = new Vector.<ListenerVO>;
			for (var l:Object in _list) {
				result.push(l);
			}
			return result;
		}
		
	}
}