package cl.agj.core.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.ISignal;
	import cl.agj.core.IDestroyable;
	
	public class Destroyer {
		
		public static function destroy(destroyables:*):void {
			if (!destroyables) {
				return;
			} else if (!ListUtil.isList(destroyables, false)) {
				throw new Error("Destroyer: Must pass an Array or Vector object. Passed instead:", getQualifiedClassName(destroyables));
			}
			
			if (destroyables.length === 0)
				return;
			
			for each (var d:Object in destroyables) {
				if (d == null)
					continue;
				
				if (d is IDestroyable) {
					IDestroyable(d).destroy();
					//trace("Destroyed IDestroyable", d);
				} else if (d is BitmapData) {
					BitmapData(d).dispose();
					//trace("Destroyed BitmapData", d);
				} else if (d is Bitmap) {
					Bitmap(d).bitmapData.dispose();
					//trace("Destroyed Bitmap", d);
				} else if (d is ISignal) {
					ISignal(d).removeAll();
					//trace("Destroyed Signal", d);
				} else if (d is Timer) {
					Timer(d).stop();
					//trace("Destroyed Timer", d);
				} else if (d is Loader) {
					Loader(d).unloadAndStop(true);
					trace("Destroyed Loader", d);
				} else if (d is DisplayObjectContainer) {
					destroyDisplayObject(DisplayObject(d));
				} else if (ListUtil.isList(d, false)) {
					if (d.length > 0)
						destroy(d);
				} else {
					throw new Error("Destroyer: Object of type " + getQualifiedClassName(d) + " is not destroyable.");
				}
			}
		}
		
		public static function isDestroyable(obj:Object):Boolean {
			return (
				obj is IDestroyable ||
				obj is BitmapData ||
				obj is Bitmap ||
				obj is ISignal ||
				obj is Timer ||
				obj is Loader ||
				obj is DisplayObjectContainer ||
				obj is Callback ||
				ListUtil.isList(obj, false)
			);
		}
		
		/////
		
		protected static function destroyDisplayObject(d:DisplayObject):void {
			if (d is MovieClip) {
				MovieClip(d).stop();
			}
			if (d is DisplayObjectContainer) {
				const doc:DisplayObjectContainer = DisplayObjectContainer(d);
				var i:int = doc.numChildren;
				while (i > 0) {
					i--;
					destroyDisplayObject(doc.getChildAt(i));
				}
			}
		}
		
	}
}