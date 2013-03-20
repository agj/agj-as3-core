package cl.agj.core.utils {
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * Contains static methods that delay the call of a callback.
	 */
	public class Delay {
		
		/**
		 * Executes the passed function the next frame. Useful to make sure the screen gets updated before
		 * a processing-intensive operation.
		 */
		static public function tillNextFrame(callback:Callback):void {
			if (!_forNextFrame)
				_forNextFrame = new Vector.<Callback>;
			_forNextFrame.push(callback);
			
			if (!_dispatcher)
				_dispatcher = new Shape;
			_dispatcher.addEventListener(Event.ENTER_FRAME, onFrameJump);
		}
		
		static public function tillLater(callback:Object, time:uint = 0):void {
			if (!(callback is Function) && !(callback is Callback))
				throw new ArgumentError("Expected Function or Callback object as argument 'callback'.");
			
			var now:uint = getTimer();
			var ringTime:uint = now + time;
			if (!_forLater)
				_forLater = new Dictionary;
			var callbacks:Vector.<Object> = _forLater[ringTime] ||= new Vector.<Object>;
			callbacks.push(callback);
			
			checkAndRestartLaterTimer(false);
		}
		
		/////
		
		static private function checkAndRestartLaterTimer(callOutstanding:Boolean = true):void {
			if (!_laterTimer) {
				_laterTimer = new Timer(0, 1);
				_laterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLaterTimer);
			}
			_laterTimer.stop();
			_laterTimer.reset();
			
			var now:uint = getTimer();
			var next:Number = NaN;
			for (var time:Object in _forLater) {
				if (callOutstanding && time <= now) {
					for each (var cb:Object in _forLater[time]) {
						callCallback(cb);
					}
					delete _forLater[time];
				} else if (time < next || isNaN(next)) {
					next = uint(time);
				}
			}
			if (!isNaN(next)) {
				_laterTimer.delay = Math.max(next - now, 0);
				_laterTimer.start();
			}
		}
		
		static private var _forNextFrame:Vector.<Callback>;
		static private var _laterTimer:Timer;
		static private var _forLater:Dictionary;
		static private var _dispatcher:Shape;
		
		static private function onFrameJump(e:Event):void {
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onFrameJump);
			
			for each (var call:Callback in _forNextFrame) {
				callCallback(call);
			}
			_forNextFrame.splice(0, _forNextFrame.length);
		}
		
		static private function onLaterTimer(e:TimerEvent):void {
			checkAndRestartLaterTimer();
		}
		
		static private function callCallback(callback:Object):void {
			if (callback is Function) {
				callback();
			} else if (callback is Callback && callback.func) {
				callback.func.apply(callback.context, callback.params ? callback.params : []);
			}
		}
		
	}
}