package cl.agj.core.utils {
	
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	

	/**
	 * A collection of static functions to use with arrays and vectors.
	 * @author agj
	 */
	public class ListUtil {
		
		public static const VECTOR_CLASS_NAME:String = getQualifiedClassName(Vector);
		
		/**
		 * Returns the first item matching predicate in list.
		 */
		static public function find(list:Object, predicate:Function, thisArg:* = null):* {
			var index:int = findIndex(list, predicate, thisArg);
			return index > -1 ? list[index] : null;
		}
		
		/**
		 * Returns the first item's index matching predicate in list.
		 */
		static public function findIndex(list:Object, predicate:Function, thisArg:* = null):int {
			var argsNum:int = Math.max(predicate.length, 1);
			for (var i:int = 0, len:int = list.length; i < len; i++) {
				if (predicate.apply(thisArg, [list[i], i, list].slice(0, argsNum))) return i;
			}
			return -1;
		}
		
		/**
		 * Returns the last item matching predicate in list.
		 */
		public static function findLast(list:Object, predicate:Function, thisArg:* = null):* {
			var index:int = findLastIndex(list, predicate, thisArg);
			return index > -1 ? list[index] : null;
		}
		
		/**
		 * Returns the last item's index matching predicate in list.
		 * 
		 * @param predicate		function (currentItem:*[, index:int, list]):*;
		 */
		public static function findLastIndex(list:Object, predicate:Function, thisArg:* = null):* {
			var argsNum:int = Math.max(predicate.length, 1);
			for (var i:int = list.length - 1; i >= 0; i--) {
				if (predicate.apply(thisArg, [list[i], i, list].slice(0, argsNum))) return i;
			}
			return -1;
		}
		
		/**
		 * Accumumulates values in list into a single value, using the supplied callback function's return value.
		 * 
		 * @param callback		function (accumulated:*, currentItem:*[, index:int, list]):*;
		 */
		public static function reduce(list:Object, callback:Function, initialValue:* = undefined, thisArg:* = null):* {
			var curr:* = initialValue;
			var i:int = 0;
			if (curr === undefined) {
				curr = list[0];
				i = 1;
			}
			var argsNum:int = Math.max(callback.length, 2);
			for (var len:int = list.length; i < len; i++) {
				if (i in list) curr = callback.apply(thisArg, [curr, list[i], i, list].slice(0, argsNum));
			}
			return curr;
		}
		
		/**
		 * Returns true if object is an Array or a Vector, and optionally checks if it is populated.
		 */
		public static function isList(object:Object, excludeEmpty:Boolean = true):Boolean {
			if (
					(
						(object is Array) ||
						(object is Vector.<*>) ||
						(object is Vector.<uint>) ||
						(object is Vector.<int>) ||
						(object is Vector.<Number>)
					) &&
					(!excludeEmpty || object.length > 0)
				) {
				return true;
			}
			return false;
		}
		
		/**
		 * Checks if the object is a Vector of any type.
		 */
		public static function isVector(object:Object, excludeEmpty:Boolean = true):Boolean {
			if (
				(
					(object is Vector.<*>) ||
					(object is Vector.<uint>) ||
					(object is Vector.<int>) ||
					(object is Vector.<Number>)
				) &&
				(!excludeEmpty || object.length > 0)
			) {
				return true;
			}
			return false;
		}
		
		/**
		 * The advantage over Array and Vector's indexOf is that this takes advantage of IComparableByValue when applicable.
		 */
		public static function indexOf(list:Object, item:Object, fromIndex:uint = 0):int {
			if (!(item is IComparableByValue))
				return list.indexOf(item);
			for (var i:int = fromIndex, len:int = list.length; i < len; i++) {
				if (item.equals(list[i]))
					return i;
			}
			return -1;
		}
		
		/**
		 * Leaves only the first of every redundant item in a list. Modifies the object itself.
		 */
		public static function removeRedundants(list:Object):void {
			for (var i:int = list.length - 1; i >= 0; i--) {
				for (var j:int = i - 1; j >= 0; j--) {
					if (Tools.areEqual(list[i], list[j])) {
						list.splice(i, 1);
						continue;
					}
				}
			}
		}
		
		public static function areEqual(list1:Object, list2:Object):Boolean {
			if (!list1 && !list2)
				return true;
			if (!list1 || !list2 || list1.length !== list2.length)
				return false;
			for (var i:int = 0, len:int = list1.length; i < len; i++) {
				if ( list1[i] !== list2[i] && (!(list1[i] is IComparableByValue) || !IComparableByValue(list1[i]).equals(list2[i])) )
					return false;
			}
			return true;
		}
		
		public static function getRandom(list:Object):* {
			if (isList(list)) {
				return list[MathAgj.random(list.length)];
			}
			return null;
		}
		
		public static function getRandomIndex(list:Object):int {
			if (isList(list)) {
				return MathAgj.random(list.length);
			}
			return -1;
		}
		
		/**
		 * Returns a random item from a list and immediately removes it from the list.
		 */
		public static function getRandomAndRemove(list:Object):* {
			if (isList(list)) {
				var index:int = MathAgj.random(list.length);
				var item:* = list[index];
				list.splice(index, 1);
				return item;
			}
			return null;
		}
		
		/**
		 * @param exclusions	A list or an object not to include in lottery.
		 */
		public static function getRandomExcept(list:Object, exclusions:*):* {
			var index:int = getRandomIndexExcept(list, exclusions);
			if (index >= 0)
				return list[index];
			return null;
		}
		
		/**
		 * @param exclusions	A list or an object not to include in lottery.
		 */
		public static function getRandomIndexExcept(list:Object, exclusions:*):int {
			if (isList(list)) {
				var excList:Boolean = isList(exclusions);
				var choices:Vector.<uint> = new Vector.<uint>;
				var len:int = list.length;
				for (var i:uint = 0; i < len; i++) {
					if (excList) {
						if (exclusions.indexOf(list[i]) < 0)
							choices.push(i);
					} else {
						if (exclusions !== list[i])
							choices.push(i);
					}
				}
				if (choices.length > 0)
					return getRandom(choices);
			}
			return -1;
		}
		
		public static function indexIsWithinBounds(list:Object, index:int):Boolean {
			if (isList(list)) {
				if (index < 0) return false;
				return (index < list.length);
			}
			return false;
		}
		
		public static function getNext(list:Object, item:*, wrapAround:Boolean = true):* {
			return getNextOrPrevItem(list, item, true, wrapAround);
		}
		public static function getPrev(list:Object, item:*, wrapAround:Boolean = true):* {
			return getNextOrPrevItem(list, item, false, wrapAround);
		}
		
		public static function getNextIndex(list:Object, item:*, wrapAround:Boolean = true):int {
			return getNextOrPrevIndex(list, item, true, wrapAround);
		}
		public static function getPrevIndex(list:Object, item:*, wrapAround:Boolean = true):int {
			return getNextOrPrevIndex(list, item, false, wrapAround);
		}
		
		public static function getLast(list:Object):* {
			if (isList(list))
				return list[list.length - 1];
			return null;
		}
		
		/**
		 * Add an item to a list using parameters as if it were a two-dimensional list.
		 * The list's length must be width * height.
		 */
		public static function set2D(list:Object, value:*, x:uint, y:uint, width:uint):void {
			var index:int = x + (y * width);
			if (index < list.length)
				list[index] = value;
			else
				throw new ArgumentError("The resulting index exceeds the length of the passed list.");
		}
		
		/**
		 * Get an item from a list using parameters as if it were a two-dimensional list.
		 * The list's length must be width * height.
		 */
		public static function get2D(list:Object, x:uint, y:uint, width:uint):* {
			if (x >= width)
				return null;
			var index:int = x + (y * width);
			if (index < list.length)
				return list[index];
			return null;
		}
		
		public static function get2DIndex(list:Object, x:uint, y:uint, width:uint):int {
			var index:int = x + (y * width);
			if (index < list.length)
				return index;
			return -1;
		}
		
		/**
		 * Removes all instances of an item in a list.
		 */
		public static function remove(list:Object, item:*):void {
			if (isList(list)) {
				var index:int;
				while (true) {
					index = list.indexOf(item);
					if (index >= 0)
						list.splice(index, 1);
					else
						break;
				}
			}
		}
		
		public static function flatten(list:Object, levels:int = 0):Array {
			return reduce(list, function (result:Array, item:*):Array {
				if (isList(item)) {
					return result.concat(
						levels <= 0 || levels > 1 ?
							flatten(item, levels - 1)
							: item
					);
				}
				result.push(item);
				return result;
			}, []);
		}
		
		public static function has(list:Object, item:*):Boolean {
			return (indexOf(list, item) >= 0);
		}
		
		/**
		 * Takes an object and converts it to an array. Particularly useful for vectors; other objects are just wrapped in an array.
		 */
		public static function toArray(obj:Object):Array {
			if (isVector(obj, false)) {
				var array:Array = [];
				for (var i:int = 0, len:int = obj.length; i < len; i++) {
					array[i] = obj[i];
				}
				return array;
			}
			return [obj];
		}
		
		/**
		 * Use this to create a Vector of a type determined at runtime.
		 * 
		 * @param	theClass			Vector type.
		 * @param	fixedLength			Pass an integer over 0 to determine a fixed length for the Vector.
		 * @param	applicationDomain	Useful if using loaded SWFs.
		 */
		public static function makeVector(theClass:Class, fixedLength:uint = 0, applicationDomain:ApplicationDomain = null):Object {
			if (!applicationDomain)
				applicationDomain = ApplicationDomain.currentDomain;
			var definition:Class = applicationDomain.getDefinition(VECTOR_CLASS_NAME + ".<" + getQualifiedClassName(theClass) + ">") as Class;
			if (fixedLength > 0)
				return new definition(fixedLength, true);
			return new definition();
		}
		
		static public function fillAndSet(lista:Object, item:*, index:uint, fillWith:* = null):void {
			if (!isList(lista, false))
				throw new ArgumentError("Argument 'list' is not a list.");
			while (lista.length < index) {
				lista.push(fillWith);
			}
			lista[index] = item;
		}
		
		/////
		
		private static function getNextOrPrevItem(list:Object, item:*, next:Boolean, wrapAround:Boolean):* {
			var index:int = getNextOrPrevIndex(list, item, next, wrapAround);
			if (index >= 0)
				return list[index];
			return null;
			
			/*if (isList(list)) {
				var index:int = list.lastIndexOf(item);
				if (index < 0) return null;
				index += (next) ? 1 : -1;
				if (index < 0) {
					if (wrapAround) index = list.length - 1;
					else return null;
				} else if (index >= list.length) {
					if (wrapAround) index = 0;
					else return null;
				}
				return list[index];
			}
			return null;*/
		}
		
		private static function getNextOrPrevIndex(list:Object, item:*, next:Boolean, wrapAround:Boolean):int {
			if (isList(list)) {
				var index:int = list.lastIndexOf(item);
				if (index < 0) return -1;
				index += (next) ? 1 : -1;
				if (index < 0) {
					if (wrapAround) index = list.length - 1;
					else return -1;
				} else if (index >= list.length) {
					if (wrapAround) index = 0;
					else return -1;
				}
				return index;
			}
			return -1;
		}
		
		static public function permutations(list:Object):Array {
			const len:uint = list.length;
			if (len <= 1)
				return [list];
			var resultado:Array = [];
			for (var i:int = 0; i < len; i++) {
				var excluyente:Array = list.concat();
				excluyente.splice(i, 1);
				var permutaciones:Array = permutations(excluyente);
				for each (var perm:Array in permutaciones) {
					perm.push(list[i]);
				}
				resultado = resultado.concat(permutaciones);
			}
			return resultado;
		}
		
	}

}