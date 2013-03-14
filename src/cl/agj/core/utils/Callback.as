package cl.agj.core.utils {
	
	public class Callback implements IComparableByValue {
		
		public function Callback(func:Function, context:* = null, params:Array = null) {
			_func = func;
			_context = context;
			_params = params;
		}
		
		/////
		
		protected var _func:Function;
		public function get func():Function {
			return _func;
		}
		
		protected var _context:*;
		public function get context():* {
			return _context;
		}
		
		protected var _params:Array;
		public function get params():Array {
			return _params;
		}
		
		/////
		
		public function equals(obj:IComparableByValue):Boolean {
			if (!(obj is Callback))
				return false;
			var o:Callback = Callback(obj);
			return _func === o.func &&
			       _context === o.context &&
				   ListUtil.areEqual(_params, o.params);
		}
		
	}
}