package cl.agj.core.functional {
	
	public function prop(name:Object):Function {
		return function (obj:Object, ...rest):* {
			return obj[name];
		};
	}
	
}
