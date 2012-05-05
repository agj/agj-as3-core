package cl.agj.core.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class DisplayObjectUtil {
		
		/**
		 * Retains position of DisplayObject on screen.
		 */
		public static function swapParent(obj:DisplayObject, newParent:DisplayObjectContainer):void {
			const position:Point = newParent.globalToLocal(obj.localToGlobal(new Point));
			obj.x = position.x;
			obj.y = position.y;
			newParent.addChild(obj);
		}
		
		public static function moveRegistrationPoint(obj:DisplayObjectContainer, x:Number, y:Number, keepPosition:Boolean = true):void {
			var len:uint = obj.numChildren;
			var child:DisplayObject;
			for (var i:uint = 0; i < len; i++) {
				child = obj.getChildAt(i);
				child.x += x;
				child.y += y;
			}
			if (keepPosition) {
				obj.x -= x;
				obj.y -= y;
			}
		}
		
		public static function getOverlap(mc1:DisplayObject, mc2:DisplayObject):Number {
			var limites1:Rectangle = mc1.getBounds(mc1);
			var limites2:Rectangle = mc2.getBounds(mc1);
			
			if (!limites1.intersects(limites2))
				return 0;
			
			var interseccion:Rectangle = limites1.intersection(limites2);
			var area1:Number = limites1.width * limites1.height;
			var area2:Number = limites2.width * limites2.height;
			var areaInterseccion:Number = interseccion.width * interseccion.height;
			var areaMenor:Number = Math.min(area1, area2);
			
			return areaInterseccion / areaMenor;
		}
		
		public static function areOverlapped(mc1:DisplayObject, mc2:DisplayObject, minFraction:Number = 0.5):Boolean {
			return (getOverlap(mc1, mc2) >= minFraction);
		}
		
		public static function hasLabel(mc:MovieClip, labelName:String):Boolean {
			var labels:Array = mc.currentLabels;
			for each (var label:FrameLabel in labels) {
				if (label.name === labelName)
					return true;
			}
			return false;
		}
		
		/**
		 * (by Senocular)
		 * duplicateDisplayObject
		 * creates a duplicate of the DisplayObject passed.
		 * similar to duplicateMovieClip in AVM1
		 * @param source the display object to duplicate
		 * @param autoAdd if true, adds the duplicate to the display list
		 * in which target was located
		 * @return a duplicate instance of target
		 */
		public static function clone(source:DisplayObject):DisplayObject {
			// create duplicate
			var sourceClass:Class = Object(source).constructor;
			var duplicate:DisplayObject = new sourceClass();
			
			// duplicate properties
			duplicate.transform = source.transform;
			duplicate.filters = source.filters;
			duplicate.cacheAsBitmap = source.cacheAsBitmap;
			duplicate.opaqueBackground = source.opaqueBackground;
			if (source.scale9Grid) {
				var rect:Rectangle = source.scale9Grid;
				duplicate.scale9Grid = rect;
			}
			
			return duplicate;
		}		
		
		public static function callOnStop(mc:MovieClip, callback:Callback):void {
			if (!_waitingForStop)
				_waitingForStop = new Dictionary;
			_waitingForStop[mc] = { callback: callback, ultimoFrame: mc.currentFrame };
			
			mc.addEventListener(Event.ENTER_FRAME, alPasarFrame);
		}
		
		public static function cancelCallOnStop(mc:MovieClip, callback:Callback):void {
			var info:Object;
			for (var keyMC:Object in _waitingForStop) {
				if (keyMC === mc) {
					info = _waitingForStop[keyMC];
					if (info.callback === callback) {
						mc.removeEventListener(Event.ENTER_FRAME, alPasarFrame);
						delete _waitingForStop[mc];
					}
				}
			}
		}
		
		/////
		
		private static var _waitingForStop:Dictionary;
		
		private static function alPasarFrame(e:Event):void {
			var mc:MovieClip = MovieClip(e.currentTarget);
			var info:Object = _waitingForStop[mc];
			var callback:Callback = info.callback;
			var ultimoFrame:uint = info.ultimoFrame;
			
			if (mc.currentFrame === ultimoFrame) {
				mc.removeEventListener(Event.ENTER_FRAME, alPasarFrame);
				delete _waitingForStop[mc];
				callback.func.apply(callback.context, callback.params);
			} else {
				info.ultimoFrame = mc.currentFrame;
			}
		}
		
	}
}