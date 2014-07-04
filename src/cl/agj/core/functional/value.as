package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;
	
	public function value(val:*):Function {
		return function (...rest):* {
			return val;
		};
	}
	
}