package cl.agj.core.utils {
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * A collection of static functions for different purposes.
	 * @author agj
	 */
	public class Tools {
		
		static public function openURL(url:String, newWindow:Boolean = false):void {
			navigateToURL(new URLRequest(url), newWindow ? "_blank" : null);
		}
		
		/**
		 * Matches a string against two vectors, one with a list of OR-conditioned required matches,
		 * and another with an AND-conditioned list of forbidden matches. Either of these two vectors are
		 * optional. If no vectors are passed, the function always returns true.
		 */
		static public function multipleStringMatch(string:String, requiredMatches:Vector.<String> = null, forbiddenMatches:Vector.<String> = null):Boolean {
			var okay:Boolean = false;
			var item:String;
			
			if (requiredMatches) {
				for each (item in requiredMatches) {
					if (string.indexOf(item) != -1) {
						okay = true;
						break;
					}
				}
			} else {
				okay = true;
			}
			if (!okay) return false;
			
			if (forbiddenMatches) {
				for each (item in forbiddenMatches) {
					if (string.indexOf(item) != -1) {
						okay = false;
						break;
					}
				}
			}
			return okay;
		}
		
		/**
		 *  Check if we are on debug or release mode. (Copied from Adam Saltsman's Flixel code.)
		 */
		static public function get isDebugBuild():Boolean {
			var err:Error = new Error;
			var re:RegExp = /\[.*:[0-9]+\]/;
			return re.test(err.getStackTrace());
			/*
			try {
				throw new Error("Setting global debug flag...");
			} catch(e:Error) {
				var re:RegExp = /\[.*:[0-9]+\]/;
				return re.test(e.getStackTrace());
			}
			return false;
			*/
		}
		
		/**
		 * Checks if this is playing as a SWF file run by Flash Player.
		 */
		static public function isSWF(stage:Stage):Boolean {
			return (stage.root.loaderInfo.url.search(/.swf$/) >= 0);
		}
		
		/**
		 * Returns a string containing string representations of every property, and property thereof,
		 * of the pased object.
		 */
		static public function examineRecursively(object:Object, prepend:String = "-"):String {
			var result:String = "";
			for (var s:String in object) {
				result += prepend + s + ": " + object[s] + "\n";
				result += examineRecursively(object[s], prepend + "-");
			}
			return result;
		}
		
		/**
		 * Compares two objects strictly by identity, but if they are IComparableByValue, Array, Vector, Rectangle, or Point, they are compared by their value.
		 */
		static public function areEqual(obj1:Object, obj2:Object):Boolean {
			if (obj1 is IComparableByValue) {
				return obj1.equals(obj2);
			}
			if (obj1 is Point && obj2 is Point) {
				return obj1.x === obj2.x && obj1.y === obj2.y;
			}
			if (obj1 is Rectangle && obj2 is Rectangle) {
				return obj1.x === obj2.x && obj1.y === obj2.y && obj1.width === obj2.width && obj1.height === obj2.height;
			}
			if (ListUtil.isList(obj1, false) && ListUtil.isList(obj2, false)) {
				return ListUtil.areEqual(obj1, obj2);
			}
			return obj1 === obj2;
		}
		
		/**
		 * Executes the passed function the next frame. Useful to make sure the screen gets updated before
		 * a processing-intensive operation.
		 */
		static public function callNextFrame(callback:Callback):void {
			if (!_forNextFrame)
				_forNextFrame = new Vector.<Callback>;
			_forNextFrame.push(callback);
			
			if (!_dispatcher)
				_dispatcher = new Shape;
			_dispatcher.addEventListener(Event.ENTER_FRAME, onFrameJump);
		}
		
		static public function callLater(callback:Object, time:uint = 0):void {
			if (!(callback is Function) && !(callback is Callback))
				throw new ArgumentError("Expected Function or Callback object as argument 'callback'.");
			
			var now:uint = getTimer();
			var ringTime:uint = now + time;
			if (!_forLater)
				_forLater = new Dictionary;
			var callbacks:Vector.<Object> = _forLater[ringTime] ||= new Vector.<Object>;
			callbacks.push(callback);
			
			checkAndRestartLaterTimer(false);
			
			/*
			var timer:Timer = new Timer(time, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCallLaterTimer);
			if (!_forLater)
				_forLater = new Dictionary(true);
			_forLater[timer] = callback;
			timer.start();
			*/
		}
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
		
		//////////////
		
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
		
		/*
		static private function onCallLaterTimer(e:TimerEvent):void {
			var timer:Timer = Timer(e.currentTarget);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCallLaterTimer);
			var callback:Callback = _forLater[timer];
			if (!callback)
				return;
			callCallback(callback);
			delete _forLater[timer];
		}
		*/
		
		static private function callCallback(callback:Object):void {
			if (callback is Function) {
				callback();
			} else if (callback is Callback && callback.func) {
				callback.func.apply(callback.context, callback.params ? callback.params : []);
			}
		}
		
	}
	
}