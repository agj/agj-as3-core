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
		static public function tillNextFrame(callback:Function):void {
			if (!_forNextFrame) _forNextFrame = new Vector.<Function>;
			if (!_dispatcher) _dispatcher = new Shape;
			_forNextFrame.push(callback);
			_dispatcher.addEventListener(Event.ENTER_FRAME, onFrameJump);
		}
		static private var _dispatcher:Shape;
		static private var _forNextFrame:Vector.<Function>;
		static private function onFrameJump(e:Event):void {
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onFrameJump);
			for each (var cb:Function in _forNextFrame) {
				cb();
			}
			_forNextFrame.splice(0, _forNextFrame.length);
		}

		
		static public function tillLater(callback:Function, wait:uint = 0):void {
			var ringTime:uint = getTimer() + wait;
			if (!_forLater) _forLater = new Dictionary;
			var callbacks:Vector.<Object> = _forLater[ringTime] ||= new Vector.<Object>;
			callbacks.push(callback);
			checkAndRestartLaterTimer(false);
			
		}
		static private var _forLater:Dictionary;
		static private var _laterTimer:Timer;
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
						cb();
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
		static private function onLaterTimer(e:TimerEvent):void {
			checkAndRestartLaterTimer();
		}
		
	}
}