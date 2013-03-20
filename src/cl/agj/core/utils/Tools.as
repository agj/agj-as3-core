package cl.agj.core.utils {
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
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
		
		
	}
	
}