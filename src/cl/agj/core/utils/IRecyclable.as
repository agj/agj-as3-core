package cl.agj.core.utils {
	
	/**
	 * Implement this interface in classes whose objects will be managed by ObjectRecycler to more closely
	 * manage what happens when an object is reactivated or relinquished.
	 * 
	 * @author agj
	 */
	public interface IRecyclable {
		
		function sleep():void;
		function activate(... params):void;
		function get asleep():Boolean;
		
	}
	
}