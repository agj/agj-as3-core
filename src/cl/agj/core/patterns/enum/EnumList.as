package cl.agj.core.patterns.enum {
	import cl.agj.core.utils.ListUtil;
	import cl.agj.core.utils.Tools;
	
	import flash.utils.Dictionary;
	
	import org.idmedia.as3commons.lang.IllegalArgumentException;

	/**
	 * Offers a simple way to list Enum elements, for use in classes that extend Enum.
	 * 
	 * @author
	 */
	public dynamic class EnumList extends Array {
		
		/**
		 * @argument list An array of Enum objects.
		 */
		public function EnumList(list:Array) {
			if (!list)
				throw new IllegalArgumentException("list cannot be null.");
			for (var i:int = 0, len:int = list.length; i < len; i++) {
				if (!(list[i] is Enum))
					throw new IllegalArgumentException("Passed value '" + list[i] + "' in list is not of type Enum.");
				this[i] = list[i];
			}
		}
		
		/////
		
		protected var _values:Array;
		public function get values():Array {
			if (!_values) {
				_values = [];
				for (var i:int = 0, len:int = this.length; i < len; i++) {
					_values[i] = Enum(this[i]).value;
				}
			}
			return _values;
		}
		
		protected var _organizedByValue:Dictionary;
		protected function get organizedByValue():Dictionary {
			if (!_organizedByValue) {
				_organizedByValue = new Dictionary;
				for each (var v:Enum in this) {
					if (_organizedByValue[v.value])
						throw new Error("One of the values was used more than once.");
					_organizedByValue[v.value] = v;
				}
			}
			return _organizedByValue;
		}
		
		/////
		
		public function hasValue(value:Object):Boolean {
			return values.indexOf(value) > 0;
		}
		
		public function getByValue(value:Object):Enum {
			return organizedByValue[value];
		}
		
	}
}