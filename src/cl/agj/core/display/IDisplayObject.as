package cl.agj.core.display {
	import flash.display.DisplayObjectContainer;
	import flash.geom.Transform;
	
	
	public interface IDisplayObject {
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get parent():DisplayObjectContainer;
		function get transform():Transform;
		function set transform(value:Transform):void;
		
	}
	
}