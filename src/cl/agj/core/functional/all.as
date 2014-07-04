package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;
	
	public function all(...fns):Function {
		return function (value:*, ...rest):Boolean {
			return fns.every( function (fn:Function, ...rest):* {
				return fn(value);
			});
		};
	}
	
}