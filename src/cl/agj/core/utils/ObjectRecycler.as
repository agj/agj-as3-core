package cl.agj.core.utils {
	import cl.agj.core.IDestroyable;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Singleton that manages reusable objects, so as to minimize repeated creation and destruction of the same kind
	 * of object. If you implement the IRecyclable interface in your classes, its specific methods will be used
	 * as appropriate.
	 * 
	 * @author agj
	 */
	
	public class ObjectRecycler {
		
		protected var _collection:Dictionary;
		
		private static var _instance:ObjectRecycler;
		private static var _allowInstantiation:Boolean;
		
		public function ObjectRecycler() {
			if (!_allowInstantiation) {
				throw new IllegalOperationError("Use the 'instance' property instead of the 'new' keyword for this singleton class.");
			}
			
			_collection = new Dictionary;
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
			
			var classObj:Class = Class(object.constructor);
			
			var oldNode:LinkedListNode = _collection[classObj];
			_collection[classObj] = new LinkedListNode(object, oldNode ? oldNode : null);
		}
		
		public function get(objectClass:Class, ... parameters):Object {
			var object:Object;
			var node:LinkedListNode = _collection[objectClass];
			
			while (node) {
				object = node.head;
				_collection[objectClass] = object.tail;
				if (object is IDestroyable && object.destroyed) {
					node = node.tail;
					continue;
				}
				if (object is IRecyclable)
					object.activate.apply(null, parameters);
				return object;
			}
			
			object = makeInstance(objectClass, parameters);
			return object;
		}
		
		/////
		
		protected function makeInstance(objectClass:Class, parameters:Array):Object {
			var p:Array = parameters;
			var obj:Object;
			switch (parameters.length) {
				case 0:
					obj = new objectClass();
					break;
				case 1:
					obj = new objectClass(p[0]);
					break;
				case 2:
					obj = new objectClass(p[0], p[1]);
					break;
				case 3:
					obj = new objectClass(p[0], p[1], p[2]);
					break;
				case 4:
					obj = new objectClass(p[0], p[1], p[2], p[3]);
					break;
				case 5:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4]);
					break;
				case 6:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5]);
					break;
				case 7:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
					break;
				case 8:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
					break;
				case 9:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]);
					break;
				case 10:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
					break;
				case 11:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]);
					break;
				case 12:
					obj = new objectClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]);
					break;
				default:
					throw new ArgumentError("Too many parameters passed for object constructor. ObjectRecycler can't handle it for now.");
			}
			return obj;
		}
		
	}
}