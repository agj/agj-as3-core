package cl.agj.core.functional {
	
	public function invoke(name:Object):Function {
		return function (obj:Object, ...rest):* {
			return obj[name].apply(this);
		};
	}
	
}
