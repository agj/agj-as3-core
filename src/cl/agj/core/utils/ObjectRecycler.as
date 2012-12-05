package cl.agj.core.utils {
	import cl.agj.core.IDestroyable;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	/**
	 * Singleton that manages reusable objects, so as to minimize repeated creation and destruction of the same kind
	 * of object. If you implement the IRecyclable interface in your classes, its specific methods will be used
	 * as appropriate.
	 * 
	 * @author agj
	 */
	
	public class ObjectRecycler {
		
		protected var _collection:Dictionary = new Dictionary;
		
		private static var _instance:ObjectRecycler;
		private static var _allowInstantiation:Boolean;
		
		public function ObjectRecycler() {
			if (!_allowInstantiation) {
				throw new IllegalOperationError("Use the 'instance' property instead of the 'new' keyword for this singleton class.");
			}
		}
		
		public static function get instance():ObjectRecycler {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new ObjectRecycler;
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/////
		
		public function relinquish(object:Object):void {
			if (object is IRecyclable)
				IRecyclable(object).sleep();
			
			var type:Class = Class(object.constructor);
			
			var oldNode:LinkedListNode = _collection[type];
			_collection[type] = new LinkedListNode(object, oldNode ? oldNode : null);
		}
		
		public function get(type:Class, ... parameters):Object {
			var object:Object;
			var node:LinkedListNode = _collection[type];
			
			if (!(type is IDestroyable) && parameters.length > 0)
				throw new IllegalOperationError("Non-supported use case: Parameters passed for a type that does not implement IDestroyable.");
			
			while (node) {
				object = node.head;
				_collection[type] = object.tail;
				if (object is IDestroyable && object.destroyed) {
					node = node.tail;
					continue;
				}
				if (object is IRecyclable)
					object.activate.apply(null, parameters);
				return object;
			}
			
			object = makeInstance(type, parameters);
			return object;
		}
		
		/////
		
		protected function makeInstance(type:Class, parameters:Array):Object {
			var p:Array = parameters;
			var obj:Object;
			switch (parameters.length) {
				case 0:
					obj = new type();
					break;
				case 1:
					obj = new type(p[0]);
					break;
				case 2:
					obj = new type(p[0], p[1]);
					break;
				case 3:
					obj = new type(p[0], p[1], p[2]);
					break;
				case 4:
					obj = new type(p[0], p[1], p[2], p[3]);
					break;
				case 5:
					obj = new type(p[0], p[1], p[2], p[3], p[4]);
					break;
				case 6:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5]);
					break;
				case 7:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
					break;
				case 8:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
					break;
				case 9:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
					break;
				case 10:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
					break;
				case 11:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
					break;
				case 12:
					obj = new type(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
					break;
				default:
					throw new IllegalOperationError("Too many parameters (over 12) passed for object constructor.");
			}
			return obj;
		}
		
	}
}