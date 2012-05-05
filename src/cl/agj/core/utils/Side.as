package cl.agj.core.utils {
	
	/**
	 * Constants to define sides. Combine them using the binary OR operator (|), like this:
	 * Side.UP | Side.RIGHT | Side.DOWN
	 */
	public class Side {
		
		public static const NONE:uint = 0;
		
		public static const UP:uint = 1;
		public static const RIGHT:uint = 2;
		public static const DOWN:uint = 4;
		public static const LEFT:uint = 8;
		public static const FRONT:uint = 16;
		public static const BACK:uint = 32;
		
	}
}