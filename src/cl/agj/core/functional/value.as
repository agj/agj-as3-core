package cl.agj.core.functional {
	
	public function value(val:*):Function {
		return function (...rest):* {
			return val;
		};
	}
	
}