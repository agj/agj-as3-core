package cl.agj.core.functional {
	
	public function equals(value:*):Function {
		return function (value2:*, ...rest):* {
			return value === value2;
		};
	}
	
}
