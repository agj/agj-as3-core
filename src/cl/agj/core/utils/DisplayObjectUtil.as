package cl.agj.core.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
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
			return mc.currentLabels.some( function (label:FrameLabel, ...etc):Boolean {
				return label.name === labelName;
			});
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
		
		public static function callOnStop(mc:MovieClip, callback:Function):void {
			var previousFrame:int = mc.currentFrame;
			mc.addEventListener(Event.ENTER_FRAME, function self(e:Event):void {
				if (mc.currentFrame === previousFrame) {
					mc.removeEventListener(Event.ENTER_FRAME, self);
					callback();
				} else {
					previousFrame = mc.currentFrame;
				}
			});
		}
		
		/**
		 * Hace una revisión profunda de todos los padres para revisar si efectivamente el DisplayObject está visible.
		 */
		public static function estaVisible(mc:DisplayObject):Boolean {
			if (!mc.stage)
				return false;
			while (!(mc is Stage)) {
				if (!mc.visible)
					return false;
				mc = mc.parent;
			}
			return true;
		}
		
		/**
		 * Hace una revisión profunda de todos los padres para revisar si efectivamente el DisplayObject está activo al mouse.
		 */
		public static function isMouseEnabled(mc:InteractiveObject):Boolean {
			if (!mc.stage || !mc.mouseEnabled) return false;
			var doc:DisplayObjectContainer = mc.parent;
			while (!(doc is Stage)) {
				if (!doc.mouseChildren) return false;
				doc = doc.parent;
			}
			return true;
		}
		
		public static function detenerHijos(obj:DisplayObjectContainer):void {
			if (obj is MovieClip)
				MovieClip(obj).stop();
			const len:uint = obj.numChildren;
			var hijo:DisplayObject;
			for (var i:uint = 0; i < len; i++) {
				hijo = obj.getChildAt(i);
				if (hijo is DisplayObjectContainer)
					detenerHijos(DisplayObjectContainer(hijo));
			}
		}
		
		public static function desmembrar(obj:DisplayObjectContainer):void {
			var hijo:DisplayObject;
			for (var i:int = obj.numChildren - 1; i >= 0; i--) {
				hijo = obj.getChildAt(i);
				if (hijo is DisplayObjectContainer) {
					desmembrar(DisplayObjectContainer(hijo));
				}
				if (hijo && hijo.parent === obj)
					obj.removeChild(hijo);
			}
		}
		
		public static function callar(obj:DisplayObjectContainer):void {
			if (obj is Sprite)
				Sprite(obj).soundTransform = new SoundTransform(0);
			const len:uint = obj.numChildren;
			var hijo:DisplayObject;
			for (var i:uint = 0; i < len; i++) {
				hijo = obj.getChildAt(i);
				if (hijo is DisplayObjectContainer)
					callar(DisplayObjectContainer(hijo));
			}
		}
		
		public static function pausar(obj:DisplayObjectContainer):void {
			if (!_chequeandoReproduciendo) {
				_chequeandoReproduciendo = new Dictionary(true);
				obj.addEventListener(Event.ENTER_FRAME, chequearReproduciendose);
			}
			
			const len:uint = obj.numChildren;
			var hijo:DisplayObject;
			if (obj is MovieClip) {
				const mc:MovieClip = MovieClip(obj);
				_chequeandoReproduciendo[mc] = mc.currentFrame;
			}
			for (var i:uint = 0; i < len; i++) {
				hijo = obj.getChildAt(i);
				if (hijo is DisplayObjectContainer)
					pausar(hijo as DisplayObjectContainer);
			}
		}
		protected static var _chequeandoReproduciendo:Dictionary;
		protected static var _pausados:Dictionary;
		private static function chequearReproduciendose(e:Event):void {
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, chequearReproduciendose);
			
			if (!_pausados)
				_pausados = new Dictionary(true);
			
			var mc:MovieClip;
			for (var o:Object in _chequeandoReproduciendo) {
				mc = MovieClip(o);
				if (_chequeandoReproduciendo[mc] !== mc.currentFrame) {
					mc.stop();
					_pausados[mc] = true;
				}
			}
			_chequeandoReproduciendo = null;
		}
		
		public static function reanudarPausados():void {
			for (var o:Object in _pausados) {
				o.play();
				delete _pausados[o];
			}
		}
		
	}
}