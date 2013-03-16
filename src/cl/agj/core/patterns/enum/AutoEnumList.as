package cl.agj.core.patterns.enum {
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.idmedia.as3commons.lang.IllegalArgumentException;
	
	/**
	 * Offers a simple way to list Enum elements, for use in classes that extend Enum.
	 * 
	 * Automatically parses the class you pass in order to find its static constants, becoming a list of them.
	 * Suggested method of use is assigning an instance to a constant property of the Enum-extending class,
	 * but make sure that you type the property AutoEnumList so that it knows to skip itself,
	 * and that the property is listed last (so that the other constants have time to initialize).
	 * 
	 * @author agj
	 */
	public dynamic class AutoEnumList extends EnumList {
		
		/**
		 * @param type The type of the Enum instance you want to list its static constants of.
		 */
		public function AutoEnumList(type:Class) {
			var error:Error
			if (!type)
				error = new IllegalArgumentException("'type' cannot be null.");
			
			var list:Array = [];
			if (!error) {
				var thisClassName:String = getQualifiedClassName(this);
				var description:XML = describeType(type);
				for each (var constant:XML in description.constant) {
					var name:String = constant.@name;
					var value:Enum = type[name];
					var propertyClassName:String = constant.@type;
					
					if (propertyClassName === thisClassName)
						continue;
					
					if (value === null) {
						error = new Error("An enum item (" + name + ") is not yet defined. Make sure you make the list the last property of the enum.");
						break;
					}
					if (value["constructor"] !== type) {
						error = new Error("An enum item (" + name + ") is not of the type of its owner class. You either passed the wrong type, or have the wrong type associated to one of its members.");
						break;
					}
					
					list.push(value);
				}
			}
			
			super(list);
			
			if (error)
				throw error;
		}
		
	}
}