package cl.agj.core.display  {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cl.agj.core.IDestroyable;
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.utils.Tools;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;

	/**
	 * Extends Sprite and adds a few things that are nice to have in general.
	 * @author agj
	 */
	public class Graphic extends Sprite implements IDestroyable {
		
		protected var _destroyed:DeluxeSignal;
		
		protected var _isDestroyed:Boolean;
		//protected var _destroyableProperties:Vector.<String>;
		
		public function Graphic() {
			if (stage) Tools.callLater(init);
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		protected function addedToStageHandler(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		protected function init():void { }
		
		public function destroy():void {
			if (isDestroyed)
				return;
			if (parent)
				parent.removeChild(this);
			_isDestroyed = true;
			if (_destroyed)
				_destroyed.dispatch(new GenericEvent);
			Destroyer.destroy([_destroyed]);
			_destroyed = null;
		}
		public function get isDestroyed():Boolean {
			return _isDestroyed;
		}
		public function get destroyed():DeluxeSignal {
			if (!_destroyed && !_isDestroyed)
				_destroyed = new DeluxeSignal(this);
			return _destroyed;
		}
		
		
		/////
		
		/*
		protected function registerDestroyables(... properties):void {
			if (!_destroyableProperties)
				_destroyableProperties = new Vector.<String>;
			
			for each (var p:Object in properties) {
				if (p is String) {
					if (this[p as String]) {
						_destroyableProperties.push(p);
					} else {
						throw new Error("Object has no property '" + p + "' to register as destroyable.");
					}
				} else {
					throw new Error("Parameter '" + p + "' is not a string. Register strings as destroyable object parameter names.");
				}
			}
		}
		
		protected function destroyProperties():void {
			var list:Array = [];
			for each (var p:String in _destroyableProperties) {
				if (this[p]) {
					list.push(this[p]);
				}
			}
			Destroyer.destroy(list);
		}
		*/
		
	}

}