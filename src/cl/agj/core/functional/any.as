package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;
	
	public function any(...fns):Function {
		return function (value:*, ...rest):Boolean {
			return fns.some( function (fn:Function, ...rest):* {
				return fn(value);
			});
		};
	}
	
}