package cl.agj.core.utils {
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * A collection of static functions for different purposes.
	 * @author agj
	 */
	public class Tools {
		
		/**
		 * Matches a string against two vectors, one with a list of OR-conditioned required matches,
		 * and another with an AND-conditioned list of forbidden matches. Either of these two vectors are
		 * optional. If no vectors are passed, the function always returns true.
		 */
		public static function multipleStringMatch(string:String, requiredMatches:Vector.<String> = null, forbiddenMatches:Vector.<String> = null):Boolean {
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
		public static function get isDebugBuild():Boolean {
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
		public static function isSWF(stage:Stage):Boolean {
			return (stage.root.loaderInfo.url.search(/.swf$/) >= 0);
		}
		
		/**
		 * Returns a string containing string representations of every property, and property thereof,
		 * of the pased object.
		 */
		public static function examineRecursively(object:Object, prepend:String = "-"):String {
			var result:String = "";
			for (var s:String in object) {
				result += prepend + s + ": " + object[s] + "\n";
				result += examineRecursively(object[s], prepend + "-");
			}
			return result;
		}
		
		/**
		 * Executes the passed function the next frame. Useful to make sure the screen gets updated before
		 * a processing-intensive operation.
		 */
		public static function callNextFrame(callback:Callback):void {
			if (!_forNextFrame)
				_forNextFrame = new Vector.<Callback>;
			_forNextFrame.push(callback);
			
			if (!_dispatcher)
				_dispatcher = new Shape;
			_dispatcher.addEventListener(Event.ENTER_FRAME, onFrameJump);
		}
		
		public static function callLater(callback:Callback, time:uint):void {
			var timer:Timer = new Timer(time, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCallLaterTimer);
			if (!_forLater)
				_forLater = new Dictionary(true);
			_forLater[timer] = callback;
			timer.start();
		}
		
		//////////////
		
		private static var _forNextFrame:Vector.<Callback>;
		private static var _forLater:Dictionary;
		private static var _dispatcher:Shape;
		
		private static function onFrameJump(e:Event):void {
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onFrameJump);
			
			for each (var call:Callback in _forNextFrame) {
				callCallback(call);
			}
			_forNextFrame.splice(0, _forNextFrame.length);
		}
		
		private static function onCallLaterTimer(e:TimerEvent):void {
			var timer:Timer = Timer(e.currentTarget);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCallLaterTimer);
			var callback:Callback = _forLater[timer];
			if (!callback)
				return;
			callCallback(callback);
			delete _forLater[timer];
		}
		
		private static function callCallback(callback:Callback):void {
			if (callback.func !== null)
				callback.func.apply(callback.context, ((callback.params) ? callback.params : []));
		}
		
	}
	
}